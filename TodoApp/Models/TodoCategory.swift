import Foundation

struct TodoCategory: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var color: String = "blue"
    var icon: String = "📝"
    var createdAt: Date = Date()
}
