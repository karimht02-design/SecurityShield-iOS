import Foundation
import Network

class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.handlePathChange(path)
        }
        
        monitor.start(queue: queue)
    }
    
    private func handlePathChange(_ path: NWPath) {
        switch path.status {
        case .satisfied:
            print("✅ الشبكة: متصلة")
            if path.usesInterfaceType(.wifi) {
                print("📡 نوع الاتصال: WiFi")
            } else if path.usesInterfaceType(.cellular) {
                print("📱 نوع الاتصال: Cellular")
            } else if path.usesInterfaceType(.wiredEthernet) {
                print("🔌 نوع الاتصال: Ethernet")
            }
            
        case .unsatisfied:
            print("❌ الشبكة: غير متصلة")
            
        case .requiresConnection:
            print("⏳ الشبكة: تتطلب اتصال")
            
        @unknown default:
            print("⚠️ حالة شبكة غير معروفة")
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
