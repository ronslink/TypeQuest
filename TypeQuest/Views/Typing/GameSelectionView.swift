import SwiftUI

struct GameSelectionView: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @ObservedObject var localizer = Localizer.shared
    
    enum GameType {
        case rain
        case racer
        case rpg
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("arcade_mode".localized)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 24) {
                    
                    // RAIN MODE CARD
                    NavigationLink(destination: RainGameView()) {
                        GameCard(
                            title: "rain_mode".localized,
                            description: "rain_desc".localized,
                            icon: "cloud.rain.fill",
                            color1: .cyan,
                            color2: .blue
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // RACER MODE CARD
                    NavigationLink(destination: RacerGameView()) {
                        GameCard(
                            title: "racer_mode".localized,
                            description: "racer_desc".localized,
                            icon: "car.fill",
                            color1: .orange,
                            color2: .red
                        )
                    }
                    .buttonStyle(.plain)
                    
                    // SPELL CASTER (RPG)
                    NavigationLink(destination: RPGGameView()) {
                        GameCard(
                            title: "spell_caster".localized,
                            description: "spell_desc".localized,
                            icon: "wand.and.stars",
                            color1: .purple,
                            color2: .indigo,
                            isLocked: false
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
        }
        .background(Color(NSColor.windowBackgroundColor)) // Adaptive background
    }
}

struct GameCard: View {
    let title: String
    let description: String
    let icon: String
    let color1: Color
    let color2: Color
    var isLocked: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(colors: [color1.opacity(0.8), color2.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .shadow(radius: 10)
            
            HStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .frame(width: 80)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.leading)
                    
                    if isLocked {
                        Label("locked".localized, systemImage: "lock.fill")
                            .font(.caption)
                            .padding(6)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .padding(.top, 4)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .frame(height: 140)
        .opacity(isLocked ? 0.6 : 1.0)
        .scaleEffect(isLocked ? 0.98 : 1.0)
    }
}

#Preview {
    GameSelectionView()
}
