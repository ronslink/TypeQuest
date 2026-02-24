import SwiftUI

/// LeaderboardsView displays game center leaderboards
struct LeaderboardsView: View {
    @StateObject private var gameCenterManager = GameCenterManager.shared
    @State private var selectedLeaderboard: LeaderboardType = .wpm
    @StateObject private var dataManager = DataManager.shared
    
    enum LeaderboardType: String, CaseIterable {
        case wpm = "WPM Record"
        case xp = "Total XP"
        case streak = "Best Streak"
        
        var icon: String {
            switch self {
            case .wpm: return "speedometer"
            case .xp: return "star.fill"
            case .streak: return "flame.fill"
            }
        }

        var unit: String {
            switch self {
            case .wpm: return "WPM"
            case .xp: return "XP"
            case .streak: return "days"
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Text("Leaderboards")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                if gameCenterManager.isAuthenticated {
                    HStack(spacing: 4) {
                        Image(systemName: "person.circle.fill")
                        Text(gameCenterManager.localPlayer?.alias ?? "Player")
                    }
                    .foregroundStyle(.secondary)
                }
            }
            .padding()
            
            // Not Authenticated State
            if !gameCenterManager.isAuthenticated {
                notAuthenticatedView
            } else {
                // Leaderboard Type Picker
                Picker("Leaderboard", selection: $selectedLeaderboard) {
                    ForEach(LeaderboardType.allCases, id: \.self) { type in
                        Label(type.rawValue, systemImage: type.icon)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Leaderboard Content
                leaderboardContent
            }
        }
        .background(Color(nsColor: .windowBackgroundColor))
        .onAppear {
            if !gameCenterManager.isAuthenticated {
                gameCenterManager.authenticate()
            }
        }
    }
    
    private var notAuthenticatedView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "gamecontroller")
                .font(.system(size: 64))
                .foregroundStyle(.secondary)
            
            Text("Sign in to Game Center")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Compete with other typists and track your progress on global leaderboards.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button {
                gameCenterManager.authenticate()
            } label: {
                Label("Sign In", systemImage: "person.badge.key")
                    .font(.headline)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            
            Spacer()
        }
    }
    
    private var leaderboardContent: some View {
        VStack(spacing: 16) {
            // Current Score Display
            currentScoreCard
            
            // View Full Leaderboard Button
            Button {
                gameCenterManager.showLeaderboard()
            } label: {
                Label("View Full Leaderboard", systemImage: "arrow.up.right.square")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
            .padding(.horizontal)
            
            // How to Play
            howToPlaySection
        }
    }
    
    private var currentScoreCard: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Label(selectedLeaderboard.rawValue, systemImage: selectedLeaderboard.icon)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Spacer()

                // Open native Game Center overlay
                Button {
                    gameCenterManager.showLeaderboard()
                } label: {
                    HStack(spacing: 4) {
                        Text("Full Rankings")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.up.right.square")
                            .font(.caption)
                    }
                    .foregroundColor(.indigoPrimary)
                }
                .buttonStyle(.plain)
                .help("Open Game Center leaderboard")
            }

            Divider()

            // Your best score card
            HStack(spacing: 16) {
                // Avatar
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.indigoPrimary, .cyanAccent],
                                             startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 44, height: 44)
                    if let alias = gameCenterManager.localPlayer?.alias,
                       let initial = alias.first {
                        Text(String(initial).uppercased())
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(gameCenterManager.localPlayer?.alias ?? "You")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("Your personal best")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(personalBestScore)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.indigoPrimary)
                    Text(selectedLeaderboard.unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(12)
            .background(Color.indigoPrimary.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // CTA to open native leaderboard
            Button {
                gameCenterManager.showLeaderboard()
            } label: {
                HStack {
                    Image(systemName: "trophy.fill")
                    Text("Compare with Global Players")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Color.indigoPrimary)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .help("Opens Game Center to show real global rankings")
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var personalBestScore: String {
        switch selectedLeaderboard {
        case .wpm:
            // Use best WPM from language progress
            let best = dataManager.currentUser?.progress?
                .compactMap { $0.bestWPM }
                .max() ?? 0
            return best > 0 ? String(format: "%.0f", best) : "--"
        case .xp:
            let xp = dataManager.currentUser?.totalXP ?? 0
            return xp > 0 ? "\(xp)" : "--"
        case .streak:
            let streak = dataManager.currentUser?.longestStreak ?? 0
            return streak > 0 ? "\(streak)" : "--"
        }
    }
    
    
    private var howToPlaySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How to Appear on Leaderboards")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 6) {
                Label("Complete typing sessions to score", systemImage: "keyboard")
                Label("Higher WPM = higher rank", systemImage: "speedometer")
                Label("Practice daily for streaks", systemImage: "flame")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }
}

#Preview {
    LeaderboardsView()
}
