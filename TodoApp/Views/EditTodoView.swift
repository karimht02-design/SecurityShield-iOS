import SwiftUI

struct EditTodoView: View {
    @ObservedObject var storage: TodoStorage
    var todo: TodoItem
    @Binding var isPresented: Bool
    
    @State private var title: String
    @State private var description: String
    @State private var selectedPriority: TodoItem.Priority
    @State private var dueDate: Date?
    @State private var tags: [String]
    @State private var tagInput = ""
    @State private var showDeleteAlert = false
    
    init(storage: TodoStorage, todo: TodoItem, isPresented: Binding<Bool>) {
        self.storage = storage
        self.todo = todo
        self._isPresented = isPresented
        
        _title = State(initialValue: todo.title)
        _description = State(initialValue: todo.description)
        _selectedPriority = State(initialValue: todo.priority)
        _dueDate = State(initialValue: todo.dueDate)
        _tags = State(initialValue: todo.tags)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("الحالة")) {
                    Toggle("مكتملة", isOn: Binding(
                        get: { todo.isCompleted },
                        set: { isCompleted in
                            var updatedTodo = todo
                            updatedTodo.isCompleted = isCompleted
                            storage.updateTodo(updatedTodo)
                        }
                    ))
                }
                
                Section(header: Text("المعلومات")) {
                    TextField("العنوان", text: $title)
                    TextField("الوصف", text: $description, axis: .vertical)
                        .lineLimit(3...)
                }
                
                Section(header: Text("الأولوية والموعد")) {
                    Picker("الأولوية", selection: $selectedPriority) {
                        ForEach(TodoItem.Priority.allCases, id: \.self) { priority in
                            Text("\(priority.emoji) \(priority.rawValue)").tag(priority)
                        }
                    }
                    
                    if dueDate != nil {
                        DatePicker("التاريخ", selection: Binding(get: { dueDate ?? Date() }, set: { dueDate = $0 }), displayedComponents: .date)
                    }
                    
                    Button(action: { dueDate = dueDate == nil ? Date() : nil }) {
                        if let date = dueDate {
                            Text("✓ التاريخ: \(formatDate(date))")
                                .foregroundColor(.green)
                        } else {
                            Text("+ إضافة تاريخ")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Section(header: Text("الوسوم")) {
                    HStack {
                        TextField("وسم جديد", text: $tagInput)
                        Button(action: addTag) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                    
                    if !tags.isEmpty {
                        FlowLayout {
                            ForEach(tags, id: \.self) { tag in
                                HStack(spacing: 8) {
                                    Text("#\(tag)")
                                        .font(.caption)
                                    
                                    Button(action: { removeTag(tag) }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.caption2)
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                
                Section(header: Text("خطر")) {
                    Button(action: { showDeleteAlert = true }) {
                        Label("حذف المهمة", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("تعديل المهمة")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("إلغاء") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("حفظ") {
                        saveChanges()
                    }
                }
            }
            .alert("تأكيد الحذف", isPresented: $showDeleteAlert) {
                Button("حذف", role: .destructive) {
                    storage.deleteTodo(todo.id)
                    isPresented = false
                }
                Button("إلغاء", role: .cancel) {}
            } message: {
                Text("هل أنت متأكد من رغبتك في حذف هذه المهمة؟")
            }
        }
    }
    
    func addTag() {
        if !tagInput.isEmpty && !tags.contains(tagInput) {
            tags.append(tagInput)
            tagInput = ""
        }
    }
    
    func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
    
    func saveChanges() {
        var updatedTodo = todo
        updatedTodo.title = title
        updatedTodo.description = description
        updatedTodo.priority = selectedPriority
        updatedTodo.dueDate = dueDate
        updatedTodo.tags = tags
        
        storage.updateTodo(updatedTodo)
        isPresented = false
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar_SA")
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    EditTodoView(storage: TodoStorage(), todo: TodoItem(title: "مثال", description: "وصف"), isPresented: .constant(true))
}
