import SwiftUI

struct RPGGameView: View {
    @StateObject private var viewModel = RPGGameViewModel()
    @EnvironmentObject var navigationManager: NavigationManager
    
    var body: some View {
        ZStack {
            // Background
            GameBackgroundView(imageName: "rpg_bg")
            
            VStack {
                // Top Bar: Enemy Status
                EnemyView(hp: viewModel.enemyHP, maxHP: viewModel.enemyMaxHP, isDamaged: viewModel.enemyDamageAnim)
                    .padding(.top, 40)
                
                Spacer()
                
                // Center Area: Combat Log or Action
                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(viewModel.combatLog, id: \.self) { log in
                            Text(log)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                .frame(height: 100)
                .padding()
                
                // Typing Area (if casting)
                if let activeSpell = viewModel.activeSpell {
                    VStack(spacing: 16) {
                        Text("CASTING: \(activeSpell.type.rawValue.uppercased())")
                            .font(.headline)
                            .foregroundColor(activeSpell.color)
                        
                        TextDisplayView(fullText: activeSpell.word, typedText: viewModel.typedSpellText)
                            .scaleEffect(1.5)
                        
                        Button("Cancel") {
                            withAnimation {
                                viewModel.activeSpell = nil
                                viewModel.typedSpellText = ""
                            }
                        }
                        .foregroundColor(.red)
                        .padding(.top)
                    }
                    .padding()
                    .background(Material.thin)
                    .cornerRadius(16)
                    .padding(.horizontal)
                    .transition(.scale)
                } else if viewModel.isBattleActive {
                     // Spell Selection
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.availableSpells) { spell in
                                SpellCard(spell: spell) {
                                    withAnimation {
                                        viewModel.selectSpell(spell)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                Spacer()
                
                // Bottom Bar: Player Status
                PlayerView(hp: viewModel.playerHP, maxHP: viewModel.playerMaxHP, isDamaged: viewModel.playerDamageAnim)
                    .padding(.bottom, 20)
            }
            .blur(radius: viewModel.isBattleActive ? 0 : 5)
            
            // Overlays (Start / Game Over)
            if !viewModel.isBattleActive {
                ZStack {
                    Color.black.opacity(0.6).ignoresSafeArea()
                    
                    VStack(spacing: 20) {
                        if let result = viewModel.battleResult {
                            Text(result ? "VICTORY" : "DEFEAT")
                                .font(.system(size: 60, weight: .black))
                                .foregroundStyle(result ? .green : .red)
                        } else {
                            Text("SPELL CASTER")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(.purple)
                        }
                        
                        Button(action: {
                            withAnimation {
                                viewModel.startBattle()
                            }
                        }) {
                            Text("Start Battle")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 16)
                                .background(Color.indigo)
                                .cornerRadius(30)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .onAppear {
            AudioManager.shared.playMusic(.victory) // Or .energetic
        }
        .onDisappear {
            viewModel.stopBattle()
            AudioManager.shared.stopMusic()
        }
    }
}

// Subcomponents

struct EnemyView: View {
    let hp: Int
    let maxHP: Int
    let isDamaged: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "bug.fill") // Syntax Bug!
                .font(.system(size: 80))
                .foregroundColor(isDamaged ? .red : .green) // Turn red when hit
                .scaleEffect(isDamaged ? 1.1 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.3), value: isDamaged)
            
            Text("Syntax Error")
                .font(.headline)
                .foregroundColor(.white)
            
            HealthBar(current: hp, max: maxHP, color: .red)
                .frame(width: 200, height: 12)
        }
    }
}

struct PlayerView: View {
    let hp: Int
    let maxHP: Int
    let isDamaged: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("YOU")
                    .font(.headline)
                    .foregroundColor(isDamaged ? .red : .white)
                
                HealthBar(current: hp, max: maxHP, color: .green)
                    .frame(width: 200, height: 12)
                
                Text("\(hp) / \(maxHP) HP")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct HealthBar: View {
    let current: Int
    let max: Int
    let color: Color
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.3))
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(color)
                    .frame(width: geo.size.width * (CGFloat(current) / CGFloat(max)))
                    .animation(.linear, value: current)
            }
        }
    }
}

struct SpellCard: View {
    let spell: Spell
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: iconFor(spell.type))
                    Spacer()
                    Text("\(abs(spell.damage))")
                        .font(.caption)
                        .fontWeight(.bold)
                }
                
                Text(spell.type.rawValue)
                    .font(.headline) // Make it dense
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(spell.word.uppercased())
                    .font(.caption)
                    .fontWeight(.black)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
            .frame(width: 120, height: 140)
            .background(spell.color.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(12)
            .shadow(radius: 5)
        }
        .buttonStyle(.plain)
    }
    
    func iconFor(_ type: SpellType) -> String {
        switch type {
        case .fire: return "flame.fill"
        case .ice: return "snowflake"
        case .heal: return "heart.fill"
        case .shield: return "shield.fill"
        }
    }
}

#Preview {
    RPGGameView()
}
