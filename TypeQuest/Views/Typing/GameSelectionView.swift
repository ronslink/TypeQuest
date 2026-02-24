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
        ZStack {
            Color.canvasDark.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("arcade_mode".localized)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Choose your challenge")
                                .font(.subheadline)
                                .foregroundColor(.textSecondaryDark)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 28)
                    .padding(.bottom, 24)

                    // Game Cards Grid
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 320), spacing: 20)], spacing: 20) {
                        NavigationLink(destination: RainGameView()) {
                            GameCard(
                                title: "rain_mode".localized,
                                description: "rain_desc".localized,
                                icon: "cloud.rain.fill",
                                badge: "REFLEX",
                                color1: Color(red: 0.0, green: 0.65, blue: 0.85),
                                color2: Color(red: 0.1, green: 0.35, blue: 0.75)
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(destination: RacerGameView()) {
                            GameCard(
                                title: "racer_mode".localized,
                                description: "racer_desc".localized,
                                icon: "car.fill",
                                badge: "SPEED",
                                color1: Color(red: 0.95, green: 0.45, blue: 0.1),
                                color2: Color(red: 0.75, green: 0.2, blue: 0.15)
                            )
                        }
                        .buttonStyle(.plain)

                        NavigationLink(destination: RPGGameView()) {
                            GameCard(
                                title: "spell_caster".localized,
                                description: "spell_desc".localized,
                                icon: "wand.and.stars",
                                badge: "STRATEGY",
                                color1: Color(red: 0.55, green: 0.25, blue: 0.85),
                                color2: Color(red: 0.35, green: 0.15, blue: 0.65)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Arcade")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
    }
}

struct GameCard: View {
    let title: String
    let description: String
    let icon: String
    let badge: String
    let color1: Color
    let color2: Color
    var isLocked: Bool = false

    @State private var isHovered = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Card background
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [color1.opacity(isHovered ? 1.0 : 0.85),
                                 color2.opacity(isHovered ? 1.0 : 0.85)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(
                    color: color1.opacity(isHovered ? 0.45 : 0.2),
                    radius: isHovered ? 20 : 10,
                    x: 0, y: isHovered ? 8 : 4
                )

            // Decorative large icon watermark
            Image(systemName: icon)
                .font(.system(size: 100))
                .foregroundColor(.white.opacity(0.07))
                .offset(x: 20, y: -10)
                .clipped()

            // Content
            HStack(spacing: 20) {
                // Icon
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 64, height: 64)
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)

                    Text(description)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.85))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    if isLocked {
                        Label("Locked", systemImage: "lock.fill")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(6)
                            .foregroundColor(.white)
                            .padding(.top, 2)
                    } else {
                        Text("Play Now →")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.top, 2)
                    }
                }

                Spacer()
            }
            .padding(20)

            // Badge chip
            Text(badge)
                .font(.system(size: 9, weight: .bold))
                .tracking(0.8)
                .foregroundColor(color1)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.white.opacity(0.9))
                .cornerRadius(8)
                .padding(12)
        }
        .frame(height: 130)
        .opacity(isLocked ? 0.55 : 1.0)
        .scaleEffect(isHovered && !isLocked ? 1.02 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isHovered)
        .onHover { hovering in
            isHovered = hovering && !isLocked
        }
    }
}

#Preview {
    GameSelectionView()
}
