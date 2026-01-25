import SwiftUI

struct RacerGameView: View {
    @StateObject private var viewModel = RacerGameViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Background (Road Texture or Gradient)
            GameBackgroundView(imageName: "racer_bg")
            
            VStack(spacing: 0) {
                // Header (HUD)
                HStack {
                    Text("TYPING RACER")
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(.yellow)
                        .italic()
                    
                    Spacer()
                    
                    if viewModel.userWPM > 0 {
                        let wpm = viewModel.userWPM
                        Text("\(Int(wpm)) WPM")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .background(Color.indigo.opacity(0.5))
                            .cornerRadius(8)
                    }
                    
                    if let rank = viewModel.userRank {
                        Text("\(rankOrdinal(rank)) Place")
                            .font(.title2)
                            .fontWeight(.black)
                            .foregroundColor(rank == 1 ? .yellow : .white)
                            .padding(.horizontal)
                            .background(rank == 1 ? Color.yellow.opacity(0.2) : Color.white.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding()
                .background(Material.thin)
                
                // Track View (Center)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // User Track
                        RaceTrackLane(name: "YOU", color: .cyan, progress: viewModel.userProgress, icon: "car.fill")
                        
                        // Opponents
                        ForEach(viewModel.opponents) { opponent in
                            RaceTrackLane(name: opponent.name, color: opponent.color, progress: opponent.progress, icon: opponent.icon)
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: 300)
                
                Divider().overlay(Color.gray)
                
                // Typing Area (Bottom)
                ZStack {
                    Color.black.opacity(0.3)
                    
                    if viewModel.isRaceActive {
                         TextDisplayView(fullText: viewModel.racerText, typedText: viewModel.typedText)
                            .padding()
                    } else if viewModel.isRaceFinished {
                        VStack(spacing: 20) {
                            Text(viewModel.userRank == 1 ? "VICTORY!" : "FINISHED")
                                .font(.system(size: 40, weight: .black))
                                .foregroundStyle(LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom))
                            
                            Button("Race Again") {
                                viewModel.startRaceSequence()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                    } else {
                        // Startup / Countdown / Idle
                        if viewModel.countdown > 0 {
                            Text("\(viewModel.countdown)")
                                .font(.system(size: 80, weight: .black))
                                .foregroundColor(.white)
                                .transition(.scale)
                            Button("Start Race") {
                                viewModel.startRaceSequence()
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(radius: 10)
                        } else {
                            // Initial State Button
                            Button("Start Engine") {
                                viewModel.startRaceSequence()
                            }
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                            .shadow(radius: 10)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
             AudioManager.shared.playMusic(.energetic)
        }
        .onDisappear {
            viewModel.stopRace()
            AudioManager.shared.stopMusic()
        }
    }
    
    func rankOrdinal(_ n: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: n)) ?? "\(n)"
    }
}

struct RaceTrackLane: View {
    let name: String
    let color: Color
    let progress: Double
    let icon: String // SF Symbol
    
    var body: some View {
        HStack {
            Text(name)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)
                .frame(width: 50, alignment: .leading)
            
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    // Track Line
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 4)
                        .cornerRadius(2)
                    
                    // Finish Line Checkers
                    HStack(spacing: 2) {
                        Spacer()
                        ForEach(0..<4) { _ in
                            Rectangle()
                                .fill(Color.white.opacity(0.5))
                                .frame(width: 4, height: 20)
                        }
                    }
                    
                    // Car Icon
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundColor(color)
                        .shadow(color: color.opacity(0.6), radius: 5)
                        .offset(x: (geo.size.width - 30) * progress) 
                        .animation(.linear(duration: 0.1), value: progress)
                }
            }
            .frame(height: 30)
        }
    }
}

struct TextDisplayView: View {
    let fullText: String
    let typedText: String
    
    var body: some View {
        ScrollView {
            Text(buildText())
                .font(.system(size: 24, weight: .medium, design: .monospaced))
                .lineSpacing(8)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func buildText() -> AttributedString {
        var attributedRequest = AttributedString(fullText)
        
        let typedCount = typedText.count
        if typedCount == 0 { return attributedRequest }
        
        // Color typed part green
        let index = attributedRequest.index(attributedRequest.startIndex, offsetByCharacters: typedCount)
        attributedRequest[attributedRequest.startIndex..<index].foregroundColor = .green
        
        // Upcoming part gray
        attributedRequest[index..<attributedRequest.endIndex].foregroundColor = .gray
        
        // Highlight cursor/next char
        if index < attributedRequest.endIndex {
             let nextIndex = attributedRequest.index(afterCharacter: index)
             attributedRequest[index..<nextIndex].foregroundColor = .white
             attributedRequest[index..<nextIndex].underlineStyle = .single
        }
        
        return attributedRequest
    }
}

#Preview {
    RacerGameView()
}
