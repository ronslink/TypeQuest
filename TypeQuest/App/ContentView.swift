import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var dataManager: DataManager

    enum NavigationItem: Hashable {
        case practice
        case curriculum
        case shop
        case games
        case stats
        case settings
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $navigationManager.selectedTab) {
                NavigationLink(value: NavigationItem.practice) {
                    Label("Practice", systemImage: "keyboard")
                }
                .tag(NavigationItem.practice)
                
                NavigationLink(value: NavigationItem.curriculum) {
                    Label("Curriculum", systemImage: "map")
                }
                .tag(NavigationItem.curriculum)
                
                NavigationLink(value: NavigationItem.shop) {
                    Label("Shop", systemImage: "bag")
                }
                .tag(NavigationItem.shop)
                
                NavigationLink(value: NavigationItem.games) {
                    Label("Games", systemImage: "gamecontroller")
                }
                .tag(NavigationItem.games)
                
                NavigationLink(value: NavigationItem.stats) {
                    Label("Statistics", systemImage: "chart.bar")
                }
                .tag(NavigationItem.stats)
                
                NavigationLink(value: NavigationItem.settings) {
                    Label("Settings", systemImage: "gear")
                }
                .tag(NavigationItem.settings)
            }
            .navigationTitle("TypeQuest")
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 250)
#endif
        } detail: {
            switch navigationManager.selectedTab {
            case .practice:
                TypingView()
                    .environmentObject(navigationManager)
            case .curriculum:
                NavigationStack {
                    SkillTreeView()
                }
            case .shop:
                ShopView()
            case .games:
                NavigationStack {
                    GameSelectionView()
                }
            case .stats:
                Text("Statistics Dashboard")
            case .settings:
                SettingsView()
            case .none:
                Text("Select an item")
            }
        }
        .environmentObject(navigationManager)
        .sheet(isPresented: $navigationManager.showPaywall) {
            PaywallView()
        }
    }
}

#Preview {
    ContentView()
}
