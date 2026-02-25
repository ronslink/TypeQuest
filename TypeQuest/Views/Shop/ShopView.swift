import SwiftUI
import SwiftData

struct ShopView: View {
    @StateObject private var viewModel = ShopViewModel()
    @State private var selectedCategory: ShopCategory = .keyboardTheme

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Shop")
                    .font(AppTypography.h1)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                    .coordinatedEntrance(delay: 0)

                Spacer()

                // Currency Display
                HStack(spacing: 10) {
                    Image(systemName: "drop.fill")
                        .font(.title3)
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.accent)
                    Text("\(viewModel.inkBalance)")
                        .font(AppTypography.metricSmall)
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                    Text("Ink")
                        .font(AppTypography.body)
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .premiumGlassCard(cornerRadius: 14, intensity: 0.1, padding: 0)
                .coordinatedEntrance(delay: 0.1)
            }
            .padding()

            // Category Picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(ShopCategory.allCases.enumerated()), id: \.element) { index, category in
                        CategoryTab(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                        .coordinatedEntrance(delay: 0.15 + Double(index) * 0.05)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom)

            // Items Grid
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 180), spacing: 16)
                ], spacing: 16) {
                    ForEach(viewModel.items(for: selectedCategory)) { item in
                        ShopItemCard(
                            item: item,
                            canAfford: viewModel.inkBalance >= item.price,
                            onPurchase: { viewModel.purchase(item) },
                            onEquip: { viewModel.equip(item) },
                            onUnequip: { viewModel.unequip(item) }
                        )
                        .id(item.id)
                    }
                }
                .padding()
            }
        }
        // Toast for insufficient funds
        .overlay(alignment: .bottom) {
            if viewModel.showInsufficientFunds {
                InsufficientFundsToast()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 24)
            }
        }
        .animation(AppAnimation.component, value: viewModel.showInsufficientFunds)
    }
}

// MARK: - Category Tab

struct CategoryTab: View {
    let category: ShopCategory
    let isSelected: Bool
    let action: () -> Void
    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.iconName)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                Text(category.rawValue)
                    .font(AppTypography.body)
                    .fontWeight(isSelected ? .semibold : .medium)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        isSelected
                        ? ThemeManager.shared.currentTheme.colors.primary
                        : (isHovered ? Color.surfaceElevated : Color.surfaceDark)
                    )
            )
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? Color.white.opacity(0.2) : Color.clear,
                        lineWidth: 1
                    )
            )
            .shadow(
                color: isSelected ? ThemeManager.shared.currentTheme.colors.primary.opacity(0.4) : .clear,
                radius: 8,
                x: 0,
                y: 3
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isHovered && !isSelected ? 1.03 : 1.0)
        .animation(AppAnimation.micro, value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Shop Item Card

struct ShopItemCard: View {
    let item: ShopItem
    let canAfford: Bool
    let onPurchase: () -> Void
    let onEquip: () -> Void
    let onUnequip: () -> Void
    @State private var isHovered = false

    var body: some View {
        VStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: iconGradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 84, height: 84)
                    .shadow(color: iconShadowColor, radius: 12, x: 0, y: 6)

                Image(systemName: item.iconName)
                    .font(.system(size: 34))
                    .foregroundStyle(.white)
            }

            // Name & Description
            VStack(spacing: 6) {
                Text(item.name)
                    .font(AppTypography.h5)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textPrimary)
                    .lineLimit(1)

                Text(item.itemDescription)
                    .font(AppTypography.bodySmall)
                    .foregroundColor(ThemeManager.shared.currentTheme.colors.textSecondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }

            // Action Button
            actionButton
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(cardBackgroundColor)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(borderColor, lineWidth: item.isEquipped ? 2 : 1)
        )
        .shadow(
            color: item.isEquipped ? ThemeManager.shared.currentTheme.colors.primary.opacity(0.2) : .clear,
            radius: 12,
            x: 0,
            y: 6
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(AppAnimation.component, value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }

    // MARK: - Computed Helpers

    private var iconGradientColors: [Color] {
        if item.isEquipped {
            return [
                ThemeManager.shared.currentTheme.colors.primary,
                ThemeManager.shared.currentTheme.colors.accent
            ]
        } else if item.isPurchased {
            return [
                ThemeManager.shared.currentTheme.colors.success.opacity(0.6),
                ThemeManager.shared.currentTheme.colors.primary.opacity(0.4)
            ]
        } else {
            return [
                ThemeManager.shared.currentTheme.colors.primary.opacity(0.4),
                ThemeManager.shared.currentTheme.colors.secondary.opacity(0.3)
            ]
        }
    }
    
    private var iconShadowColor: Color {
        if item.isEquipped {
            return ThemeManager.shared.currentTheme.colors.primary.opacity(0.5)
        } else if item.isPurchased {
            return ThemeManager.shared.currentTheme.colors.success.opacity(0.3)
        } else {
            return ThemeManager.shared.currentTheme.colors.primary.opacity(0.2)
        }
    }

    private var cardBackgroundColor: Color {
        if item.isEquipped {
            return ThemeManager.shared.currentTheme.colors.primary.opacity(0.12)
        } else {
            return Color.surfaceDark
        }
    }

    private var borderColor: Color {
        if item.isEquipped { 
            return ThemeManager.shared.currentTheme.colors.accent 
        }
        if item.isPurchased { 
            return ThemeManager.shared.currentTheme.colors.success.opacity(0.5) 
        }
        return Color.white.opacity(0.08)
    }

    @ViewBuilder
    private var actionButton: some View {
        if item.isPurchased {
            if item.isEquipped {
                // Currently equipped — show unequip option
                Button {
                    onUnequip()
                } label: {
                    Label("Equipped", systemImage: "checkmark.circle.fill")
                        .font(AppTypography.body)
                        .fontWeight(.semibold)
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.accent)
                }
                .buttonStyle(.plain)
                .pressable()
            } else {
                // Purchased, not equipped
                Button {
                    onEquip()
                } label: {
                    Text("Equip")
                        .font(AppTypography.body)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(ThemeManager.shared.currentTheme.colors.primary.opacity(0.2))
                        )
                        .foregroundColor(ThemeManager.shared.currentTheme.colors.primary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(ThemeManager.shared.currentTheme.colors.primary.opacity(0.4), lineWidth: 1.5)
                        )
                }
                .buttonStyle(.plain)
                .pressable()
            }
        } else {
            // Not purchased — show buy button
            Button {
                onPurchase()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 12))
                    Text("\(item.price)")
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(canAfford ? ThemeManager.shared.currentTheme.colors.primary : Color.gray.opacity(0.4))
                )
                .foregroundColor(canAfford ? .white : .white.opacity(0.5))
                .shadow(
                    color: canAfford ? ThemeManager.shared.currentTheme.colors.primary.opacity(0.4) : .clear,
                    radius: 8,
                    x: 0,
                    y: 3
                )
            }
            .buttonStyle(.plain)
            .disabled(!canAfford)
            .pressable()
        }
    }
}

// MARK: - Insufficient Funds Toast

struct InsufficientFundsToast: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
            Text("Not enough Ink!")
                .font(AppTypography.body)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .premiumGlassCard(cornerRadius: 28, intensity: 0.2, padding: 0)
        .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
    }
}

// MARK: - ViewModel

@MainActor
class ShopViewModel: ObservableObject {
    @Published var availableItems: [ShopItem] = []
    @Published var inkBalance: Int = 0
    @Published var showInsufficientFunds: Bool = false

    private let dataManager = DataManager.shared
    private let themeManager = ThemeManager.shared

    // UserDefaults keys for non-theme equip state
    private let equippedAvatarKey = "equippedAvatarItemID"
    private let equippedBadgeKey = "equippedBadgeItemID"
    private let equippedPowerUpKey = "equippedPowerUpItemID"

    init() {
        loadData()
    }

    func loadData() {
        inkBalance = dataManager.currentUser?.inkCurrency ?? 0
        let defaults = createDefaultItems()
        // Load from SwiftData (seeds defaults on first run)
        availableItems = dataManager.fetchShopItems(defaults: defaults)
        // Restore equipped state from external managers
        syncEquippedState()
    }

    func items(for category: ShopCategory) -> [ShopItem] {
        availableItems.filter { $0.category == category }
    }

    // MARK: - Purchase

    func purchase(_ item: ShopItem) {
        guard !item.isPurchased else { return }
        guard inkBalance >= item.price else {
            triggerInsufficientFunds()
            return
        }

        inkBalance -= item.price
        dataManager.currentUser?.inkCurrency = inkBalance
        item.isPurchased = true
        dataManager.saveShopContext()
        try? dataManager.saveUser()
    }

    // MARK: - Equip / Unequip

    func equip(_ item: ShopItem) {
        guard item.isPurchased else { return }

        switch item.category {
        case .keyboardTheme:
            equipTheme(item)
        case .avatar:
            equipInCategory(.avatar, item: item, key: equippedAvatarKey)
        case .badge:
            equipInCategory(.badge, item: item, key: equippedBadgeKey)
        case .powerUp:
            equipInCategory(.powerUp, item: item, key: equippedPowerUpKey)
        }

        dataManager.saveShopContext()
    }

    func unequip(_ item: ShopItem) {
        switch item.category {
        case .keyboardTheme:
            // Revert to default midnight theme
            item.isEquipped = false
            themeManager.currentTheme = .midnight
            UserDefaults.standard.removeObject(forKey: "selectedTheme")
        case .avatar:
            item.isEquipped = false
            UserDefaults.standard.removeObject(forKey: equippedAvatarKey)
        case .badge:
            item.isEquipped = false
            UserDefaults.standard.removeObject(forKey: equippedBadgeKey)
        case .powerUp:
            item.isEquipped = false
            UserDefaults.standard.removeObject(forKey: equippedPowerUpKey)
        }
        dataManager.saveShopContext()
    }

    // MARK: - Private Helpers

    private func equipTheme(_ item: ShopItem) {
        // Unequip all other themes first
        availableItems
            .filter { $0.category == .keyboardTheme && $0.isEquipped }
            .forEach { $0.isEquipped = false }

        item.isEquipped = true

        // Map shop item name to ThemeManager preset
        let preset = themePreset(for: item.name)
        themeManager.currentTheme = preset
    }

    private func equipInCategory(_ category: ShopCategory, item: ShopItem, key: String) {
        // Unequip all others in category
        availableItems
            .filter { $0.category == category && $0.isEquipped }
            .forEach { $0.isEquipped = false }

        item.isEquipped = true
        UserDefaults.standard.set(item.id.uuidString, forKey: key)
    }

    private func themePreset(for itemName: String) -> ThemeManager.AppThemePreset {
        switch itemName {
        case "Ocean Theme":    return .ocean
        case "Sunset Theme":   return .sunset
        case "Forest Theme":   return .forest
        case "Neon Theme":     return .lavender
        default:               return .midnight
        }
    }

    /// After loading items from SwiftData, reconcile isEquipped with ThemeManager/UserDefaults.
    private func syncEquippedState() {
        for item in availableItems {
            switch item.category {
            case .keyboardTheme:
                let preset = themePreset(for: item.name)
                item.isEquipped = (preset == themeManager.currentTheme) && item.isPurchased
            case .avatar:
                let equippedID = UserDefaults.standard.string(forKey: equippedAvatarKey)
                item.isEquipped = (equippedID == item.id.uuidString) && item.isPurchased
            case .badge:
                let equippedID = UserDefaults.standard.string(forKey: equippedBadgeKey)
                item.isEquipped = (equippedID == item.id.uuidString) && item.isPurchased
            case .powerUp:
                let equippedID = UserDefaults.standard.string(forKey: equippedPowerUpKey)
                item.isEquipped = (equippedID == item.id.uuidString) && item.isPurchased
            }
        }
    }

    private func triggerInsufficientFunds() {
        showInsufficientFunds = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.showInsufficientFunds = false
        }
    }

    // MARK: - Default Items
    // UUIDs are hardcoded so they are stable across launches.
    // ShopItem.id is @Attribute(.unique) so SwiftData won't re-insert duplicates.

    private func createDefaultItems() -> [ShopItem] {
        return [
            // Keyboard Themes
            ShopItem(
                id: UUID(uuidString: "A1000001-0000-0000-0000-000000000001")!,
                name: "Midnight Theme",
                itemDescription: "Dark purple keyboard",
                category: .keyboardTheme, price: 100, iconName: "moon.stars"
            ),
            ShopItem(
                id: UUID(uuidString: "A1000001-0000-0000-0000-000000000002")!,
                name: "Ocean Theme",
                itemDescription: "Deep blue vibes",
                category: .keyboardTheme, price: 150, iconName: "water.waves"
            ),
            ShopItem(
                id: UUID(uuidString: "A1000001-0000-0000-0000-000000000003")!,
                name: "Sunset Theme",
                itemDescription: "Warm orange glow",
                category: .keyboardTheme, price: 150, iconName: "sun.horizon"
            ),
            ShopItem(
                id: UUID(uuidString: "A1000001-0000-0000-0000-000000000004")!,
                name: "Neon Theme",
                itemDescription: "Glow in the dark",
                category: .keyboardTheme, price: 200, iconName: "sparkles"
            ),
            ShopItem(
                id: UUID(uuidString: "A1000001-0000-0000-0000-000000000005")!,
                name: "Forest Theme",
                itemDescription: "Nature vibes",
                category: .keyboardTheme, price: 120, iconName: "leaf"
            ),

            // Avatars
            ShopItem(
                id: UUID(uuidString: "A2000002-0000-0000-0000-000000000001")!,
                name: "Robot Avatar",
                itemDescription: "Beep boop!",
                category: .avatar, price: 200, iconName: "cpu"
            ),
            ShopItem(
                id: UUID(uuidString: "A2000002-0000-0000-0000-000000000002")!,
                name: "Wizard Avatar",
                itemDescription: "Master of keys",
                category: .avatar, price: 250, iconName: "wand.and.stars"
            ),
            ShopItem(
                id: UUID(uuidString: "A2000002-0000-0000-0000-000000000003")!,
                name: "Ninja Avatar",
                itemDescription: "Silent but deadly",
                category: .avatar, price: 300, iconName: "star.circle"
            ),

            // Badges
            ShopItem(
                id: UUID(uuidString: "A3000003-0000-0000-0000-000000000001")!,
                name: "Speed Badge",
                itemDescription: "For the swift",
                category: .badge, price: 50, iconName: "hare"
            ),
            ShopItem(
                id: UUID(uuidString: "A3000003-0000-0000-0000-000000000002")!,
                name: "Accuracy Badge",
                itemDescription: "Precision matters",
                category: .badge, price: 50, iconName: "target"
            ),
            ShopItem(
                id: UUID(uuidString: "A3000003-0000-0000-0000-000000000003")!,
                name: "Master Badge",
                itemDescription: "Typing master",
                category: .badge, price: 500, iconName: "crown"
            ),

            // Power-Ups
            ShopItem(
                id: UUID(uuidString: "A4000004-0000-0000-0000-000000000001")!,
                name: "2x XP Boost",
                itemDescription: "Next 5 lessons",
                category: .powerUp, price: 300, iconName: "bolt"
            ),
            ShopItem(
                id: UUID(uuidString: "A4000004-0000-0000-0000-000000000002")!,
                name: "Hint Pack",
                itemDescription: "10 hints included",
                category: .powerUp, price: 150, iconName: "questionmark.circle"
            )
        ]
    }
}
