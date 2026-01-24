import Foundation
import SwiftData
import WidgetKit

@MainActor
final class DataManager: ObservableObject {
    static let shared = DataManager()
    
    private var modelContainer: ModelContainer?
    private var modelContext: ModelContext?
    
    @Published var currentUser: UserProfile?
    @Published var isSyncing: Bool = false
    
    private let userDefaults = UserDefaultsManager.shared
    
    private init() {
        setupSwiftData()
    }
    
    private func setupSwiftData() {
        do {
            let schema = Schema([
                UserProfile.self,
                UserSettings.self,
                SessionData.self,
                KeyPerformance.self,
                LanguageProgress.self
            ])
            
            // Enable CloudKit sync with container identifier
            // Note: The container ID must match the one in your Apple Developer account
            // and the app's entitlements file.
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .none // CloudKit disabled per user request
            )
            
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            modelContext = modelContainer?.mainContext
            
            loadCurrentUser()
        } catch {
            print("Failed to setup SwiftData: \(error)")
        }
    }
    
    func createUser(username: String, ageGroup: AgeGroup, language: String) -> UserProfile {
        let user = UserProfile(username: username, ageGroup: ageGroup, primaryLanguage: language)
        modelContext?.insert(user)
        try? modelContext?.save()
        currentUser = user
        userDefaults.setUsername(username)
        return user
    }
    
    func loadCurrentUser() {
        guard let username = userDefaults.username else { return }
        let descriptor = FetchDescriptor<UserProfile>(predicate: #Predicate { $0.username == username })
        do {
            let users = try modelContext?.fetch(descriptor) ?? []
            currentUser = users.first
        } catch {
            print("Failed to fetch user: \(error)")
        }
    }
    
    func saveSession(_ session: SessionData) {
        modelContext?.insert(session)
        try? modelContext?.save()
    }
    
    func fetchSessions(limit: Int = 50) -> [SessionData] {
        var descriptor = FetchDescriptor<SessionData>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return (try? modelContext?.fetch(descriptor)) ?? []
    }
    
    func saveXP(_ xp: Int, level: Int) {
        guard let user = currentUser else { return }
        user.totalXP = xp
        user.currentLevel = level
        try? modelContext?.save()
        syncToWidget()
    }
    
    func saveStreak(_ current: Int, longest: Int) {
        guard let user = currentUser else { return }
        user.currentStreak = current
        user.longestStreak = longest
        user.lastPracticeDate = Date()
        try? modelContext?.save()
        syncToWidget()
    }
    
    func saveKeyPerformance(_ stats: [KeyPerformance]) {
        for stat in stats {
            modelContext?.insert(stat)
        }
        try? modelContext?.save()
    }
    
    func fetchWeakestKeys(limit: Int = 5) -> [String] {
        // Simplified fetch: Get all stats, aggregate in memory (SwiftData aggregation limits)
        // In a production app with massive data, we'd optimize the query or pre-calculate aggregates.
        let descriptor = FetchDescriptor<KeyPerformance>()
        guard let allStats = try? modelContext?.fetch(descriptor) else { return [] }
        
        var keyStats: [String: (errors: Int, total: Int)] = [:]
        
        for stat in allStats {
            let current = keyStats[stat.key, default: (0, 0)]
            keyStats[stat.key] = (current.errors + stat.errorCount, current.total + stat.pressCount)
        }
        
        // Calculate accuracy and sort
        let sortedKeys = keyStats.map { key, stats -> (String, Double) in
            let accuracy = Double(stats.total - stats.errors) / Double(stats.total)
            return (key, accuracy)
        }
        .filter { $0.1 < 0.9 } // Only keys with < 90% accuracy
        .sorted { $0.1 < $1.1 } // Ascending accuracy (worst first)
        .prefix(limit)
        .map { $0.0 }
        
        return Array(sortedKeys)
    }
    
    var lastPracticeDate: Date? { currentUser?.lastPracticeDate }
    
    // MARK: - Widget Sync
    private func syncToWidget() {
        guard let user = currentUser else { return }
        
        let sharedDefaults = UserDefaults(suiteName: "group.com.typequest.shared")
        sharedDefaults?.set(user.currentStreak, forKey: "currentStreak")
        sharedDefaults?.set(user.longestStreak, forKey: "longestStreak")
        sharedDefaults?.set(user.totalXP, forKey: "totalXP")
        sharedDefaults?.set(user.currentLevel, forKey: "currentLevel")
        
        // Calculate daily progress (mock: based on today's sessions)
        // In production, this would count today's completed lessons vs daily goal
        sharedDefaults?.set(0.0, forKey: "dailyGoalProgress")
        
        // Trigger widget timeline refresh
        WidgetCenter.shared.reloadAllTimelines()
    }
}
