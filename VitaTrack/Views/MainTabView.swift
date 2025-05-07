import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("概览", systemImage: "house.fill")
                }
            
            MedicalRecordsView()
                .tabItem {
                    Label("病历", systemImage: "doc.text.fill")
                }
            
            ReportsView()
                .tabItem {
                    Label("报告", systemImage: "chart.bar.fill")
                }
            
            MonitoringView()
                .tabItem {
                    Label("监控", systemImage: "heart.fill")
                }
            
            MedicationView()
                .tabItem {
                    Label("用药", systemImage: "pills.fill")
                }
            
            MedicalAssistantView()
                .tabItem {
                    Label("就医", systemImage: "cross.fill")
                }
        }
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
} 