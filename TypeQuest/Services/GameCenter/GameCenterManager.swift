import Foundation
import GameKit
import SwiftUI

@MainActor
final class GameCenterManager: ObservableObject {
    static let shared = GameCenterManager()
    
    @Published var isAuthenticated: Bool = false
    @Published var localPlayer: GKLocalPlayer?
    @Published var error: String?
    
    // Leaderboard IDs (must match App Store Connect configuration)
    enum LeaderboardID: String {
        case wpmHighScore = "com.typequest.leaderboard.wpm"
        case totalXP = "com.typequest.leaderboard.xp"
        case longestStreak = "com.typequest.leaderboard.streak"
    }
    
    private init() {
        // Authentication is now triggered manually via authenticate()
    }
    
    // MARK: - Authentication
    func authenticate() {
        GKLocalPlayer.local.authenticateHandler = { [weak self] viewController, error in
            Task { @MainActor in
                guard let self = self else { return }
                
                if let error = error {
                    self.error = error.localizedDescription
                    self.isAuthenticated = false
                    return
                }
                
                if GKLocalPlayer.local.isAuthenticated {
                    self.isAuthenticated = true
                    self.localPlayer = GKLocalPlayer.local
                    self.setupAccessPoint()
                }
                
                // Note: On iOS/iPadOS, if viewController is provided,
                // you would present it. On macOS, Game Center handles this via system UI.
            }
        }
    }
    
    // MARK: - Access Point
    private func setupAccessPoint() {
        GKAccessPoint.shared.location = .topTrailing
        GKAccessPoint.shared.showHighlights = true
        GKAccessPoint.shared.isActive = true
    }
    
    func showAccessPoint() {
        GKAccessPoint.shared.isActive = true
    }
    
    func hideAccessPoint() {
        GKAccessPoint.shared.isActive = false
    }
    
    // MARK: - Submit Scores
    func submitWPMScore(_ wpm: Int) {
        guard isAuthenticated else { return }
        
        Task {
            do {
                try await GKLeaderboard.submitScore(
                    wpm,
                    context: 0,
                    player: GKLocalPlayer.local,
                    leaderboardIDs: [LeaderboardID.wpmHighScore.rawValue]
                )
                print("WPM score submitted: \(wpm)")
            } catch {
                print("Failed to submit WPM score: \(error)")
            }
        }
    }
    
    func submitXPScore(_ xp: Int) {
        guard isAuthenticated else { return }
        
        Task {
            do {
                try await GKLeaderboard.submitScore(
                    xp,
                    context: 0,
                    player: GKLocalPlayer.local,
                    leaderboardIDs: [LeaderboardID.totalXP.rawValue]
                )
            } catch {
                print("Failed to submit XP score: \(error)")
            }
        }
    }
    
    func submitStreakScore(_ streak: Int) {
        guard isAuthenticated else { return }
        
        Task {
            do {
                try await GKLeaderboard.submitScore(
                    streak,
                    context: 0,
                    player: GKLocalPlayer.local,
                    leaderboardIDs: [LeaderboardID.longestStreak.rawValue]
                )
            } catch {
                print("Failed to submit streak score: \(error)")
            }
        }
    }
    
    // MARK: - Show Leaderboard
    func showLeaderboard() {
        // On macOS/iPadOS, Game Center dashboard can be triggered via access point
        // or by presenting a GKGameCenterViewController
        GKAccessPoint.shared.trigger(state: .leaderboards) { }
    }
}
