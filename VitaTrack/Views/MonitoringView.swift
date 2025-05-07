import SwiftUI
import Charts

struct MonitoringView: View {
    @State private var selectedTimeRange: TimeRange = .week
    @State private var selectedMetric: HealthMetric = .bloodPressure
    
    enum TimeRange: String, CaseIterable {
        case day = "日"
        case week = "周"
        case month = "月"
        case year = "年"
    }
    
    enum HealthMetric: String, CaseIterable {
        case bloodPressure = "血压"
        case heartRate = "心率"
        case bloodSugar = "血糖"
        case weight = "体重"
        case temperature = "体温"
        case bloodOxygen = "血氧"
        
        var unit: String {
            switch self {
            case .bloodPressure: return "mmHg"
            case .heartRate: return "bpm"
            case .bloodSugar: return "mmol/L"
            case .weight: return "kg"
            case .temperature: return "°C"
            case .bloodOxygen: return "%"
            }
        }
        
        var icon: String {
            switch self {
            case .bloodPressure: return "heart.fill"
            case .heartRate: return "waveform.path.ecg"
            case .bloodSugar: return "drop.fill"
            case .weight: return "scalemass.fill"
            case .temperature: return "thermometer"
            case .bloodOxygen: return "lungs.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .bloodPressure: return .red
            case .heartRate: return .orange
            case .bloodSugar: return .blue
            case .weight: return .green
            case .temperature: return .purple
            case .bloodOxygen: return .mint
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 时间范围选择器
                    Picker("时间范围", selection: $selectedTimeRange) {
                        ForEach(TimeRange.allCases, id: \.self) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // 指标选择器
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(HealthMetric.allCases, id: \.self) { metric in
                                MetricButton(
                                    metric: metric,
                                    isSelected: selectedMetric == metric
                                ) {
                                    selectedMetric = metric
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // 图表
                    ChartCard(metric: selectedMetric)
                    
                    // 当前值卡片
                    CurrentValueCard(metric: selectedMetric)
                    
                    // 历史记录
                    HistoryList(metric: selectedMetric)
                }
                .padding(.vertical)
            }
            .navigationTitle("指标监控")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // 添加新的记录
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

struct MetricButton: View {
    let metric: MonitoringView.HealthMetric
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: metric.icon)
                    .font(.title2)
                Text(metric.rawValue)
                    .font(.caption)
            }
            .frame(width: 80, height: 80)
            .background(isSelected ? metric.color.opacity(0.2) : Color(.systemGray6))
            .foregroundColor(isSelected ? metric.color : .primary)
            .cornerRadius(15)
        }
    }
}

struct ChartCard: View {
    let metric: MonitoringView.HealthMetric
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("趋势图")
                .font(.headline)
            
            // 这里使用 Charts 框架绘制图表
            // 示例数据
            let data = [
                (date: Date().addingTimeInterval(-6*24*3600), value: 120.0),
                (date: Date().addingTimeInterval(-5*24*3600), value: 118.0),
                (date: Date().addingTimeInterval(-4*24*3600), value: 122.0),
                (date: Date().addingTimeInterval(-3*24*3600), value: 119.0),
                (date: Date().addingTimeInterval(-2*24*3600), value: 121.0),
                (date: Date().addingTimeInterval(-1*24*3600), value: 120.0),
                (date: Date(), value: 118.0)
            ]
            
            Chart {
                ForEach(data, id: \.date) { item in
                    LineMark(
                        x: .value("日期", item.date),
                        y: .value("数值", item.value)
                    )
                    .foregroundStyle(metric.color)
                }
            }
            .frame(height: 200)
            .chartYScale(domain: 100...140)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct CurrentValueCard: View {
    let metric: MonitoringView.HealthMetric
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("当前值")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(metric.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("120")
                            .font(.system(size: 36, weight: .bold))
                        Text(metric.unit)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("正常范围")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("90-140")
                        .font(.headline)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct HistoryList: View {
    let metric: MonitoringView.HealthMetric
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("历史记录")
                .font(.headline)
            
            ForEach(1...5, id: \.self) { _ in
                HStack {
                    VStack(alignment: .leading) {
                        Text("2024-03-15 08:30")
                            .font(.subheadline)
                        Text("测量")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text("120 \(metric.unit)")
                        .font(.headline)
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

#Preview {
    MonitoringView()
} 