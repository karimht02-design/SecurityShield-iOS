import Foundation
import LocalAuthentication

class ThreatDetector {
    
    // كشف الجيلبريك
    static func isDeviceJailbroken() -> Bool {
        let jailbreakPaths = [
            "/Applications/Cydia.app",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/var/lib/cydia",
            "/bin/bash",
            "/usr/libexec/ssh-keysign",
            "/etc/ssh/sshd_config",
            "/var/cache/apt",
            "/var/lib/apt",
            "/private/var/lib/apt",
            "/usr/bin/sudo",
            "/usr/bin/ssh",
            "/private/etc/ssh/sshd_config"
        ]
        
        for path in jailbreakPaths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        
        // التحقق من القدرة على الكتابة في مسارات محمية
        if canWriteToRestrictedPath() {
            return true
        }
        
        return false
    }
    
    // التحقق من وجود كلمة مرور
    static func hasPasscode() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        let canEvaluateBiometrics = context.canEvaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            error: &error
        )
        
        let canEvaluatePasscode = context.canEvaluatePolicy(
            .deviceOwnerAuthentication,
            error: nil
        )
        
        return canEvaluateBiometrics || canEvaluatePasscode
    }
    
    // محاولة الكتابة في مسار محمي
    private static func canWriteToRestrictedPath() -> Bool {
        let testPath = "/private/test_write_\(UUID().uuidString)"
        
        do {
            try "test".write(toFile: testPath, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return true
        } catch {
            return false
        }
    }
    
    // حجب عنوان IP
    func blockIP(_ ipAddress: String) {
        print("⛔ تم حجب العنوان: \(ipAddress)")
        // يمكن تطبيق حجب فعلي عبر VPN أو جدار ناري
    }
    
    // فحص البرامج الضارة
    func scanForMalware() -> [Threat] {
        var detectedThreats: [Threat] = []
        
        // قائمة بأسماء تطبيقات معروفة بأنها ضارة (مثال)
        let knownMaliciousApps = [
            "com.malware.trojan",
            "com.spyware.monitor",
            "com.fake.security"
        ]
        
        // في تطبيق حقيقي، نحتاج إلى فحص التطبيقات المثبتة
        // هذا مثال توضيحي فقط
        
        return detectedThreats
    }
    
    // كشف محاولات الاختراق
    func detectUnauthorizedAccess() -> Bool {
        // التحقق من الأنشطة المريبة
        // في تطبيق حقيقي، يمكن فحص السجلات النظام
        return false
    }
    
    // الحصول على معلومات الجهاز
    static func getDeviceInfo() -> [String: String] {
        return [
            "Device": UIDevice.current.name,
            "Model": UIDevice.current.model,
            "System": UIDevice.current.systemName,
            "Version": UIDevice.current.systemVersion,
            "UUID": UIDevice.current.identifierForVendor?.uuidString ?? "Unknown"
        ]
    }
}
