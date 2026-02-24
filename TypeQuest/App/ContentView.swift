import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var dataManager: DataManager
    @StateObject private var themeManager = ThemeManager.shared

    enum NavigationItem: Hashable {
        case practice
        case curriculum
        case shop
        case games
        case stats
        case leaderboards
        case settings
    }

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .environmentObject(navigationManager)
                .environmentObject(dataManager)
        } detail: {
            detailView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationSplitViewStyle(.balanced)
        .frame(minWidth: 800, minHeight: 500)
        .sheet(isPresented: $navigationManager.showPaywall) {
            PaywallView()
        }
    }

    @ViewBuilder
    private var detailView: some View {
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
                    .environmentObject(navigationManager)
            }
        case .stats:
            StatisticsView()
        case .leaderboards:
            LeaderboardsView()
        case .settings:
            SettingsView()
                .environmentObject(navigationManager)
        case .none:
            WelcomePlaceholder()
        }
    }
}

// MARK: - Premium Sidebar

struct SidebarView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        VStack(spacing: 0) {
            // User Profile Header
            profileHeader
                .padding(.top, 16)
                .padding(.horizontal, 12)
                .padding(.bottom, 12)

            Divider()
                .opacity(0.2)
                .padding(.horizontal, 8)

            // Navigation Items
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    SidebarSection(title: "LEARN") {
                        SidebarItem(icon: "keyboard",        label: "Practice",    tag: .practice,    selection: $navigationManager.selectedTab)
                        SidebarItem(icon: "map",             label: "Curriculum",  tag: .curriculum,  selection: $navigationManager.selectedTab)
                    }

                    SidebarSection(title: "COMPETE") {
                        SidebarItem(icon: "gamecontroller",  label: "Arcade Games",   tag: .games,        selection: $navigationManager.selectedTab)
                        SidebarItem(icon: "trophy",          label: "Leaderboards",   tag: .leaderboards, selection: $navigationManager.selectedTab)
                    }

                    SidebarSection(title: "PROFILE") {
                        SidebarItem(icon: "chart.bar",       label: "Statistics",  tag: .stats,       selection: $navigationManager.selectedTab)
                        SidebarItem(icon: "bag",             label: "Shop",        tag: .shop,        selection: $navigationManager.selectedTab)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 8)
            }

            Divider()
                .opacity(0.2)
                .padding(.horizontal, 8)

            // Settings pinned at bottom
            SidebarItem(icon: "gear", label: "Settings", tag: .settings, selection: $navigationManager.selectedTab)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
        }
        .background(
            VisualEffectBackground(material: .sidebar, blendingMode: .behindWindow)
        )
        .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 260)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button {
                    NSApp.keyWindow?.firstResponder?.tryToPerform(
                        #selector(NSSplitViewController.toggleSidebar(_:)), with: nil
                    )
                } label: {
                    Image(systemName: "sidebar.left")
                }
                .help("Toggle Sidebar (⌃⌘S)")
            }
        }
    }

    private var profileHeader: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.indigoPrimary, .cyanAccent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)
                if let initial = dataManager.currentUser?.username.first {
                    Text(String(initial).uppercased())
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
            }

            VStack(alignment: .leading, spacing: 1) {
                Text(dataManager.currentUser?.username ?? "TypeQuest")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text("Level \(dataManager.currentUser?.currentLevel ?? 1)  ·  \(dataManager.currentUser?.totalXP ?? 0) XP")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
    }
}

// MARK: - Sidebar Section Header

struct SidebarSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.secondary)
                .tracking(0.8)
                .padding(.leading, 10)
                .padding(.top, 14)
                .padding(.bottom, 2)
            content()
        }
    }
}

// MARK: - Sidebar Item

struct SidebarItem: View {
    let icon: String
    let label: String
    let tag: ContentView.NavigationItem
    @Binding var selection: ContentView.NavigationItem?

    @State private var isHovered = false
    private var isSelected: Bool { selection == tag }

    var body: some View {
        Button {
            selection = tag
        } label: {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .indigoPrimary : .secondary)
                    .frame(width: 18, height: 18)

                Text(label)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .primary : .primary.opacity(0.85))

                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .fill(
                        isSelected
                        ? Color.indigoPrimary.opacity(0.18)
                        : (isHovered ? Color.primary.opacity(0.07) : Color.clear)
                    )
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.12)) {
                isHovered = hovering
            }
        }
    }
}

// MARK: - NSVisualEffectView Wrapper (Native macOS Vibrancy)

struct VisualEffectBackground: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

// MARK: - Welcome Placeholder

struct WelcomePlaceholder: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "keyboard")
                .font(.system(size: 52))
                .foregroundStyle(
                    LinearGradient(colors: [.indigoPrimary, .cyanAccent],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            Text("Select an item from the sidebar")
                .font(.title3)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.canvasDark)
    }
}

#Preview {
    ContentView()
}
