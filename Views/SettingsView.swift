import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var securityService: SecurityService
    @State private var notificationsEnabled = true
    @State private var autoScanEnabled = true
    @State private var backupEnabled = true
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("الأمان")) {
                    Toggle("تفعيل الإخطارات", isOn: $notificationsEnabled)
                    Toggle("الفحص التلقائي", isOn: $autoScanEnabled)
                    Toggle("النسخ الاحتياطي", isOn: $backupEnabled)
                }
                
                Section(header: Text("معلومات الجهاز")) {
                    InfoField(
                        label: "جهاز مجيلبرك",
                        value: securityService.deviceStatus.isJailbroken ? "⚠️ نعم" : "✅ لا",
                        color: securityService.deviceStatus.isJailbroken ? .red : .green
                    )
                    InfoField(
                        label: "كلمة المرور",
                        value: securityService.deviceStatus.hasPasscode ? "✅ موجودة" : "⚠️ غير موجودة",
                        color: securityService.deviceStatus.hasPasscode ? .green : .orange
                    )
                    InfoField(
                        label: "البصمة/الوجه",
                        value: securityService.deviceStatus.biometricEnabled ? "✅ مفعلة" : "⚠️ معطلة",
                        color: securityService.deviceStatus.biometricEnabled ? .green : .orange
                    )
                    InfoField(
                        label: "التشفير",
                        value: securityService.deviceStatus.encryptionEnabled ? "✅ مفعل" : "⚠️ معطل",
                        color: securityService.deviceStatus.encryptionEnabled ? .green : .orange
                    )
                    InfoField(
                        label: "الجدار الناري",
                        value: securityService.deviceStatus.firewallActive ? "✅ نشط" : "⚠️ معطل",
                        color: securityService.deviceStatus.firewallActive ? .green : .orange
                    )
                }
                
                Section(header: Text("الإحصائيات")) {
                    HStack {
                        Text("التهديدات المكتشفة")
                        Spacer()
                        Text("\(securityService.stats.threatsDetectedToday)")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                    }
                    
                    HStack {
                        Text("التهديدات المحجوبة")
                        Spacer()
                        Text("\(securityService.stats.threatsBlockedToday)")
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    
                    HStack {
                        Text("التطبيقات المحمية")
                        Spacer()
                        Text("\(securityService.stats.protectedApps)")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("آخر فحص")
                        Spacer()
                        if let lastScan = securityService.stats.lastScanTime {
                            Text(formatTime(lastScan))
                                .foregroundColor(.gray)
                        } else {
                            Text("لم يتم الفحص بعد")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section(header: Text("الإجراءات")) {
                    Button(action: {
                        securityService.performFullScan()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("فحص الآن")
                        }
                        .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        showAlert = true
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("حذف جميع التهديدات")
                        }
                        .foregroundColor(.red)
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("حول التطبيق")
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("الإصدار: 1.0.0")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("© 2024 SecurityShield")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                }
            }
            .navigationTitle("⚙️ الإعدادات")
            .alert("تأكيد", isPresented: $showAlert) {
                Button("حذف", role: .destructive) {
                    securityService.clearAllThreats()
                }
                Button("إلغاء", role: .cancel) {}
            } message: {
                Text("هل أنت متأكد من حذف جميع التهديدات؟")
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ar_SA")
        return formatter.string(from: date)
    }
}

struct InfoField: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SecurityService())
}
