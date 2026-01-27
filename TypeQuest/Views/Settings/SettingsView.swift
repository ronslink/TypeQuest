import SwiftUI

struct SettingsView: View {
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var dataManager = DataManager.shared
    @ObservedObject private var localizer = Localizer.shared
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                Text("settings".localized)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
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
                
                // Data Section
                SettingsSection(title: "Data") {
                    Button(role: .destructive) {
                        // Reset Logic
                    } label: {
                        Text("reset_progress".localized)
                    }
                    .interactivePress()
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
        .background(Color.canvasDark)
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
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.textTertiaryDark)
                .padding(.leading, 8)
            
            VStack(spacing: 16) {
                content
            }
            .padding()
            .background(Color.surfaceDark)
            .cornerRadius(16)
    }
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
            VStack(spacing: 8) {
                // Color preview
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(theme.colors.canvas)
                        .frame(width: 80, height: 60)
                    
                    if isLocked {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.title2)
                    } else {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(theme.colors.primary)
                                .frame(width: 16, height: 16)
                            Circle()
                                .fill(theme.colors.secondary)
                                .frame(width: 16, height: 16)
                            Circle()
                                .fill(theme.colors.accent)
                                .frame(width: 16, height: 16)
                        }
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? theme.colors.primary : Color.clear, lineWidth: 3)
                )
                
                // Theme name
                HStack(spacing: 4) {
                    Image(systemName: theme.iconName)
                        .font(.caption)
                    Text(theme.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                .foregroundColor(isSelected ? theme.colors.primary : .textSecondaryDark)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SettingsView()
}
