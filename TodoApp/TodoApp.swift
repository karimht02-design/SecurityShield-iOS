import SwiftUI

@main
struct TodoApp: App {
    @StateObject private var storage = TodoStorage()
    @State private var selectedTab = 0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                // قائمة المهام
                TodoListView()
                    .tabItem {
                        Label("المهام", systemImage: "checklist")
                    }
                    .tag(0)
                
                // الإحصائيات
                StatsView()
                    .tabItem {
                        Label("الإحصائيات", systemImage: "chart.bar")
                    }
                    .tag(1)
                
                // الإعدادات
                TodoSettingsView()
                    .tabItem {
                        Label("الإعدادات", systemImage: "gear")
                    }
                    .tag(2)
            }
            .environmentObject(storage)
        }
    }
}
