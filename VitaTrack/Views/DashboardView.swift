import SwiftUI

struct DashboardView: View {
    @State private var selectedTimeRange: TimeRange = .week
    
    enum TimeRange {
        case day, week, month, year
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 健康状态卡片
                    HealthStatusCard()
                    
                    // 重要指标概览
                    VitalSignsOverview()
                    
                    // 用药提醒
                    MedicationReminderCard()
                    
                    // 最近检查报告
                    RecentReportsCard()
                    
                    // 就医提醒
                    MedicalAppointmentCard()
                }
                .padding()
            }
            .navigationTitle("健康概览")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // 添加新的健康记录
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct HealthStatusCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("健康状态")
                .font(.headline)
            
            HStack(spacing: 20) {
                HealthMetricView(title: "血压", value: "120/80", unit: "mmHg", icon: "heart.fill")
                HealthMetricView(title: "心率", value: "72", unit: "bpm", icon: "waveform.path.ecg")
                HealthMetricView(title: "血糖", value: "5.6", unit: "mmol/L", icon: "drop.fill")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct HealthMetricView: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.title2)
                .bold()
            
            Text(unit)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct VitalSignsOverview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("重要指标")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    VitalSignCard(title: "体温", value: "36.5", unit: "°C", trend: .stable)
                    VitalSignCard(title: "血氧", value: "98", unit: "%", trend: .up)
                    VitalSignCard(title: "体重", value: "65", unit: "kg", trend: .down)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct VitalSignCard: View {
    let title: String
    let value: String
    let unit: String
    let trend: Trend
    
    enum Trend {
        case up, down, stable
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(alignment: .firstTextBaseline) {
                Text(value)
                    .font(.title2)
                    .bold()
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: trendIcon)
                    .foregroundColor(trendColor)
                Text(trendText)
                    .font(.caption)
                    .foregroundColor(trendColor)
            }
        }
        .frame(width: 120)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
    
    var trendIcon: String {
        switch trend {
        case .up: return "arrow.up.right"
        case .down: return "arrow.down.right"
        case .stable: return "arrow.right"
        }
    }
    
    var trendText: String {
        switch trend {
        case .up: return "上升"
        case .down: return "下降"
        case .stable: return "稳定"
        }
    }
    
    var trendColor: Color {
        switch trend {
        case .up: return .red
        case .down: return .green
        case .stable: return .blue
        }
    }
}

struct MedicationReminderCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("用药提醒")
                .font(.headline)
            
            ForEach(1...2, id: \.self) { _ in
                HStack {
                    VStack(alignment: .leading) {
                        Text("降压药")
                            .font(.subheadline)
                        Text("每天 2 次")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("12:00")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct RecentReportsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("最近检查报告")
                .font(.headline)
            
            ForEach(1...2, id: \.self) { _ in
                HStack {
                    VStack(alignment: .leading) {
                        Text("血常规检查")
                            .font(.subheadline)
                        Text("2024-03-15")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct MedicalAppointmentCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("就医提醒")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("复诊预约")
                        .font(.subheadline)
                    Text("张医生 - 心内科")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("明天 14:30")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

#Preview {
    DashboardView()
} 