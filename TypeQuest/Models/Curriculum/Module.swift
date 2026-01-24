import Foundation

struct Module: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let description: String
    let stageId: Int
    let order: Int
    let lessons: [Lesson]
}
