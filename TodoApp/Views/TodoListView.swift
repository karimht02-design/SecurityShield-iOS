import SwiftUI

struct TodoListView: View {
    @StateObject var storage = TodoStorage()
    @State private var showingAddTodo = false
    @State private var searchText = ""
    @State private var selectedFilter: FilterOption = .all
    
    enum FilterOption {
        case all, today, pending, completed, overdue
    }
    
    var filteredTodos: [TodoItem] {
        let filtered: [TodoItem]
        
        switch selectedFilter {
        case .all:
            filtered = storage.todos
        case .today:
            filtered = storage.getTodaysTodos()
        case .pending:
            filtered = storage.todos.filter { !$0.isCompleted }
        case .completed:
            filtered = storage.todos.filter { $0.isCompleted }
        case .overdue:
            filtered = storage.getOverdueTodos()
        }
        
        return filtered.filter { todo in
            searchText.isEmpty || todo.title.localizedCaseInsensitiveContains(searchText) || todo.description.localizedCaseInsensitiveContains(searchText)
        }.sorted { $0.dueDate ?? Date.distantFuture < $1.dueDate ?? Date.distantFuture }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // إحصائيات
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        StatBox(icon: "📋", label: "الكل", value: storage.todos.count, color: .blue)
                        StatBox(icon: "⏳", label: "قيد الانتظار", value: storage.getPendingCount(), color: .orange)
                        StatBox(icon: "✅", label: "مكتملة", value: storage.getCompletedCount(), color: .green)
                        StatBox(icon: "🔴", label: "عاجلة", value: storage.getHighPriorityCount(), color: .red)
                    }
                    .padding()
                }
                .background(Color(.systemGray6))
                
                // البحث
                SearchBar(text: $searchText)
                    .padding()
                
                // خيارات التصفية
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach([FilterOption.all, .today, .pending, .completed, .overdue], id: \.self) { option in
                            FilterButton(option: option, isSelected: selectedFilter == option) {
                                selectedFilter = option
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                
                // قائمة المهام
                if filteredTodos.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("لا توجد مهام")
                            .font(.headline)
                        Text("أضف مهمة جديدة للبدء")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    List {
                        ForEach(filteredTodos) { todo in
                            TodoRowView(todo: todo, storage: storage)
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                storage.deleteTodo(filteredTodos[index].id)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("📋 قائمة المهام")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddTodo = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTodo) {
                AddTodoView(storage: storage, isPresented: $showingAddTodo)
            }
        }
        .environmentObject(storage)
    }
}

struct StatBox: View {
    let icon: String
    let label: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.title)
            Text("\(value)")
                .font(.headline)
                .foregroundColor(color)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct FilterButton: View {
    let option: TodoListView.FilterOption
    let isSelected: Bool
    let action: () -> Void
    
    var label: String {
        switch option {
        case .all: return "الكل"
        case .today: return "اليوم"
        case .pending: return "قيد الانتظار"
        case .completed: return "مكتملة"
        case .overdue: return "متأخرة"
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(isSelected ? .white : .blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .cornerRadius(8)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("ابحث عن مهمة...", text: $text)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    TodoListView()
}
