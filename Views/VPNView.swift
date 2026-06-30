import SwiftUI

struct VPNView: View {
    @EnvironmentObject var securityService: SecurityService
    @State private var selectedCountry = "دولة الإمارات"
    @State private var connectionSpeed = "95 Mbps"
    
    let countries = [
        "🇦🇪 دولة الإمارات",
        "🇸🇦 السعودية",
        "🇪🇬 مصر",
        "🇯🇴 الأردن",
        "🇶🇦 قطر",
        "🇰🇼 الكويت",
        "🇬🇧 بريطانيا",
        "🇺🇸 أمريكا",
        "🇩🇪 ألمانيا",
        "🇫🇷 فرنسا"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // حالة VPN
                ZStack {
                    Circle()
                        .fill(
                            securityService.vpnActive ?
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green, Color.mint]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray, Color.gray]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 200)
                    
                    VStack(spacing: 15) {
                        Text(securityService.vpnActive ? "🔒 متصل" : "🔓 غير متصل")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(securityService.vpnActive ? "موقعك محمي" : "الاتصال غير آمن")
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                }
                .padding()
                
                // اختيار الدولة
                VStack(alignment: .leading, spacing: 10) {
                    Text("اختر الموقع")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Picker("الموقع", selection: $selectedCountry) {
                        ForEach(countries, id: \.self) { country in
                            Text(country).tag(country)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                // معلومات الاتصال
                VStack(spacing: 10) {
                    InfoRow(label: "🌍 الموقع", value: selectedCountry)
                    Divider()
                    InfoRow(label: "📡 السرعة", value: connectionSpeed)
                    Divider()
                    InfoRow(label: "🔐 التشفير", value: "AES-256")
                    Divider()
                    InfoRow(label: "🛡️ البروتوكول", value: "OpenVPN")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                
                // زر التفعيل
                Button(action: toggleVPN) {
                    Text(securityService.vpnActive ? "قطع الاتصال" : "الاتصال الآن")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(securityService.vpnActive ? Color.red : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                // معلومات إضافية
                if securityService.vpnActive {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("الاتصال آمن", systemImage: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Label("جميع البيانات مشفرة", systemImage: "lock.fill")
                            .foregroundColor(.blue)
                        Label("عنوان IP مخفي", systemImage: "eye.slash.fill")
                            .foregroundColor(.purple)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                }
                
                Spacer()
            }
            .navigationTitle("🔒 VPN الحماية")
        }
    }
    
    private func toggleVPN() {
        withAnimation {
            securityService.toggleVPN()
            
            // محاكاة تغيير السرعة
            if securityService.vpnActive {
                connectionSpeed = "\(Int.random(in: 50...100)) Mbps"
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

#Preview {
    VPNView()
        .environmentObject(SecurityService())
}
