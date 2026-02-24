import SwiftUI

/// LeaderboardsView displays game center leaderboards
struct LeaderboardsView: View {
    @StateObject private var gameCenterManager = GameCenterManager.shared
    @State private var selectedLeaderboard: LeaderboardType = .wpm
    
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
        VStack(spacing: 12) {
            HStack {
                Image(systemName: selectedLeaderboard.icon)
                    .font(.title)
                    .foregroundStyle(.orange)
                
                Text(selectedLeaderboard.rawValue)
                    .font(.headline)
                
                Spacer()
            }
            
            // Placeholder scores - in production these would load from Game Center
            VStack(spacing: 8) {
                rankRow(rank: 1, name: "TypingMaster", score: "142 WPM", isCurrentUser: false)
                rankRow(rank: 2, name: "SpeedDemon", score: "128 WPM", isCurrentUser: false)
                rankRow(rank: 3, name: "KeyboardNinja", score: "115 WPM", isCurrentUser: false)
                rankRow(rank: 4, name: "Your Score", score: "--", isCurrentUser: true)
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
    
    private func rankRow(rank: Int, name: String, score: String, isCurrentUser: Bool) -> some View {
        HStack {
            Text("#\(rank)")
                .font(.headline)
                .foregroundStyle(isCurrentUser ? .orange : .secondary)
                .frame(width: 40, alignment: .leading)
            
            Text(name)
                .fontWeight(isCurrentUser ? .bold : .regular)
                .foregroundStyle(isCurrentUser ? .orange : .primary)
            
            Spacer()
            
            Text(score)
                .font(.headline)
                .foregroundStyle(isCurrentUser ? .orange : .secondary)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isCurrentUser ? Color.orange.opacity(0.1) : Color.clear)
        )
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
