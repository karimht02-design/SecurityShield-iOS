import SwiftUI

struct AddTodoView: View {
    @ObservedObject var storage: TodoStorage
    @Binding var isPresented: Bool
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedPriority: TodoItem.Priority = .medium
    @State private var dueDate: Date? = nil
    @State private var showDatePicker = false
    @State private var tags: [String] = []
    @State private var tagInput = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("المعلومات الأساسية")) {
                    TextField("عنوان المهمة", text: $title)
                    
                    TextField("وصف المهمة", text: $description, axis: .vertical)
                        .lineLimit(3...)
                }
                
                Section(header: Text("الأولوية والموعد")) {
                    Picker("الأولوية", selection: $selectedPriority) {
                        ForEach(TodoItem.Priority.allCases, id: \.self) { priority in
                            Text("\(priority.emoji) \(priority.rawValue)").tag(priority)
                        }
                    }
                    
                    if dueDate != nil {
                        DatePicker("تاريخ الاستحقاق", selection: Binding(get: { dueDate ?? Date() }, set: { dueDate = $0 }), displayedComponents: .date)
                    }
                    
                    Button(action: { showDatePicker.toggle() }) {
                        if let date = dueDate {
                            Text("التاريخ: \(formatDate(date))")
                        } else {
                            Text("+ إضافة تاريخ استحقاق")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                if showDatePicker && dueDate != nil {
                    Section {
                        DatePicker("اختر التاريخ", selection: Binding(get: { dueDate ?? Date() }, set: { dueDate = $0 }), displayedComponents: .date)
                    }
                }
                
                Section(header: Text("الوسوم")) {
                    HStack {
                        TextField("أضف وسم", text: $tagInput)
                        
                        Button(action: addTag) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
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
            }
            .navigationTitle("إضافة مهمة جديدة")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("إلغاء") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("حفظ") {
                        saveTodo()
                    }
                    .disabled(title.isEmpty)
                }
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
    
    func saveTodo() {
        let todo = TodoItem(
            title: title,
            description: description,
            priority: selectedPriority,
            dueDate: dueDate,
            tags: tags
        )
        storage.addTodo(todo)
        isPresented = false
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ar_SA")
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}

struct FlowLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? 300
        var height: CGFloat = 0
        var currentRowWidth: CGFloat = 0
        let spacing: CGFloat = 8
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if currentRowWidth + size.width + spacing > maxWidth {
                height += size.height + spacing
                currentRowWidth = size.width
            } else {
                currentRowWidth += size.width + spacing
            }
        }
        height += subviews.first?.sizeThatFits(.unspecified).height ?? 0
        
        return CGSize(width: maxWidth, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x: CGFloat = bounds.minX
        var y: CGFloat = bounds.minY
        let spacing: CGFloat = 8
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            
            if x + size.width > bounds.maxX {
                x = bounds.minX
                y += size.height + spacing
            }
            
            subview.place(at: CGPoint(x: x, y: y), anchor: .topLeading, proposal: .unspecified)
            x += size.width + spacing
        }
    }
}

#Preview {
    AddTodoView(storage: TodoStorage(), isPresented: .constant(true))
}
