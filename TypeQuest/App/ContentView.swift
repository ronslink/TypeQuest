import SwiftUI

struct ContentView: View {
    @State private var selectedItem: NavigationItem? = .practice

    enum NavigationItem: Hashable {
        case practice
        case curriculum
        case stats
        case settings
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedItem) {
                NavigationLink(value: NavigationItem.practice) {
                    Label("Practice", systemImage: "keyboard")
                }
                NavigationLink(value: NavigationItem.curriculum) {
                    Label("Curriculum", systemImage: "map")
                }
                NavigationLink(value: NavigationItem.stats) {
                    Label("Statistics", systemImage: "chart.bar")
                }
                NavigationLink(value: NavigationItem.settings) {
                    Label("Settings", systemImage: "gear")
                }
            }
            .navigationTitle("TypeQuest")
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 250)
#endif
        } detail: {
            switch selectedItem {
            case .practice:
                Text("Practice Area")
            case .curriculum:
                Text("Skill Tree")
            case .stats:
                Text("Statistics Dashboard")
            case .settings:
                Text("Settings")
            case .none:
                Text("Select an item")
            }
        }
    }
}

#Preview {
    ContentView()
}
