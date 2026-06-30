import Foundation

struct Threat: Identifiable, Codable {
    let id: UUID
    let name: String
    let severity: ThreatLevel
    let description: String
    let timestamp: Date
    let sourceIP: String?
    let detectionMethod: String
    
    enum ThreatLevel: String, Codable {
        case critical = "🔴 حرج"
        case high = "🟠 عالي"
        case medium = "🟡 متوسط"
        case low = "🟢 منخفض"
    }
    
    init(id: UUID = UUID(), name: String, severity: ThreatLevel, description: String, timestamp: Date = Date(), sourceIP: String?, detectionMethod: String) {
        self.id = id
        self.name = name
        self.severity = severity
        self.description = description
        self.timestamp = timestamp
        self.sourceIP = sourceIP
        self.detectionMethod = detectionMethod
    }
}

struct DeviceSecurityStatus: Codable {
    var isJailbroken: Bool
    var hasPasscode: Bool
    var biometricEnabled: Bool
    var encryptionEnabled: Bool
    var vpnActive: Bool
    var firewallActive: Bool
    var lastUpdateCheck: Date
}

struct SecurityStats: Codable {
    var threatsDetectedToday: Int
    var threatsBlockedToday: Int
    var protectedApps: Int
    var lastScanTime: Date?
}
