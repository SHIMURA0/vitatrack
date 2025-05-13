import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("概览", systemImage: "house.fill")
                }
            
            MedicationManagerView()
                .tabItem {
                    Label("用药", systemImage: "cross.case.fill")
                }
            
            ProfileArchiveView()
                .tabItem {
                    Label("档案", systemImage: "archivebox.fill")
                }
            
            MedicalCareView()
                .tabItem {
                    Label("就医", systemImage: "stethoscope")
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
