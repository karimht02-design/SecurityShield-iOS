import SwiftUI

struct TodoSettingsView: View {
    @EnvironmentObject var storage: TodoStorage
    @State private var showingExportSheet = false
    @State private var showingImportSheet = false
    @State private var showingClearAlert = false
    @State private var exportedText = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("البيانات")) {
                    Button(action: { exportTodos() }) {
                        Label("📤 تصدير المهام", systemImage: "square.and.arrow.up")
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: { showingImportSheet = true }) {
                        Label("📥 استيراد المهام", systemImage: "square.and.arrow.down")
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: { showingClearAlert = true }) {
                        Label("🗑️ حذف جميع المهام", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
                
                Section(header: Text("الفئات")) {
                    ForEach(storage.categories) { category in
                        HStack {
                            Text(category.icon)
                                .font(.title3)
                            Text(category.name)
                            Spacer()
                            Text("\(storage.todos.count)")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section(header: Text("الإحصائيات")) {
                    HStack {
                        Text("إجمالي المهام")
                        Spacer()
                        Text("\(storage.todos.count)")
                            .fontWeight(.bold)
                    }
                    
                    HStack {
                        Text("المهام المكتملة")
                        Spacer()
                        Text("\(storage.getCompletedCount())")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("المهام قيد الانتظار")
                        Spacer()
                        Text("\(storage.getPendingCount())")
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                }
                
                Section(header: Text("عن التطبيق")) {
                    HStack {
                        Text("الإصدار")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.gray)
                    }
                    
                    Text("تطبيق TodoList - قائمة مهام ذكية مع تخزين محلي")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("⚙️ الإعدادات")
            .navigationBarTitleDisplayMode(.inline)
            .alert("حذف جميع المهام", isPresented: $showingClearAlert) {
                Button("حذف", role: .destructive) {
                    storage.todos.removeAll()
                }
                Button("إلغاء", role: .cancel) {}
            } message: {
                Text("هل أنت متأكد من حذف جميع المهام؟")
            }
            .sheet(isPresented: $showingExportSheet) {
                ShareSheet(items: [exportedText])
            }
        }
    }
    
    func exportTodos() {
        if let json = storage.exportTodos() {
            exportedText = json
            showingExportSheet = true
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    TodoSettingsView()
        .environmentObject(TodoStorage())
}
