import SwiftUI
import SwiftData
import Charts

/// StatisticsView displays user typing performance analytics
struct StatisticsView: View {
    
    // MARK: - Environment
    
    @Environment(\.modelContext) private var modelContext
    
    // MARK: - State
    
    @State private var sessions: [SessionData] = []
    @State private var keyPerformances: [KeyPerformance] = []
    @State private var selectedTimeRange: TimeRange = .week
    @State private var isLoading = true
    
    // MARK: - Computed Properties
    
    private var filteredSessions: [SessionData] {
        let cutoffDate = selectedTimeRange.cutoffDate
        return sessions
            .filter { $0.timestamp >= cutoffDate }
            .sorted { $0.timestamp > $1.timestamp }
    }
    
    private var averageWPM: Double {
        guard !filteredSessions.isEmpty else { return 0 }
        return filteredSessions.reduce(0) { $0 + $1.wpm } / Double(filteredSessions.count)
    }
    
    private var averageAccuracy: Double {
        guard !filteredSessions.isEmpty else { return 0 }
        return filteredSessions.reduce(0) { $0 + $1.accuracy } / Double(filteredSessions.count)
    }
    
    private var totalPracticeTime: TimeInterval {
        filteredSessions.reduce(0) { $0 + $1.duration }
    }
    
    private var totalCharacters: Int {
        filteredSessions.reduce(0) { $0 + $1.totalCharacters }
    }
    
    private var totalSessions: Int {
        filteredSessions.count
    }
    
    private var wpmTrend: Double {
        guard filteredSessions.count >= 2 else { return 0 }
        let sorted = filteredSessions.sorted { $0.timestamp < $1.timestamp }
        let recentSessions = Array(sorted.suffix(5))
        let olderSessions = Array(sorted.prefix(5))
        
        let recentAvg = recentSessions.reduce(0) { $0 + $1.wpm } / Double(recentSessions.count)
        let olderAvg = olderSessions.reduce(0) { $0 + $1.wpm } / Double(olderSessions.count)
        
        return recentAvg - olderAvg
    }
    
    private var accuracyTrend: Double {
        guard filteredSessions.count >= 2 else { return 0 }
        let sorted = filteredSessions.sorted { $0.timestamp < $1.timestamp }
        let recentSessions = Array(sorted.suffix(5))
        let olderSessions = Array(sorted.prefix(5))
        
        let recentAvg = recentSessions.reduce(0) { $0 + $1.accuracy } / Double(recentSessions.count)
        let olderAvg = olderSessions.reduce(0) { $0 + $1.accuracy } / Double(olderSessions.count)
        
        return recentAvg - olderAvg
    }
    
    private var weakestKeys: [(key: String, errorRate: Double)] {
        var keyErrors: [String: (presses: Int, errors: Int)] = [:]
        
        for performance in keyPerformances {
            var current = keyErrors[performance.key] ?? (0, 0)
            current.presses += performance.pressCount
            current.errors += performance.errorCount
            keyErrors[performance.key] = current
        }
        
        return keyErrors.map { key, data in
            let errorRate = data.presses > 0 ? (Double(data.errors) / Double(data.presses)) * 100 : 0
            return (key: key, errorRate: errorRate)
        }
        .filter { $0.errorRate > 0 }
        .sorted { $0.errorRate > $1.errorRate }
        .prefix(10)
        .map { $0 }
    }
    
    private var sessionsByDay: [(date: Date, avgWPM: Double, avgAccuracy: Double)] {
        let grouped = Dictionary(grouping: filteredSessions) { session in
            Calendar.current.startOfDay(for: session.timestamp)
        }
        
        return grouped.map { date, daySessions in
            let avgWPM = daySessions.reduce(0) { $0 + $1.wpm } / Double(daySessions.count)
            let avgAccuracy = daySessions.reduce(0) { $0 + $1.accuracy } / Double(daySessions.count)
            return (date: date, avgWPM: avgWPM, avgAccuracy: avgAccuracy)
        }
        .sorted { $0.date < $1.date }
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Time Range Selector
                timeRangeSelector
                
                // Overview Stats
                overviewSection
                
                // WPM Chart
                if !filteredSessions.isEmpty {
                    wpmChartSection
                    
                    // Accuracy Chart
                    accuracyChartSection
                    
                    // Weakest Keys Section
                    if !weakestKeys.isEmpty {
                        weakestKeysSection
                    }
                    
                    // Recent Sessions
                    recentSessionsSection
                } else {
                    emptyState
                }
            }
            .padding()
        }
        .navigationTitle("Statistics")
        .onAppear {
            loadData()
        }
    }
    
    // MARK: - Time Range Selector
    
    private var timeRangeSelector: some View {
        Picker("Time Range", selection: $selectedTimeRange) {
            Text("Today").tag(TimeRange.today)
            Text("Week").tag(TimeRange.week)
            Text("Month").tag(TimeRange.month)
            Text("All Time").tag(TimeRange.allTime)
        }
        .pickerStyle(.segmented)
    }
    
    // MARK: - Overview Section
    
    private var overviewSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            StatCard(
                title: "Avg WPM",
                value: String(format: "%.0f", averageWPM),
                trend: wpmTrend,
                icon: "speedometer"
            )
            
            StatCard(
                title: "Accuracy",
                value: String(format: "%.1f%%", averageAccuracy),
                trend: accuracyTrend,
                icon: "target"
            )
            
            StatCard(
                title: "Practice Time",
                value: formatTime(totalPracticeTime),
                icon: "clock"
            )
            
            StatCard(
                title: "Sessions",
                value: "\(totalSessions)",
                icon: "number"
            )
        }
    }
    
    // MARK: - WPM Chart
    
    private var wpmChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("WPM Trend")
                .font(.headline)
            
            if #available(macOS 14.0, *) {
                Chart(sessionsByDay) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("WPM", item.avgWPM)
                    )
                    .foregroundStyle(.orange)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", item.date),
                        y: .value("WPM", item.avgWPM)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange.opacity(0.3), .orange.opacity(0.05)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 200)
            } else {
                // Fallback for older macOS
                SimpleLineChart(data: sessionsByDay.map { $0.avgWPM })
                    .frame(height: 200)
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Accuracy Chart
    
    private var accuracyChartSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Accuracy Trend")
                .font(.headline)
            
            if #available(macOS 14.0, *) {
                Chart(sessionsByDay) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("Accuracy", item.avgAccuracy)
                    )
                    .foregroundStyle(.green)
                    .interpolationMethod(.catmullRom)
                }
                .chartYScale(domain: 80...100)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .frame(height: 150)
            } else {
                SimpleLineChart(data: sessionsByDay.map { $0.avgAccuracy })
                    .frame(height: 150)
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Weakest Keys
    
    private var weakestKeysSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Keys to Practice")
                .font(.headline)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 8) {
                ForEach(weakestKeys, id: \.key) { item in
                    VStack(spacing: 4) {
                        Text(item.key.uppercased())
                            .font(.system(.title3, design: .monospaced))
                            .fontWeight(.bold)
                        
                        Text(String(format: "%.1f%%", item.errorRate))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.red.opacity(0.1))
                    )
                }
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Recent Sessions
    
    private var recentSessionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Sessions")
                .font(.headline)
            
            ForEach(filteredSessions.prefix(10), id: \.id) { session in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(session.timestamp, style: .relative)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        
                        Text(session.language)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("\(String(format: "%.0f", session.wpm)) WPM")
                            .font(.headline)
                            .foregroundStyle(.orange)
                        
                        Text(String(format: "%.1f%%", session.accuracy))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
                
                if session.id != filteredSessions.prefix(10).last?.id {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            
            Text("No Practice Data Yet")
                .font(.headline)
            
            Text("Complete typing sessions to see your statistics here.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
    
    // MARK: - Helpers
    
    private func loadData() {
        isLoading = true
        
        // Fetch all sessions
        let sessionDescriptor = FetchDescriptor<SessionData>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        
        do {
            sessions = try modelContext.fetch(sessionDescriptor)
            
            // Fetch key performances
            let keyDescriptor = FetchDescriptor<KeyPerformance>()
            keyPerformances = try modelContext.fetch(keyDescriptor)
        } catch {
            print("Failed to fetch statistics: \(error)")
        }
        
        isLoading = false
    }
    
    private func formatTime(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

// MARK: - Supporting Views

struct StatCard: View {
    let title: String
    let value: String
    var trend: Double? = nil
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(.orange)
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                if let trend = trend, trend != 0 {
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: trend > 0 ? "arrow.up" : "arrow.down")
                        Text(String(format: "%.0f", abs(trend)))
                    }
                    .font(.caption2)
                    .foregroundStyle(trend > 0 ? .green : .red)
                }
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SimpleLineChart: View {
    let data: [Double]
    
    var body: some View {
        GeometryReader { geometry in
            let maxValue = data.max() ?? 1
            let minValue = data.min() ?? 0
            let range = maxValue - minValue
            
            Path { path in
                guard data.count > 1 else { return }
                
                let stepX = geometry.size.width / CGFloat(data.count - 1)
                
                for (index, value) in data.enumerated() {
                    let normalizedValue = range > 0 ? (value - minValue) / range : 0.5
                    let x = CGFloat(index) * stepX
                    let y = geometry.size.height * (1 - normalizedValue)
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(Color.orange, lineWidth: 2)
        }
    }
}

// MARK: - Time Range

enum TimeRange: String, CaseIterable {
    case today = "Today"
    case week = "Week"
    case month = "Month"
    case allTime = "All Time"
    
    var cutoffDate: Date {
        let calendar = Calendar.current
        let now = Date()
        
        switch self {
        case .today:
            return calendar.startOfDay(for: now)
        case .week:
            return calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            return calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .allTime:
            return Date.distantPast
        }
    }
}

// MARK: - Preview

#Preview {
    StatisticsView()
        .modelContainer(for: [SessionData.self, KeyPerformance.self])
}
