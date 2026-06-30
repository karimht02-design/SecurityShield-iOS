import SwiftUI

struct ThreatDetectionView: View {
    @EnvironmentObject var securityService: SecurityService
    @State private var isScanning = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // زر الفحص
                Button(action: startScan) {
                    HStack {
                        Image(systemName: isScanning ? "checkmark.circle" : "magnifyingglass")
                        Text(isScanning ? "جاري الفحص..." : "فحص الجهاز الآن")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isScanning ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .disabled(isScanning)
                .padding()
                
                if isScanning {
                    VStack(spacing: 15) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("جاري فحص الجهاز...")
                            .font(.headline)
                        Text("يرجى الانتظار")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    if securityService.threats.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "checkmark.shield.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                            Text("جهازك آمن!")
                                .font(.headline)
                            Text("لم يتم اكتشاف أي تهديدات")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    } else {
                        List {
                            ForEach(securityService.threats.sorted { $0.timestamp > $1.timestamp }) { threat in
                                ThreatRowView(threat: threat)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            securityService.blockThreat(threat)
                                        } label: {
                                            Label("حجب", systemImage: "xmark.circle")
                                        }
                                    }
                            }
                        }
                        .listStyle(.plain)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("🔍 كشف التهديدات")
        }
    }
    
    func startScan() {
        isScanning = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            securityService.performFullScan()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isScanning = false
            }
        }
    }
}

struct ThreatRowView: View {
    let threat: Threat
    @EnvironmentObject var securityService: SecurityService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(threat.name)
                    .font(.headline)
                Spacer()
                Text(threat.severity.rawValue)
                    .font(.caption2)
            }
            
            Text(threat.description)
                .font(.caption)
                .foregroundColor(.gray)
            
            HStack(spacing: 15) {
                Text(threat.detectionMethod)
                    .font(.caption2)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text(formatTime(threat.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            if let ip = threat.sourceIP {
                HStack {
                    Text("IP:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(ip)
                        .font(.caption2)
                        .monospaced()
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .short
        
        if let timeAgo = formatter.string(from: date, to: Date()) {
            return "منذ \(timeAgo)"
        }
        return "الآن"
    }
}

#Preview {
    ThreatDetectionView()
        .environmentObject(SecurityService())
}
