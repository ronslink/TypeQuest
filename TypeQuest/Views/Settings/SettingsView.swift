import SwiftUI

struct SettingsView: View {
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var dataManager = DataManager.shared
    @ObservedObject private var localizer = Localizer.shared
    @EnvironmentObject var navigationManager: NavigationManager
    
    @State private var showResetConfirmation = false
    @State private var showResetSuccess = false

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Header
                Text("settings".localized)
                    .font(AppTypography.h1)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .coordinatedEntrance(delay: 0)
                
                // Account Section
                SettingsSection(title: "account".localized) {
                    if let user = dataManager.currentUser {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(user.username)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Level \(user.currentLevel) • \(user.totalXP) XP")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    } else {
                        Text("No User Logged In")
                            .foregroundColor(.gray)
                    }
                }
                
                // Language & Region
                SettingsSection(title: "language_region".localized) {
                    if let user = dataManager.currentUser {
                        let langBinding = Binding<String>(
                            get: { user.primaryLanguage },
                            set: { newValue in
                                user.primaryLanguage = newValue
                                localizer.currentLanguage = newValue
                                
                                // Auto-switch layout if needed
                                let validLayouts = KeyboardLayout.availableLayouts(for: newValue)
                                if !validLayouts.contains(user.settings?.layout ?? .qwerty) {
                                    user.settings?.layout = KeyboardLayout.defaultFor(language: newValue)
                                }
                                
                                NotificationCenter.default.post(name: NSNotification.Name("UserProfileLoaded"), object: nil)
                            }
                        )
                        
                        let layoutBinding = Binding<KeyboardLayout>(
                            get: { user.settings?.layout ?? .qwerty },
                            set: { newValue in
                                user.settings?.layout = newValue
                            }
                        )
                        
                        Picker("content_language".localized, selection: langBinding) {
                            ForEach(SupportedLanguage.allCases, id: \.self) { lang in
                                Text(lang.displayName).tag(lang.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.indigoPrimary)
                        
                        // Filtered Layout Picker
                        Picker("keyboard_layout".localized, selection: layoutBinding) {
                            ForEach(KeyboardLayout.availableLayouts(for: user.primaryLanguage), id: \.self) { layout in
                                Text(layout.rawValue.uppercased()).tag(layout)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.indigoPrimary)
                        
                        Text("This affects the generated lesson content and keyboard visualization.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                // Theme Section
                SettingsSection(title: "appearance".localized) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Theme")
                            .font(.subheadline)
                            .foregroundColor(.textSecondaryDark)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(ThemeManager.AppThemePreset.allCases, id: \.self) { theme in
                                    let isLocked = theme.isPro && !StoreManager.shared.isPro
                                    ThemePreviewCard(
                                        theme: theme,
                                        isSelected: ThemeManager.shared.currentTheme == theme,
                                        isLocked: isLocked
                                    ) {
                                        if isLocked {
                                            navigationManager.showPaywall = true
                                        } else {
                                            ThemeManager.shared.currentTheme = theme
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Audio Section
                SettingsSection(title: "audio".localized) {
                    Toggle("sound_effects".localized, isOn: $audioManager.soundEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .indigoPrimary))
                    
                    Toggle("background_music".localized, isOn: $audioManager.musicEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .indigoPrimary))
                    
                    if audioManager.soundEnabled {
                        VStack(alignment: .leading) {
                            Text("Volume")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Slider(value: $audioManager.soundVolume)
                                .tint(.indigoPrimary)
                        }
                    }
                }
                
                // Game Center Section
                SettingsSection(title: "Game Center") {
                    if let user = dataManager.currentUser {
                        let gcBinding = Binding<Bool>(
                            get: { user.settings?.gameCenterEnabled ?? false },
                            set: { newValue in
                                user.settings?.gameCenterEnabled = newValue
                                try? dataManager.saveUser()
                                if newValue {
                                    GameCenterManager.shared.authenticate()
                                }
                            }
                        )
                        
                        Toggle("Enable Game Center", isOn: gcBinding)
                            .toggleStyle(SwitchToggleStyle(tint: .indigoPrimary))
                        
                        if user.settings?.gameCenterEnabled == true {
                             if GameCenterManager.shared.isAuthenticated {
                                 HStack {
                                     Image(systemName: "checkmark.circle.fill").foregroundColor(.success)
                                     Text("Signed In as \(GameCenterManager.shared.localPlayer?.alias ?? "Player")")
                                         .font(.caption)
                                         .foregroundColor(.gray)
                                 }
                                 
                                 Button("View Leaderboards") {
                                     GameCenterManager.shared.showLeaderboard()
                                 }
                                 .font(.subheadline)
                             } else if let error = GameCenterManager.shared.error {
                                 Text("Error: \(error)").font(.caption).foregroundColor(.red)
                             } else {
                                 Text("Signing in...").font(.caption).foregroundColor(.gray)
                             }
                        }
                    }
                }
                
                // Cloud Sync Section
                SettingsSection(title: "Cloud Sync") {
                    HStack {
                        Image(systemName: CloudKitManager.shared.isCloudAvailable ? "icloud.fill" : "icloud.slash")
                            .foregroundColor(CloudKitManager.shared.isCloudAvailable ? .success : .textTertiaryDark)
                        Text(CloudKitManager.shared.statusDescription)
                            .foregroundColor(.white)
                        Spacer()
                        if CloudKitManager.shared.isSyncing {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(0.8)
                        }
                    }
                    
                    if let lastSync = CloudKitManager.shared.lastSyncDate {
                        Text("Last synced: \(lastSync.formatted(date: .abbreviated, time: .shortened))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Button {
                        CloudKitManager.shared.triggerSync()
                    } label: {
                        Label("Sync Now", systemImage: "arrow.triangle.2.circlepath")
                    }
                    .disabled(!CloudKitManager.shared.isCloudAvailable)
                }
                
                // Accessibility Section
                SettingsSection(title: "Accessibility") {
                    if let user = dataManager.currentUser, let settings = user.settings {
                        let reduceMotionBinding = Binding<Bool>(
                            get: { settings.reduceMotion },
                            set: { newValue in
                                settings.reduceMotion = newValue
                                try? dataManager.saveUser()
                            }
                        )
                        
                        let highContrastBinding = Binding<Bool>(
                            get: { settings.highContrastMode },
                            set: { newValue in
                                settings.highContrastMode = newValue
                                try? dataManager.saveUser()
                            }
                        )
                        
                        Toggle("Reduce Motion", isOn: reduceMotionBinding)
                            .toggleStyle(SwitchToggleStyle(tint: .indigoPrimary))
                        
                        Toggle("High Contrast Mode", isOn: highContrastBinding)
                            .toggleStyle(SwitchToggleStyle(tint: .indigoPrimary))
                    }
                }
                
                // Data Section
                SettingsSection(title: "Data") {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Reset Progress")
                                .foregroundColor(.error)
                            Text("Clears XP, levels, streaks and all session history. Shop items and settings are kept.")
                                .font(.caption)
                                .foregroundColor(.textTertiaryDark)
                        }
                        Spacer()
                        Button(role: .destructive) {
                            showResetConfirmation = true
                        } label: {
                            Text("Reset…")
                                .foregroundColor(.error)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.error.opacity(0.12))
                        .cornerRadius(8)
                    }
                    .confirmationDialog(
                        "Reset all progress?",
                        isPresented: $showResetConfirmation,
                        titleVisibility: .visible
                    ) {
                        Button("Reset Everything", role: .destructive) {
                            dataManager.resetProgress()
                            showResetSuccess = true
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("This will delete your XP, levels, streaks, and all session history. This cannot be undone. Your shop purchases and settings will be kept.")
                    }
                    .alert("Progress Reset", isPresented: $showResetSuccess) {
                        Button("OK") { }
                    } message: {
                        Text("Your progress has been reset. You're back to Level 1 — time to climb again!")
                    }
                }
                
                // About
                SettingsSection(title: "About") {
                    HStack {
                        Text("version".localized)
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            CloudKitManager.shared.checkAccountStatus()
            // Sync localizer on appear
            if let user = dataManager.currentUser {
                localizer.currentLanguage = user.primaryLanguage
            }
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(AppTypography.caption)
                .fontWeight(.bold)
                .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary.opacity(0.7))
                .tracking(1.2)
                .padding(.leading, 4)
            
            VStack(spacing: 16) {
                content
            }
            .premiumGlassCard(cornerRadius: 16, intensity: 0.1, padding: 20)
        }
        .coordinatedEntrance(delay: 0)
    }
}

// MARK: - Theme Preview Card
struct ThemePreviewCard: View {
    let theme: ThemeManager.AppThemePreset
    let isSelected: Bool
    let isLocked: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 10) {
                // Color preview
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(theme.colors.canvas)
                        .frame(width: 84, height: 64)
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white.opacity(0.9))
                            .font(.title2)
                    } else {
                        HStack(spacing: 5) {
                            Circle()
                                .fill(theme.colors.primary)
                                .frame(width: 18, height: 18)
                                .shadow(radius: 2)
                            Circle()
                                .fill(theme.colors.secondary)
                                .frame(width: 18, height: 18)
                                .shadow(radius: 2)
                            Circle()
                                .fill(theme.colors.accent)
                                .frame(width: 18, height: 18)
                                .shadow(radius: 2)
                        }
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            isSelected ? theme.colors.primary : Color.white.opacity(0.1),
                            lineWidth: isSelected ? 3 : 1
                        )
                )
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(AppAnimation.micro, value: isSelected)
                
                // Theme name
                HStack(spacing: 4) {
                    Image(systemName: theme.iconName)
                        .font(.caption)
                    Text(theme.displayName)
                        .font(AppTypography.bodySmall)
                        .fontWeight(.medium)
                }
                .foregroundColor(isSelected ? theme.colors.primary : ThemeManager.shared.currentTheme.colors.textSecondary)
            }
        }
        .buttonStyle(.plain)
        .pressable()
    }
}

#Preview {
    SettingsView()
}
