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
                
                // Floor
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.3), .blue.opacity(0.8)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 50)
                        .overlay(
                            Rectangle()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 1),
                            alignment: .top
                        )
                }
                .ignoresSafeArea()
                
                // Falling Items
                ForEach(viewModel.fallingItems) { item in
                    ZStack {
                        // Raindrop Visual
                        Image(systemName: "drop.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(LinearGradient(colors: [.cyanAccent, .blue], startPoint: .top, endPoint: .bottom))
                            .shadow(color: .cyan.opacity(0.5), radius: 5, x: 0, y: 0)
                        
                        Text(item.text)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .offset(y: 5) // Center in the bulb of the drop
                    }
                    .frame(width: 45, height: 60)
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
        .overlay(
             // Splash Effects Overlay (Simple implementation)
             // In a real game, ViewModel would publish "splashes" to render
             EmptyView() 
        )
    }
}

// Simple Splash Particle
struct SplashView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 1.0
    
    var body: some View {
        Circle()
            .stroke(Color.cyan, lineWidth: 2)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    scale = 2.0
                    opacity = 0.0
                }
            }
    }
}

#Preview {
    RainGameView()
        .environmentObject(NavigationManager())
}
