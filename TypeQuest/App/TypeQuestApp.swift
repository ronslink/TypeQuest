import SwiftUI
import SwiftData

@main
struct TypeQuestApp: App {
    @StateObject private var dataManager = DataManager.shared
    @State private var isOnboardingComplete: Bool = false

    @StateObject private var navigationManager = NavigationManager()

    var body: some Scene {
        WindowGroup {
            Group {
                if isOnboardingComplete || dataManager.currentUser != nil {
                    ContentView()
                        .environmentObject(dataManager)
                        .environmentObject(navigationManager)
                } else {
                    OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                        .environmentObject(dataManager)
                }
            }
            .preferredColorScheme(.dark)
            .onAppear {
                if let user = dataManager.currentUser, user.settings?.gameCenterEnabled == true {
                    GameCenterManager.shared.authenticate()
                }
            }
        }
        // Minimum window size — premium macOS apps enforce sensible minimums
        .defaultSize(width: 1100, height: 720)
        // Unified compact toolbar merges titlebar and toolbar chrome (Linear/Craft style)
        .windowToolbarStyle(.unified(showsTitle: false))
        .commands {
            // Adds "View > Show/Hide Sidebar" menu item and Cmd+Ctrl+S shortcut
            SidebarCommands()
            TypeQuestCommands(navigationManager: navigationManager)
        }

        // Dedicated Settings window — opens via Cmd+, (system default on macOS)
        Settings {
            SettingsView()
                .environmentObject(dataManager)
                .environmentObject(navigationManager)
                .frame(minWidth: 520, minHeight: 500)
        }
    }
}

struct TypeQuestCommands: Commands {
    @ObservedObject var navigationManager: NavigationManager

    var body: some Commands {
        CommandGroup(after: .newItem) {
            Button("Restart Session") {
                navigationManager.restartSession()
            }
            .keyboardShortcut("r", modifiers: .command)

            Button("Pause / Resume") {
                navigationManager.togglePause()
            }
            .keyboardShortcut(".", modifiers: .command)
        }

        CommandMenu("Navigate") {
            Button("Practice") {
                navigationManager.navigate(to: .practice)
            }
            .keyboardShortcut("1", modifiers: .command)

            Button("Curriculum") {
                navigationManager.navigate(to: .curriculum)
            }
            .keyboardShortcut("2", modifiers: .command)

            Button("Arcade Games") {
                navigationManager.navigate(to: .games)
            }
            .keyboardShortcut("3", modifiers: .command)

            Button("Statistics") {
                navigationManager.navigate(to: .stats)
            }
            .keyboardShortcut("4", modifiers: .command)

            Button("Shop") {
                navigationManager.navigate(to: .shop)
            }
            .keyboardShortcut("5", modifiers: .command)

            Divider()

            Button("Leaderboards") {
                navigationManager.navigate(to: .leaderboards)
            }
            .keyboardShortcut("6", modifiers: .command)
        }
    }
}
