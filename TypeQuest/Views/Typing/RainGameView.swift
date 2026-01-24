import SwiftUI

struct RainGameView: View {
    @StateObject private var viewModel = RainGameViewModel()
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Background
                GameBackgroundView(imageName: "rain_bg")
                
                // Falling Items
                ForEach(viewModel.fallingItems) { item in
                    ZStack {
                        // Scrabble Tile Design
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 0.96, green: 0.90, blue: 0.76)) // Cream/Wood color
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 1, y: 2) // Depth shadow
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
                            )
                        
                        Text(item.text.uppercased())
                            .font(.system(size: 28, weight: .bold, design: .serif))
                            .foregroundColor(.black.opacity(0.8))
                        
                        // Little score number (like Scrabble) - decorative
                        Text("1") 
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.black.opacity(0.6))
                            .offset(x: 14, y: 14)
                    }
                    .frame(width: 50, height: 50)
                    .position(
                        x: item.xPosition * geo.size.width,
                        y: item.yPosition * geo.size.height
                    )
                }
                
                // HUD
                VStack {
                   // ... (HUD content stays same)
                    HStack {
                        // Score
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("\(viewModel.score)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Material.thin)
                        .cornerRadius(12)
                        
                        Spacer()
                        
                        // Lives
                        HStack(spacing: 4) {
                            ForEach(0..<5) { index in
                                Image(systemName: "heart.fill")
                                    .foregroundColor(index < viewModel.lives ? .red : .gray.opacity(0.3))
                            }
                        }
                        .padding()
                        .background(Material.thin)
                        .cornerRadius(12)
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Keyboard Overlay
                    if viewModel.isGameActive {
                        KeyboardView(highlightedKeys: Set(viewModel.fallingItems.map { $0.text.lowercased() }))
                            .padding(.bottom, 20)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                
                // Game Over / Start Overlay
                if !viewModel.isGameActive {
                    ZStack {
                        Color.black.opacity(0.7).ignoresSafeArea()
                        
                        VStack(spacing: 24) {
                            Text(viewModel.isGameOver ? "GAME OVER" : "RAIN MODE")
                                .font(.system(size: 50, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(colors: [.cyan, .purple], startPoint: .leading, endPoint: .trailing)
                                )
                                .shadow(color: .purple, radius: 10)
                            
                            if viewModel.isGameOver {
                                Text("Final Score: \(viewModel.score)")
                                    .font(.title)
                                    .foregroundColor(.white)
                            } else {
                                Text("Type the falling letters before they hit the bottom!")
                                    .font(.body)
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
                            Button(action: {
                                withAnimation {
                                    viewModel.startGame()
                                }
                            }) {
                                Text(viewModel.isGameOver ? "Play Again" : "Start Game")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 40)
                                    .padding(.vertical, 16)
                                    .background(
                                        LinearGradient(colors: [.indigo, .purple], startPoint: .leading, endPoint: .trailing)
                                    )
                                    .cornerRadius(30)
                                    .shadow(color: .indigo.opacity(0.5), radius: 10)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding()
                        .background(Material.ultraThin)
                        .cornerRadius(24)
                        .shadow(radius: 20)
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            AudioManager.shared.playMusic(.zen)
        }
        .onDisappear {
            viewModel.stopGame()
            AudioManager.shared.stopMusic()
        }
    }
}

#Preview {
    RainGameView()
        .environmentObject(NavigationManager())
}
