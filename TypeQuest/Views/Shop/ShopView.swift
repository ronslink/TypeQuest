import SwiftUI

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
                    .fill(item.isPurchased ? Color.success.opacity(0.2) : Color.indigoPrimary.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: item.iconName)
                    .font(.system(size: 32))
                    .foregroundColor(item.isPurchased ? .success : .indigoPrimary)
            }
            
            // Info
            Text(item.name)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(item.itemDescription)
                .font(.caption)
                .foregroundColor(.textSecondaryDark)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Action
            if item.isPurchased {
                Text(item.isEquipped ? "Equipped" : "Owned")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.success)
            } else {
                Button(action: onPurchase) {
                    HStack {
                        Image(systemName: "drop.fill")
                        Text("\(item.price)")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.indigoPrimary)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
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
        
        // Mock items for now - in production, these would come from a database
        availableItems = [
            ShopItem(name: "Midnight Theme", itemDescription: "Dark purple keyboard", category: .keyboardTheme, price: 100, iconName: "moon.stars"),
            ShopItem(name: "Ocean Theme", itemDescription: "Deep blue vibes", category: .keyboardTheme, price: 150, iconName: "water.waves"),
            ShopItem(name: "Sunset Theme", itemDescription: "Warm orange glow", category: .keyboardTheme, price: 150, iconName: "sun.horizon"),
            ShopItem(name: "Robot Avatar", itemDescription: "Beep boop!", category: .avatar, price: 200, iconName: "cpu"),
            ShopItem(name: "Wizard Avatar", itemDescription: "Master of keys", category: .avatar, price: 250, iconName: "wand.and.stars"),
            ShopItem(name: "Speed Badge", itemDescription: "For the swift", category: .badge, price: 50, iconName: "hare"),
            ShopItem(name: "Accuracy Badge", itemDescription: "Precision matters", category: .badge, price: 50, iconName: "target"),
            ShopItem(name: "2x XP Boost", itemDescription: "Next 5 lessons", category: .powerUp, price: 300, iconName: "bolt")
        ]
    }
    
    func items(for category: ShopCategory) -> [ShopItem] {
        availableItems.filter { $0.category == category }
    }
    
    func purchase(_ item: ShopItem) {
        guard !item.isPurchased, inkBalance >= item.price else { return }
        
        // Deduct balance
        inkBalance -= item.price
        dataManager.currentUser?.inkCurrency = inkBalance
        
        // Mark as purchased
        if let index = availableItems.firstIndex(where: { $0.id == item.id }) {
            availableItems[index].isPurchased = true
        }
    }
}
