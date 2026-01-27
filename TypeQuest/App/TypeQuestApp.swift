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
                // Determine if we should authenticate with Game Center
                if let user = dataManager.currentUser, user.settings?.gameCenterEnabled == true {
                    GameCenterManager.shared.authenticate()
                }
            }
        }
        .commands {
            TypeQuestCommands(navigationManager: navigationManager)
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
            
            Button("Pause/Resume") {
                navigationManager.togglePause()
            }
            .keyboardShortcut(".", modifiers: .command)
        }
        
        CommandGroup(before: .windowList) {
            Button("Show Practice") {
                navigationManager.navigate(to: .practice)
            }
            .keyboardShortcut("1", modifiers: .command)
            
            Button("Show Curriculum") {
                navigationManager.navigate(to: .curriculum)
            }
            .keyboardShortcut("2", modifiers: .command)
            
            Button("Show Stats") {
                navigationManager.navigate(to: .stats)
            }
            .keyboardShortcut("3", modifiers: .command)
            
            Button("Show Settings") {
                navigationManager.navigate(to: .settings)
            }
            .keyboardShortcut(",", modifiers: .command)
        }
    }
}
