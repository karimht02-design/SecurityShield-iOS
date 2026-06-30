import SwiftUI

struct StatsView: View {
    @EnvironmentObject var storage: TodoStorage
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // البطاقات الرئيسية
                    HStack(spacing: 15) {
                        StatCardLarge(
                            icon: "📊",
                            title: "إجمالي المهام",
                            value: storage.todos.count,
                            color: .blue
                        )
                        
                        StatCardLarge(
                            icon: "🔥",
                            title: "الأولوية العالية",
                            value: storage.getHighPriorityCount(),
                            color: .red
                        )
                    }
                    .padding()
                    
                    HStack(spacing: 15) {
                        StatCardLarge(
                            icon: "✅",
                            title: "مكتملة",
                            value: storage.getCompletedCount(),
                            color: .green
                        )
                        
                        StatCardLarge(
                            icon: "⏳",
                            title: "قيد الانتظار",
                            value: storage.getPendingCount(),
                            color: .orange
                        )
                    }
                    .padding()
                    
                    // نسبة الإنجاز
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📈 معدل الإنجاز")
                            .font(.headline)
                        
                        ProgressView(value: Double(storage.getCompletedCount()) / Double(max(storage.todos.count, 1)))
                            .tint(.green)
                        
                        Text("\(storage.getCompletedCount()) من \(storage.todos.count) مكتملة")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // توزيع الأولويات
                    VStack(alignment: .leading, spacing: 12) {
                        Text("⚡ توزيع الأولويات")
                            .font(.headline)
                        
                        let priorityCounts = [
                            ("عاجلة", storage.todos.filter { $0.priority == .urgent }.count, Color.red),
                            ("عالية", storage.todos.filter { $0.priority == .high }.count, Color.orange),
                            ("متوسطة", storage.todos.filter { $0.priority == .medium }.count, Color.yellow),
                            ("منخفضة", storage.todos.filter { $0.priority == .low }.count, Color.green)
                        ]
                        
                        ForEach(priorityCounts, id: \.0) { label, count, color in
                            HStack {
                                Text(label)
                                    .frame(width: 50, alignment: .leading)
                                
                                GeometryReader { geometry in
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(color)
                                        .frame(width: CGFloat(count) * (geometry.size.width / 10), alignment: .leading)
                                }
                                .frame(height: 20)
                                
                                Text("\(count)")
                                    .font(.caption)
                                    .frame(width: 30, alignment: .trailing)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // اليوميات
                    VStack(alignment: .leading, spacing: 12) {
                        Text("📅 مهام اليوم")
                            .font(.headline)
                        
                        let todayTodos = storage.getTodaysTodos()
                        if todayTodos.isEmpty {
                            Text("لا توجد مهام لهذا اليوم")
                                .foregroundColor(.gray)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(todayTodos) { todo in
                                    HStack {
                                        Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(todo.isCompleted ? .green : .gray)
                                        
                                        Text(todo.title)
                                            .strikethrough(todo.isCompleted)
                                        
                                        Spacer()
                                        
                                        Text(todo.priority.emoji)
                                    }
                                    .font(.caption)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .navigationTitle("📊 الإحصائيات")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct StatCardLarge: View {
    let icon: String
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(icon)
                    .font(.title)
                Spacer()
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text("\(value)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    StatsView()
        .environmentObject(TodoStorage())
}
