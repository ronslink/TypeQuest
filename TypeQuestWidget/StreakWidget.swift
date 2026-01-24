import WidgetKit
import SwiftUI

// MARK: - Timeline Entry
struct StreakEntry: TimelineEntry {
    let date: Date
    let currentStreak: Int
    let longestStreak: Int
    let totalXP: Int
    let level: Int
    let dailyGoalProgress: Double // 0.0 to 1.0
}

// MARK: - Timeline Provider
struct StreakProvider: TimelineProvider {
    
    func placeholder(in context: Context) -> StreakEntry {
        StreakEntry(
            date: Date(),
            currentStreak: 7,
            longestStreak: 14,
            totalXP: 5000,
            level: 5,
            dailyGoalProgress: 0.75
        )
    }
    
    func getSnapshot(in context: Context, completion: @escaping (StreakEntry) -> Void) {
        let entry = loadData()
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<StreakEntry>) -> Void) {
        let entry = loadData()
        
        // Refresh every hour
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        
        completion(timeline)
    }
    
    private func loadData() -> StreakEntry {
        // Read from App Group UserDefaults
        let defaults = UserDefaults(suiteName: "group.com.typequest.shared")
        
        let streak = defaults?.integer(forKey: "currentStreak") ?? 0
        let longest = defaults?.integer(forKey: "longestStreak") ?? 0
        let xp = defaults?.integer(forKey: "totalXP") ?? 0
        let level = defaults?.integer(forKey: "currentLevel") ?? 1
        let progress = defaults?.double(forKey: "dailyGoalProgress") ?? 0.0
        
        return StreakEntry(
            date: Date(),
            currentStreak: streak,
            longestStreak: longest,
            totalXP: xp,
            level: level,
            dailyGoalProgress: progress
        )
    }
}

// MARK: - Widget View
struct StreakWidgetView: View {
    var entry: StreakEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .systemSmall:
            smallView
        case .systemMedium:
            mediumView
        case .systemLarge:
            largeView
        default:
            smallView
        }
    }
    
    // MARK: - Small Widget
    private var smallView: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                Text("\(entry.currentStreak)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text("Day Streak")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.15, green: 0.1, blue: 0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    // MARK: - Medium Widget
    private var mediumView: some View {
        HStack(spacing: 20) {
            // Streak Section
            VStack(spacing: 4) {
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(entry.currentStreak)")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                Text("Day Streak")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Divider()
                .background(Color.gray)
            
            // Stats Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("Level \(entry.level)")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                HStack {
                    Image(systemName: "bolt.fill")
                        .foregroundColor(.cyan)
                    Text("\(entry.totalXP) XP")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                // Daily Progress
                ProgressView(value: entry.dailyGoalProgress)
                    .tint(.green)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.15, green: 0.1, blue: 0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    // MARK: - Large Widget
    private var largeView: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("TypeQuest")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "keyboard")
                    .foregroundColor(.purple)
            }
            
            Spacer()
            
            // Main Streak Display
            VStack(spacing: 8) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.orange)
                
                Text("\(entry.currentStreak)")
                    .font(.system(size: 64, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Day Streak")
                    .font(.title3)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Stats Row
            HStack(spacing: 24) {
                statItem(icon: "trophy.fill", value: "\(entry.longestStreak)", label: "Best", color: .yellow)
                statItem(icon: "star.fill", value: "Lv.\(entry.level)", label: "Level", color: .purple)
                statItem(icon: "bolt.fill", value: "\(entry.totalXP)", label: "XP", color: .cyan)
            }
            
            // Daily Goal Progress
            VStack(alignment: .leading, spacing: 4) {
                Text("Daily Goal")
                    .font(.caption)
                    .foregroundColor(.gray)
                ProgressView(value: entry.dailyGoalProgress)
                    .tint(.green)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color(red: 0.1, green: 0.1, blue: 0.2), Color(red: 0.15, green: 0.1, blue: 0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    private func statItem(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
            Text(label)
                .font(.caption2)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Widget Configuration
@main
struct TypeQuestWidget: Widget {
    let kind: String = "TypeQuestStreakWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StreakProvider()) { entry in
            StreakWidgetView(entry: entry)
        }
        .configurationDisplayName("Streak Tracker")
        .description("Track your daily typing streak and progress.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Preview
#Preview(as: .systemMedium) {
    TypeQuestWidget()
} timeline: {
    StreakEntry(date: .now, currentStreak: 7, longestStreak: 14, totalXP: 5000, level: 5, dailyGoalProgress: 0.75)
}
