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
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("arcade_mode".localized)
                            .font(AppTypography.h1)
                            .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                        Text("Choose your challenge")
                            .font(AppTypography.body)
                            .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, 32)
                .padding(.top, 28)
                .padding(.bottom, 24)
                .coordinatedEntrance(delay: 0)

                    // Game Cards Grid
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 320), spacing: 20)], spacing: 20) {
                        NavigationLink(destination: RainGameView()) {
                            GameCard(
                                title: "rain_mode".localized,
                                description: "rain_desc".localized,
                                icon: "cloud.rain.fill",
                                badge: "REFLEX",
                                color1: Color(hex: "0EA5E9"),
                                color2: Color(hex: "1E40AF")
                            )
                        }
                        .buttonStyle(.plain)
                        .coordinatedEntrance(delay: 0.1)

                        NavigationLink(destination: RacerGameView()) {
                            GameCard(
                                title: "racer_mode".localized,
                                description: "racer_desc".localized,
                                icon: "car.fill",
                                badge: "SPEED",
                                color1: Color(hex: "F97316"),
                                color2: Color(hex: "DC2626")
                            )
                        }
                        .buttonStyle(.plain)
                        .coordinatedEntrance(delay: 0.2)

                        NavigationLink(destination: RPGGameView()) {
                            GameCard(
                                title: "spell_caster".localized,
                                description: "spell_desc".localized,
                                icon: "wand.and.stars",
                                badge: "STRATEGY",
                                color1: Color(hex: "9333EA"),
                                color2: Color(hex: "581C87")
                            )
                        }
                        .buttonStyle(.plain)
                        .coordinatedEntrance(delay: 0.3)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Arcade")
                    .font(AppTypography.h4)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
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
            // Card background with enhanced depth
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            color1.opacity(isHovered ? 1.0 : 0.9),
                            color2.opacity(isHovered ? 1.0 : 0.9)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
                .shadow(
                    color: color1.opacity(isHovered ? 0.5 : 0.25),
                    radius: isHovered ? 24 : 12,
                    x: 0, y: isHovered ? 10 : 5
                )

            // Decorative large icon watermark
            Image(systemName: icon)
                .font(.system(size: 110))
                .foregroundColor(.white.opacity(0.08))
                .offset(x: 25, y: -15)
                .clipped()

            // Content
            HStack(spacing: 20) {
                // Icon with enhanced styling
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 68, height: 68)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: icon)
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(AppTypography.h4)
                        .foregroundColor(.white)

                    Text(description)
                        .font(AppTypography.bodySmall)
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    if isLocked {
                        Label("Locked", systemImage: "lock.fill")
                            .font(AppTypography.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.black.opacity(0.35))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .padding(.top, 4)
                    } else {
                        Text("Play Now →")
                            .font(AppTypography.bodySmall)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.95))
                            .padding(.top, 4)
                    }
                }

                Spacer()
            }
            .padding(24)

            // Badge chip
            Text(badge)
                .font(.system(size: 10, weight: .bold))
                .tracking(1)
                .foregroundColor(color1)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.white.opacity(0.95))
                .cornerRadius(10)
                .padding(14)
                .shadow(color: color1.opacity(0.3), radius: 4, x: 0, y: 2)
        }
        .frame(height: 140)
        .opacity(isLocked ? 0.5 : 1.0)
        .scaleEffect(isHovered && !isLocked ? 1.02 : 1.0)
        .animation(AppAnimation.component, value: isHovered)
        .onHover { hovering in
            isHovered = hovering && !isLocked
        }
    }
}

#Preview {
    GameSelectionView()
}
