import Foundation

struct TodoItem: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var isCompleted: Bool = false
    var priority: Priority = .medium
    var dueDate: Date?
    var createdAt: Date = Date()
    var tags: [String] = []
    
    enum Priority: String, Codable, CaseIterable {
        case low = "منخفضة"
        case medium = "متوسطة"
        case high = "عالية"
        case urgent = "عاجلة"
        
        var emoji: String {
            switch self {
            case .low: return "🟢"
            case .medium: return "🟡"
            case .high: return "🟠"
            case .urgent: return "🔴"
            }
        }
    }
}
