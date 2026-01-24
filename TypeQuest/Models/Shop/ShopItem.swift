import Foundation
import SwiftData

@Model
final class ShopItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var itemDescription: String
    var category: ShopCategory
    var price: Int
    var iconName: String
    var isPurchased: Bool
    var isEquipped: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        itemDescription: String,
        category: ShopCategory,
        price: Int,
        iconName: String,
        isPurchased: Bool = false,
        isEquipped: Bool = false
    ) {
        self.id = id
        self.name = name
        self.itemDescription = itemDescription
        self.category = category
        self.price = price
        self.iconName = iconName
        self.isPurchased = isPurchased
        self.isEquipped = isEquipped
    }
}

enum ShopCategory: String, Codable, CaseIterable {
    case keyboardTheme = "Keyboard Themes"
    case avatar = "Avatars"
    case badge = "Badges"
    case powerUp = "Power-Ups"
    
    var iconName: String {
        switch self {
        case .keyboardTheme: return "keyboard"
        case .avatar: return "person.circle"
        case .badge: return "star.circle"
        case .powerUp: return "bolt.circle"
        }
    }
}
