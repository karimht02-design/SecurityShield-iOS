import Foundation
import Combine

class SecurityService: ObservableObject {
    @Published var threats: [Threat] = []
    @Published var deviceStatus: DeviceSecurityStatus = DeviceSecurityStatus(
        isJailbroken: false,
        hasPasscode: true,
        biometricEnabled: true,
        encryptionEnabled: true,
        vpnActive: false,
        firewallActive: true,
        lastUpdateCheck: Date()
    )
    @Published var vpnActive = false
    @Published var threatsDetectedToday = 0
    @Published var stats: SecurityStats = SecurityStats(
        threatsDetectedToday: 0,
        threatsBlockedToday: 0,
        protectedApps: 0,
        lastScanTime: nil
    )
    
    private var threatDetector: ThreatDetector
    private var networkMonitor: NetworkMonitor
    
    init() {
        self.threatDetector = ThreatDetector()
        self.networkMonitor = NetworkMonitor()
        setupMonitoring()
    }
    
    func setupMonitoring() {
        print("🔍 بدء مراقبة الأمان...")
        networkMonitor.startMonitoring()
        checkDeviceSecurity()
    }
    
    func checkDeviceSecurity() {
        deviceStatus.isJailbroken = ThreatDetector.isDeviceJailbroken()
        deviceStatus.hasPasscode = ThreatDetector.hasPasscode()
        
        if deviceStatus.isJailbroken {
            addThreat(
                name: "⚠️ تحذير جيلبريك",
                severity: .critical,
                description: "تم اكتشاف أن الجهاز مجيلبرك - قد تكون البيانات في خطر",
                sourceIP: nil,
                method: "Jailbreak Detection"
            )
        }
        
        if !deviceStatus.hasPasscode {
            addThreat(
                name: "⚠️ لا توجد كلمة مرور",
                severity: .high,
                description: "الجهاز غير محمي بكلمة مرور - يرجى تعيين كلمة مرور قوية",
                sourceIP: nil,
                method: "Passcode Check"
            )
        }
    }
    
    func addThreat(name: String, severity: Threat.ThreatLevel, description: String, sourceIP: String?, method: String) {
        let threat = Threat(
            name: name,
            severity: severity,
            description: description,
            sourceIP: sourceIP,
            detectionMethod: method
        )
        threats.append(threat)
        threatsDetectedToday += 1
        stats.threatsDetectedToday += 1
        
        sendNotification(title: name, body: description)
        print("🚨 تهديد جديد: \(name)")
    }
    
    func blockThreat(_ threat: Threat) {
        threatDetector.blockIP(threat.sourceIP ?? "")
        threats.removeAll { $0.id == threat.id }
        stats.threatsBlockedToday += 1
        
        sendNotification(title: "🛡️ تم حجب التهديد", body: threat.name)
        print("✅ تم حجب التهديد: \(threat.name)")
    }
    
    func removeThreat(_ threat: Threat) {
        threats.removeAll { $0.id == threat.id }
        print("✅ تم إزالة التهديد: \(threat.name)")
    }
    
    func toggleVPN() {
        vpnActive.toggle()
        deviceStatus.vpnActive = vpnActive
        
        if vpnActive {
            sendNotification(title: "🔒 VPN متصل", body: "موقعك الآن محمي")
            print("✅ تم تفعيل VPN")
        } else {
            print("❌ تم تعطيل VPN")
        }
    }
    
    func performFullScan() {
        stats.lastScanTime = Date()
        
        // محاكاة الفحص
        if Bool.random() {
            addThreat(
                name: "محاولة اتصال مريبة",
                severity: .medium,
                description: "تم اكتشاف محاولة اتصال من عنوان IP غريب",
                sourceIP: "192.168.\(Int.random(in: 0...255)).\(Int.random(in: 0...255))",
                method: "Network Monitoring"
            )
        }
        
        if Bool.random() {
            addThreat(
                name: "تطبيق مريب",
                severity: .high,
                description: "تم اكتشاف تطبيق قد يكون ضاراً",
                sourceIP: nil,
                method: "App Analysis"
            )
        }
    }
    
    private func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("خطأ في الإشعار: \(error)")
            }
        }
    }
    
    func clearAllThreats() {
        threats.removeAll()
        print("✅ تم حذف جميع التهديدات")
    }
}
