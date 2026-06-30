import SwiftUI

struct TodoRowView: View {
    let todo: TodoItem
    @ObservedObject var storage: TodoStorage
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: { showingDetail = true }) {
            HStack(spacing: 12) {
                // زر الإكمال
                Button(action: {
                    storage.toggleTodo(todo.id)
                }) {
                    Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(todo.isCompleted ? .green : .gray)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(todo.title)
                            .font(.headline)
                            .strikethrough(todo.isCompleted)
                            .foregroundColor(todo.isCompleted ? .gray : .black)
                        
                        Text(todo.priority.emoji)
                            .font(.caption)
                    }
                    
                    if !todo.description.isEmpty {
                        Text(todo.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    
                    HStack(spacing: 8) {
                        if let dueDate = todo.dueDate {
                            Label(formatDate(dueDate), systemImage: "calendar")
                                .font(.caption2)
                                .foregroundColor(isOverdue(dueDate) ? .red : .orange)
                        }
                        
                        ForEach(todo.tags.prefix(2), id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption2)
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)
            .contentShape(Rectangle())
        }
        .foregroundColor(.primary)
        .sheet(isPresented: $showingDetail) {
            EditTodoView(storage: storage, todo: todo, isPresented: $showingDetail)
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar_SA")
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    func isOverdue(_ date: Date) -> Bool {
        return date < Date() && !todo.isCompleted
    }
}

#Preview {
    TodoRowView(todo: TodoItem(title: "مثال", description: "وصف"), storage: TodoStorage())
}
