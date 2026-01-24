import SwiftUI

struct DiagnosticView: View {
    @StateObject private var viewModel = DiagnosticViewModel()
    @Binding var showDiagnostic: Bool
    @Binding var isOnboardingComplete: Bool
    
    var body: some View {
        ZStack {
            Color.canvasDark.ignoresSafeArea()
            
            VStack(spacing: 40) {
                // Header
                Text(viewModel.currentPhase.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                switch viewModel.currentPhase {
                case .intro:
                    introContent
                case .results:
                    resultsContent
                default:
                    testContent
                }
            }
            .padding(40)
        }
    }
    
    // MARK: - Intro
    private var introContent: some View {
        VStack(spacing: 24) {
            Image(systemName: "keyboard.badge.ellipsis")
                .font(.system(size: 80))
                .foregroundColor(.indigoPrimary)
            
            Text("Let's see where you're at!")
                .font(.title2)
                .foregroundColor(.textSecondaryDark)
            
            Text("This quick test will measure your typing speed and accuracy across 3 short exercises. We'll recommend the best starting point for you.")
                .multilineTextAlignment(.center)
                .foregroundColor(.textTertiaryDark)
                .padding(.horizontal, 60)
            
            HStack(spacing: 20) {
                Button("Skip Test") {
                    viewModel.skipDiagnostic()
                }
                .buttonStyle(.bordered)
                .foregroundColor(.textSecondaryDark)
                
                Button("Start Test") {
                    viewModel.startDiagnostic()
                }
                .buttonStyle(.borderedProminent)
                .tint(.indigoPrimary)
            }
            .padding(.top, 20)
        }
    }
    
    // MARK: - Test Content
    private var testContent: some View {
        VStack(spacing: 30) {
            // Progress
            HStack {
                ForEach(DiagnosticViewModel.DiagnosticPhase.allCases.filter { $0.rawValue > 0 && $0.rawValue < 4 }, id: \.self) { phase in
                    Circle()
                        .fill(phase.rawValue <= viewModel.currentPhase.rawValue ? Color.indigoPrimary : Color.surfaceDark)
                        .frame(width: 12, height: 12)
                }
            }
            
            // Timer
            Text(String(format: "%.1fs", viewModel.elapsedTime))
                .font(.title2)
                .fontDesign(.monospaced)
                .foregroundColor(.textSecondaryDark)
            
            // Text Display
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Material.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                
                textBuilder
                    .font(.system(size: 28, weight: .medium, design: .monospaced))
                    .padding(30)
            }
            .frame(height: 150)
            .padding(.horizontal, 40)
            
            Text("Just type what you see!")
                .font(.caption)
                .foregroundColor(.textTertiaryDark)
        }
    }
    
    private var textBuilder: Text {
        var output = Text("")
        let chars = Array(viewModel.currentText)
        
        for (index, char) in chars.enumerated() {
            let s = String(char)
            if index < viewModel.typedText.count {
                output = output + Text(s).foregroundColor(.success)
            } else if index == viewModel.currentIndex {
                output = output + Text(s)
                    .foregroundColor(.indigoPrimary)
                    .underline(true, color: .indigoPrimary)
            } else {
                output = output + Text(s).foregroundColor(.textTertiaryLight)
            }
        }
        
        return output
    }
    
    // MARK: - Results
    private var resultsContent: some View {
        VStack(spacing: 30) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.success)
            
            Text("Test Complete!")
                .font(.title)
                .foregroundColor(.white)
            
            // Metrics Summary
            HStack(spacing: 40) {
                if let homeRow = viewModel.phaseResults[.homeRow] {
                    metricCard(title: "Home Row", wpm: homeRow.wpm, accuracy: homeRow.accuracy)
                }
                if let words = viewModel.phaseResults[.commonWords] {
                    metricCard(title: "Words", wpm: words.wpm, accuracy: words.accuracy)
                }
                if let sentences = viewModel.phaseResults[.sentences] {
                    metricCard(title: "Sentences", wpm: sentences.wpm, accuracy: sentences.accuracy)
                }
            }
            
            // Recommendation
            VStack(spacing: 12) {
                Text("Recommended Starting Point:")
                    .font(.headline)
                    .foregroundColor(.textSecondaryDark)
                
                Text("Stage \(viewModel.recommendedStage)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(
                        LinearGradient(colors: [.indigoPrimary, .cyanAccent], startPoint: .leading, endPoint: .trailing)
                    )
                
                Text(viewModel.resultsMessage)
                    .font(.subheadline)
                    .foregroundColor(.textTertiaryDark)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 60)
            }
            .padding(.top, 20)
            
            Button("Let's Go!") {
                viewModel.applyRecommendation()
                showDiagnostic = false
                isOnboardingComplete = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.indigoPrimary)
            .padding(.top, 20)
        }
    }
    
    private func metricCard(title: String, wpm: Double, accuracy: Double) -> some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.textTertiaryDark)
            Text(String(format: "%.0f WPM", wpm))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(String(format: "%.0f%% Acc", accuracy))
                .font(.caption)
                .foregroundColor(.success)
        }
        .padding()
        .background(Color.surfaceDark)
        .cornerRadius(12)
    }
}
