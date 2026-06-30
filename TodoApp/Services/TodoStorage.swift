import Foundation

class TodoStorage: ObservableObject {
    @Published var todos: [TodoItem] = []
    @Published var categories: [TodoCategory] = []
    @Published var selectedCategory: TodoCategory? = nil
    
    private let todosKey = "savedTodos"
    private let categoriesKey = "savedCategories"
    
    init() {
        loadTodos()
        loadCategories()
        if categories.isEmpty {
            createDefaultCategories()
        }
    }
    
    // MARK: - Todo Operations
    
    func addTodo(_ todo: TodoItem) {
        todos.append(todo)
        saveTodos()
    }
    
    func updateTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index] = todo
            saveTodos()
        }
    }
    
    func deleteTodo(_ id: UUID) {
        todos.removeAll { $0.id == id }
        saveTodos()
    }
    
    func toggleTodo(_ id: UUID) {
        if let index = todos.firstIndex(where: { $0.id == id }) {
            todos[index].isCompleted.toggle()
            saveTodos()
        }
    }
    
    // MARK: - Category Operations
    
    func addCategory(_ category: TodoCategory) {
        categories.append(category)
        saveCategories()
    }
    
    func deleteCategory(_ id: UUID) {
        categories.removeAll { $0.id == id }
        saveCategories()
    }
    
    // MARK: - Statistics
    
    func getCompletedCount() -> Int {
        return todos.filter { $0.isCompleted }.count
    }
    
    func getPendingCount() -> Int {
        return todos.filter { !$0.isCompleted }.count
    }
    
    func getHighPriorityCount() -> Int {
        return todos.filter { !$0.isCompleted && ($0.priority == .high || $0.priority == .urgent) }.count
    }
    
    func getOverdueCount() -> Int {
        return todos.filter { !$0.isCompleted && $0.dueDate ?? Date() < Date() }.count
    }
    
    // MARK: - Filtering
    
    func getTodaysTodos() -> [TodoItem] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        return todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return calendar.startOfDay(for: dueDate) == today
        }
    }
    
    func getOverdueTodos() -> [TodoItem] {
        return todos.filter { todo in
            guard let dueDate = todo.dueDate else { return false }
            return dueDate < Date() && !todo.isCompleted
        }
    }
    
    // MARK: - Local Storage
    
    private func saveTodos() {
        if let encoded = try? JSONEncoder().encode(todos) {
            UserDefaults.standard.set(encoded, forKey: todosKey)
        }
    }
    
    private func loadTodos() {
        if let data = UserDefaults.standard.data(forKey: todosKey),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            todos = decoded
        }
    }
    
    private func saveCategories() {
        if let encoded = try? JSONEncoder().encode(categories) {
            UserDefaults.standard.set(encoded, forKey: categoriesKey)
        }
    }
    
    private func loadCategories() {
        if let data = UserDefaults.standard.data(forKey: categoriesKey),
           let decoded = try? JSONDecoder().decode([TodoCategory].self, from: data) {
            categories = decoded
        }
    }
    
    private func createDefaultCategories() {
        let defaultCategories = [
            TodoCategory(name: "العمل", color: "blue", icon: "💼"),
            TodoCategory(name: "المنزل", color: "green", icon: "🏠"),
            TodoCategory(name: "التسوق", color: "orange", icon: "🛒"),
            TodoCategory(name: "الصحة", color: "red", icon: "❤️"),
            TodoCategory(name: "التعليم", color: "purple", icon: "📚")
        ]
        
        categories = defaultCategories
        saveCategories()
    }
    
    // MARK: - Export & Import
    
    func exportTodos() -> String? {
        if let encoded = try? JSONEncoder().encode(todos),
           let json = String(data: encoded, encoding: .utf8) {
            return json
        }
        return nil
    }
    
    func importTodos(_ json: String) {
        if let data = json.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([TodoItem].self, from: data) {
            todos.append(contentsOf: decoded)
            saveTodos()
        }
    }
}
