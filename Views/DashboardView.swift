import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var securityService: SecurityService
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // حالة الحماية العامة
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.cyan]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 250)
                        
                        VStack(spacing: 15) {
                            Text("حالة الحماية")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text("✅ آمن جداً")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            HStack(spacing: 20) {
                                VStack(spacing: 5) {
                                    Text("🛡️")
                                        .font(.title)
                                    Text("جدار ناري")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(spacing: 5) {
                                    Text("🔒")
                                        .font(.title)
                                    Text("مشفر")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                
                                VStack(spacing: 5) {
                                    Text("📊")
                                        .font(.title)
                                    Text("مراقب")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding()
                    }
                    .padding()
                    
                    // الإحصائيات
                    HStack(spacing: 15) {
                        StatCard(
                            icon: "🚨",
                            title: "تهديدات اليوم",
                            value: "\(securityService.stats.threatsDetectedToday)",
                            color: .red
                        )
                        StatCard(
                            icon: "✅",
                            title: "محمي بـ",
                            value: "5",
                            color: .green
                        )
                        StatCard(
                            icon: "🔄",
                            title: "آخر فحص",
                            value: getLastScanTime(),
                            color: .blue
                        )
                    }
                    .padding(.horizontal)
                    
                    // آخر التهديدات
                    VStack(alignment: .leading, spacing: 10) {
                        Text("آخر التهديدات المكتشفة")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if securityService.threats.isEmpty {
                            VStack {
                                Text("✅ لا توجد تهديدات")
                                    .foregroundColor(.gray)
                                Text("جهازك آمن تماماً")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        } else {
                            ForEach(securityService.threats.prefix(3)) { threat in
                                ThreatCardDashboard(threat: threat)
                            }
                        }
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding(.vertical)
            }
            .navigationTitle("🛡️ SecurityShield")
        }
    }
    
    private func getLastScanTime() -> String {
        if let lastScan = securityService.stats.lastScanTime {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .short
            
            if let timeAgo = formatter.string(from: lastScan, to: Date()) {
                return "منذ \(timeAgo)"
            }
        }
        return "الآن"
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Text(icon)
                .font(.title)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct ThreatCardDashboard: View {
    let threat: Threat
    @EnvironmentObject var securityService: SecurityService
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(threat.name)
                    .font(.headline)
                Text(threat.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(threat.detectionMethod)
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            VStack(spacing: 8) {
                Text(threat.severity.rawValue)
                    .font(.caption)
                
                HStack(spacing: 8) {
                    Button(action: { securityService.blockThreat(threat) }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                    
                    Button(action: { securityService.removeThreat(threat) }) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

#Preview {
    DashboardView()
        .environmentObject(SecurityService())
}
