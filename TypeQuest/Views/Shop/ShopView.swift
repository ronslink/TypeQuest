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
                        ShopItemCard(item: item) {
                            viewModel.purchase(item)
                        }
                        .id(item.id)
                    }
                }
                .padding()
            }
        }
        .background(Color.canvasDark)
    }
}

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

struct ShopItemCard: View {
    let item: ShopItem
    let onPurchase: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.indigoPrimary.opacity(0.3), .purple.opacity(0.3)],
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
            
            // Price or Status
            if item.isPurchased {
                if item.isEquipped {
                    Label("Equipped", systemImage: "checkmark.circle.fill")
                        .font(.subheadline)
                        .foregroundColor(.success)
                } else {
                    Button("Equip") {
                        // TODO: Implement equip functionality
                    }
                    .font(.subheadline)
                    .foregroundColor(.indigoPrimary)
                }
            } else {
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
                    .background(Color.indigoPrimary)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.surfaceDark)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(item.isPurchased ? Color.success.opacity(0.3) : Color.clear, lineWidth: 2)
        )
    }
}

// MARK: - ViewModel
@MainActor
class ShopViewModel: ObservableObject {
    @Published var availableItems: [ShopItem] = []
    @Published var inkBalance: Int = 0
    
    private let dataManager = DataManager.shared
    
    init() {
        loadData()
    }
    
    func loadData() {
        inkBalance = dataManager.currentUser?.inkCurrency ?? 0
        
        // Try to fetch purchased items from SwiftData
        loadPersistedItems()
        
        // If no items exist, create defaults
        if availableItems.isEmpty {
            availableItems = createDefaultItems()
            // Save default items to SwiftData
            saveItemsToSwiftData()
        }
    }
    
    func items(for category: ShopCategory) -> [ShopItem] {
        availableItems.filter { $0.category == category }
    }
    
    func purchase(_ item: ShopItem) {
        guard !item.isPurchased, inkBalance >= item.price else { return }
        
        // Deduct balance
        inkBalance -= item.price
        dataManager.currentUser?.inkCurrency = inkBalance
        try? dataManager.saveUser()
        
        // Mark as purchased in our local array
        if let index = availableItems.firstIndex(where: { $0.id == item.id }) {
            availableItems[index].isPurchased = true
        }
        
        // Persist the purchase to SwiftData
        persistPurchase(item)
    }
    
    // MARK: - Persistence
    
    private func loadPersistedItems() {
        // Load items that were previously purchased
        // For now, we'll check UserDefaults as a simple persistence layer
        // In production, this would query SwiftData
        
        let purchasedIDs = UserDefaults.standard.stringArray(forKey: "purchasedShopItems") ?? []
        
        // Create default items with purchase status from persistence
        availableItems = createDefaultItems().map { item in
            var mutableItem = item
            mutableItem.isPurchased = purchasedIDs.contains(item.id.uuidString)
            return mutableItem
        }
    }
    
    private func persistPurchase(_ item: ShopItem) {
        var purchasedIDs = UserDefaults.standard.stringArray(forKey: "purchasedShopItems") ?? []
        
        if !purchasedIDs.contains(item.id.uuidString) {
            purchasedIDs.append(item.id.uuidString)
            UserDefaults.standard.set(purchasedIDs, forKey: "purchasedShopItems")
        }
    }
    
    private func saveItemsToSwiftData() {
        // Save all items to SwiftData for future reference
        for item in availableItems {
            dataManager.modelContext?.insert(item)
        }
        try? dataManager.modelContext?.save()
    }
    
    private func createDefaultItems() -> [ShopItem] {
        return [
            // Keyboard Themes
            ShopItem(name: "Midnight Theme", itemDescription: "Dark purple keyboard", category: .keyboardTheme, price: 100, iconName: "moon.stars"),
            ShopItem(name: "Ocean Theme", itemDescription: "Deep blue vibes", category: .keyboardTheme, price: 150, iconName: "water.waves"),
            ShopItem(name: "Sunset Theme", itemDescription: "Warm orange glow", category: .keyboardTheme, price: 150, iconName: "sun.horizon"),
            ShopItem(name: "Neon Theme", itemDescription: "Glow in the dark", category: .keyboardTheme, price: 200, iconName: "sparkles"),
            ShopItem(name: "Forest Theme", itemDescription: "Nature vibes", category: .keyboardTheme, price: 120, iconName: "leaf"),
            
            // Avatars
            ShopItem(name: "Robot Avatar", itemDescription: "Beep boop!", category: .avatar, price: 200, iconName: "cpu"),
            ShopItem(name: "Wizard Avatar", itemDescription: "Master of keys", category: .avatar, price: 250, iconName: "wand.and.stars"),
            ShopItem(name: "Ninja Avatar", itemDescription: "Silent but deadly", category: .avatar, price: 300, iconName: "star.circle"),
            
            // Badges
            ShopItem(name: "Speed Badge", itemDescription: "For the swift", category: .badge, price: 50, iconName: "hare"),
            ShopItem(name: "Accuracy Badge", itemDescription: "Precision matters", category: .badge, price: 50, iconName: "target"),
            ShopItem(name: "Master Badge", itemDescription: "Typing master", category: .badge, price: 500, iconName: "crown"),
            
            // Power-Ups
            ShopItem(name: "2x XP Boost", itemDescription: "Next 5 lessons", category: .powerUp, price: 300, iconName: "bolt"),
            ShopItem(name: "Hint Pack", itemDescription: "10 hints included", category: .powerUp, price: 150, iconName: "questionmark.circle")
        ]
    }
}
