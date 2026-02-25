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
        Group {
            switch navigationManager.selectedTab {
            case .practice:
                EnhancedTypingView()
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
        .appBackground()
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
            
            // Daily Streak Widget
            if let user = dataManager.currentUser, user.currentStreak > 0 {
                DailyStreakWidget(streak: user.currentStreak)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .coordinatedEntrance(delay: 0.3)
            }

            // Settings pinned at bottom
            SidebarItem(icon: "gear", label: "Settings", tag: .settings, selection: $navigationManager.selectedTab)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
        }
        .background(
            VisualEffectBackground(material: .sidebar, blendingMode: .behindWindow)
        )
        .navigationSplitViewColumnWidth(min: 220, ideal: 240, max: 280)
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
        HStack(spacing: 12) {
            ZStack {
                // Avatar background with glow
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                ThemeManager.shared.currentTheme.colors.primary,
                                ThemeManager.shared.currentTheme.colors.accent
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .shadow(
                        color: ThemeManager.shared.currentTheme.colors.primary.opacity(0.4),
                        radius: 8,
                        x: 0,
                        y: 4
                    )
                
                if let initial = dataManager.currentUser?.username.first {
                    Text(String(initial).uppercased())
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(dataManager.currentUser?.username ?? "TypeQuest")
                    .font(AppTypography.h5)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    // Level badge
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 8))
                        Text("\(dataManager.currentUser?.currentLevel ?? 1)")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.primary)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(ThemeManager.shared.currentTheme.colors.primary.opacity(0.15))
                    )
                    
                    // Streak
                    HStack(spacing: 3) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 9))
                        Text("\(dataManager.currentUser?.currentStreak ?? 0)")
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(
                        (dataManager.currentUser?.currentStreak ?? 0) > 0
                        ? .orange : .secondary.opacity(0.4)
                    )
                    
                    // Currency
                    HStack(spacing: 3) {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 9))
                        Text("\(dataManager.currentUser?.inkCurrency ?? 0)")
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.accent)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Sidebar Section Header

struct SidebarSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.secondary)
                .tracking(1.2)
                .padding(.leading, 12)
                .padding(.top, 16)
                .padding(.bottom, 4)
            content()
        }
    }
}

// MARK: - Sidebar Item

struct SidebarItem: View {
    let icon: String
    let label: String
    let tag: ContentView.NavigationItem?
    @Binding var selection: ContentView.NavigationItem?

    @State private var isHovered = false
    private var isSelected: Bool { selection == tag }

    var body: some View {
        Button {
            selection = tag
        } label: {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? ThemeManager.shared.currentTheme.colors.primary : .secondary)
                    .frame(width: 20, height: 20)

                Text(label)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .primary : .primary.opacity(0.85))

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        isSelected
                        ? ThemeManager.shared.currentTheme.colors.primary.opacity(0.15)
                        : (isHovered ? Color.primary.opacity(0.06) : Color.clear)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected ? ThemeManager.shared.currentTheme.colors.primary.opacity(0.3) : Color.clear,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(AppAnimation.micro) {
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
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                ThemeManager.shared.currentTheme.colors.primary.opacity(0.2),
                                ThemeManager.shared.currentTheme.colors.accent.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)
                
                Image(systemName: "keyboard.fill")
                    .font(.system(size: 56, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                ThemeManager.shared.currentTheme.colors.primary,
                                ThemeManager.shared.currentTheme.colors.accent
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: ThemeManager.shared.currentTheme.colors.primary.opacity(0.4),
                        radius: 20,
                        x: 0,
                        y: 10
                    )
            }
            
            VStack(spacing: 8) {
                Text("Welcome to TypeQuest")
                    .font(AppTypography.h2)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                
                Text("Select an item from the sidebar to begin")
                    .font(AppTypography.body)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .coordinatedEntrance(delay: 0)
    }
}

// MARK: - Daily Streak Widget

struct DailyStreakWidget: View {
    let streak: Int
    
    private var progress: Double {
        min(Double(streak) / 7.0, 1.0)
    }
    
    private var milestoneText: String {
        if streak >= 30 { return "Monthly Master!" }
        if streak >= 7 { return "Weekly Warrior!" }
        if streak >= 3 { return "Building Momentum!" }
        return "Keep it up!"
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Progress ring with flame
            ZStack {
                // Background ring
                Circle()
                    .stroke(Color.orange.opacity(0.15), lineWidth: 4)
                    .frame(width: 48, height: 48)
                
                // Progress ring
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            colors: [.orange, .red, .orange],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 48, height: 48)
                    .rotationEffect(.degrees(-90))
                    .animation(AppAnimation.component, value: progress)
                
                // Flame icon
                Image(systemName: "flame.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.orange)
                    .shadow(color: .orange.opacity(0.6), radius: 4)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("\(streak) Day Streak")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.orange)
                
                Text(milestoneText)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.orange.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

// MARK: - Progress Ring Component

struct ProgressRing: View {
    let progress: Double
    let color: Color
    var lineWidth: CGFloat = 6
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.15), lineWidth: lineWidth)
            
            Circle()
                .trim(from: 0, to: min(progress, 1.0))
                .stroke(
                    color,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(AppAnimation.component, value: progress)
        }
    }
}

#Preview {
    ContentView()
}
