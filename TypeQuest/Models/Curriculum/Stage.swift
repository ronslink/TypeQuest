import Foundation

struct Stage: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let themeName: String
    let description: String
    let iconName: String
    let modules: [Module]
}
