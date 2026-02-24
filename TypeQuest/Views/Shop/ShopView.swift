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
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                // Currency Display
                HStack(spacing: 8) {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.cyanAccent)
                    Text("\(viewModel.inkBalance)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Ink")
                        .foregroundColor(.textSecondaryDark)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.surfaceDark)
                .cornerRadius(12)
            }
            .padding()

            // Category Picker
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ShopCategory.allCases, id: \.self) { category in
                        CategoryTab(
                            category: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
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
        .background(Color.canvasDark)
        // Toast for insufficient funds
        .overlay(alignment: .bottom) {
            if viewModel.showInsufficientFunds {
                InsufficientFundsToast()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 24)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: viewModel.showInsufficientFunds)
    }
}

// MARK: - Category Tab

struct CategoryTab: View {
    let category: ShopCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.iconName)
                Text(category.rawValue)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.indigoPrimary : Color.surfaceDark)
            .foregroundColor(.white)
            .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Shop Item Card

struct ShopItemCard: View {
    let item: ShopItem
    let canAfford: Bool
    let onPurchase: () -> Void
    let onEquip: () -> Void
    let onUnequip: () -> Void

    var body: some View {
        VStack(spacing: 12) {
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
                    .frame(width: 80, height: 80)

                Image(systemName: item.iconName)
                    .font(.system(size: 32))
                    .foregroundStyle(.white)
            }

            // Name & Description
            VStack(spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(item.itemDescription)
                    .font(.caption)
                    .foregroundColor(.textSecondaryDark)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }

            // Action Button
            actionButton
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: 2)
        )
    }

    // MARK: - Computed Helpers

    private var iconGradientColors: [Color] {
        if item.isEquipped {
            return [.indigoPrimary.opacity(0.6), .cyanAccent.opacity(0.5)]
        } else if item.isPurchased {
            return [.success.opacity(0.3), .indigoPrimary.opacity(0.3)]
        } else {
            return [.indigoPrimary.opacity(0.3), .purple.opacity(0.3)]
        }
    }

    private var cardBackground: some View {
        Group {
            if item.isEquipped {
                Color.indigoPrimary.opacity(0.15)
            } else {
                Color.surfaceDark
            }
        }
    }

    private var borderColor: Color {
        if item.isEquipped { return Color.cyanAccent.opacity(0.6) }
        if item.isPurchased { return Color.success.opacity(0.3) }
        return Color.clear
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
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.cyanAccent)
                }
                .buttonStyle(.plain)
            } else {
                // Purchased, not equipped
                Button {
                    onEquip()
                } label: {
                    Text("Equip")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Color.indigoPrimary.opacity(0.3))
                        .foregroundColor(.indigoPrimary)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.indigoPrimary.opacity(0.5), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
        } else {
            // Not purchased — show buy button
            Button {
                onPurchase()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .font(.caption)
                    Text("\(item.price)")
                        .fontWeight(.bold)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(canAfford ? Color.indigoPrimary : Color.gray.opacity(0.4))
                .foregroundColor(canAfford ? .white : .white.opacity(0.5))
                .cornerRadius(20)
            }
            .buttonStyle(.plain)
            .disabled(!canAfford)
        }
    }
}

// MARK: - Insufficient Funds Toast

struct InsufficientFundsToast: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "drop.fill")
                .foregroundColor(.cyanAccent)
            Text("Not enough Ink!")
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.surfaceDark)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 4)
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
