import SwiftUI

struct SettingsView: View {
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var dataManager = DataManager.shared
    
    // We can access user via dataManager.currentUser
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Account Section
                SettingsSection(title: "Account") {
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
                SettingsSection(title: "Language & Region") {
                    if let user = dataManager.currentUser {
                         // Binding wrapper since user is optional
                        let langBinding = Binding<String>(
                            get: { user.primaryLanguage },
                            set: { newValue in
                                user.primaryLanguage = newValue
                                // Trigger save if needed
                            }
                        )
                        
                        Picker("Content Language", selection: langBinding) {
                            ForEach(SupportedLanguage.allCases, id: \.self) { lang in
                                Text(lang.displayName).tag(lang.rawValue)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.indigoPrimary)
                        
                        Text("This affects the generated lesson content and vocabulary.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                // Theme Section
                SettingsSection(title: "Appearance") {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Theme")
                            .font(.subheadline)
                            .foregroundColor(.textSecondaryDark)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(ThemeManager.AppThemePreset.allCases, id: \.self) { theme in
                                    ThemePreviewCard(
                                        theme: theme,
                                        isSelected: ThemeManager.shared.currentTheme == theme
                                    ) {
                                        ThemeManager.shared.currentTheme = theme
                                    }
                                }
                            }
                        }
                    }
                }
                
                // Audio Section
                SettingsSection(title: "Audio") {
                    Toggle("Sound Effects", isOn: $audioManager.soundEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .indigoPrimary))
                    
                    Toggle("Background Music", isOn: $audioManager.musicEnabled)
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
                        // Reset Logic (TODO: Wire up to DataManager reset)
                        // For now just valid UI
                    } label: {
                        Text("Reset All Progress")
                    }
                }
                
                // About
                SettingsSection(title: "About") {
                    HStack {
                        Text("Version")
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
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 8) {
                // Color preview
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(theme.colors.canvas)
                        .frame(width: 80, height: 60)
                    
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
