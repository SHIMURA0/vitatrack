
import SwiftUI

struct DashboardView: View {
    @State private var userName: String = "张先生"
    @State private var showingProfile = false
    
    // 主要功能区域
    let mainFeatures = [
        Feature(title: "健康记录", icon: "heart.text.square.fill", color: .red, destination: "HealthRecordsView()"),
        Feature(title: "用药管理", icon: "pills.fill", color: .blue, destination: "MedicationView()"),
        Feature(title: "检查报告", icon: "doc.text.fill", color: .orange, destination: "MedicalReportsView()"),
        Feature(title: "预约就诊", icon: "calendar.badge.clock", color: .green, destination: "AppointmentsView()")
    ]
    
    // 健康服务
    let healthServices = [
        Feature(title: "在线问诊", icon: "message.fill", color: .purple, destination: "OnlineConsultationView()"),
        Feature(title: "健康评估", icon: "checklist", color: .teal, destination: "HealthAssessmentView()"),
        Feature(title: "健康知识", icon: "book.fill", color: .indigo, destination: "HealthKnowledgeView()"),
        Feature(title: "紧急联系", icon: "phone.fill", color: .red, destination: "EmergencyContactsView()")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 顶部问候语和状态卡片
                    VStack(spacing: 16) {
                        // 问候语和头像
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("您好，\(userName)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("今天感觉如何？")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Button(action: { showingProfile = true }) {
                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.accentColor)
                            }
                        }
                        
                        // 健康状态摘要卡片
                        HealthSummaryCard()
                    }
                    .padding(.horizontal)
                    
                    // 快速操作按钮
                    QuickActionsView()
                    
                    // 主要功能区域
                    SectionView(title: "健康管理", features: mainFeatures)
                    
                    // 今日提醒
                    TodayRemindersCard()
                        .padding(.horizontal)
                    
                    // 健康服务
                    SectionView(title: "健康服务", features: healthServices)
                    
                    // 健康文章推荐
                    HealthArticlesSection()
                        .padding(.horizontal)
                    
                    // 底部空间
                    Spacer(minLength: 40)
                }
                .padding(.top)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("健康中心")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {
                Text("个人资料")
            }
        }
    }
}

// 健康状态摘要卡片 - 现代化版本
struct HealthSummaryCard: View {
    @State private var selectedCardIndex: Int? = nil
    @State private var showingDetailView = false
    
    // 健康评分
    let healthScore = 87
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 顶部信息区
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("健康状态")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(healthScoreColor)
                            .frame(width: 10, height: 10)
                        
                        Text("整体良好")
                            .font(.subheadline)
                        
                        Image(systemName: "arrow.up")
                            .font(.caption2)
                            .foregroundColor(.green)
                        
                        Text("较上周")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // 健康评分
                ZStack {
                    Circle()
                        .trim(from: 0, to: CGFloat(healthScore)/100)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .green]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 40, height: 40)
                        .rotationEffect(.degrees(-90))
                    
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 4)
                        .frame(width: 40, height: 40)
                    
                    Text("\(healthScore)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                // 查看详情按钮
                Button(action: {
                    showingDetailView = true
                }) {
                    Text("查看详情")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .cornerRadius(20)
                }
            }
            
            // 指标卡片区域
            ZStack {
                // 背景卡片
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGroupedBackground))
                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 3)
                
                HStack(spacing: 0) {
                    // 血压卡片
                    metricCard(index: 0,
                               title: "血压",
                               value: "120/80",
                               unit: "mmHg",
                               statusLevel: .attention,
                               trendDirection: .up,
                               color: .red)
                    
                    Divider()
                        .padding(.vertical, 20)
                    
                    // 心率卡片
                    metricCard(index: 1,
                               title: "心率",
                               value: "72",
                               unit: "次/分",
                               statusLevel: .normal,
                               trendDirection: .stable,
                               color: .pink)
                    
                    Divider()
                        .padding(.vertical, 20)
                    
                    // 血糖卡片
                    metricCard(index: 2,
                               title: "血糖",
                               value: "5.6",
                               unit: "mmol/L",
                               statusLevel: .warning,
                               trendDirection: .up,
                               color: .orange)
                }
            }
            .frame(height: 130)
            
            // 如果选中了卡片，显示详细信息
            if let index = selectedCardIndex {
                metricDetailView(for: index)
                    .padding(.top, 8)
                    .transition(.opacity)
                    .animation(.easeInOut, value: selectedCardIndex)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        .sheet(isPresented: $showingDetailView) {
            HealthDetailView()
        }
    }
    
    // 指标卡片 - 整个区域可点击
    func metricCard(index: Int, title: String, value: String, unit: String,
                    statusLevel: StatusLevel,
                    trendDirection: TrendDirection,
                    color: Color) -> some View {
        ZStack {
            // 透明背景确保整个区域可点击
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle()) // 确保整个区域可点击
                .onTapGesture {
                    withAnimation {
                        if selectedCardIndex == index {
                            selectedCardIndex = nil
                        } else {
                            selectedCardIndex = index
                        }
                    }
                }
            
            // 卡片内容
            VStack(alignment: .leading, spacing: 6) {
                // 顶部 - 标题和状态
                HStack {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // 状态图标
                    statusIcon(for: statusLevel)
                }
                
                Spacer()
                
                // 值和单位
                VStack(alignment: .leading, spacing: 2) {
                    Text(value)
                        .font(.system(size: title == "血压" ? 22 : 28, weight: .bold, design: .rounded))
                    
                    Text(unit)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 底部 - 趋势
                HStack(spacing: 3) {
                    // 趋势条形图
                    ForEach(0..<5) { i in
                        RoundedRectangle(cornerRadius: 1)
                            .fill(color.opacity(0.3 + Double(i) * 0.14))
                            .frame(width: 3, height: CGFloat(5 + i * 2))
                    }
                    
                    Spacer()
                    
                    // 趋势指示器
                    trendIndicator(for: trendDirection, color: trendColor(for: trendDirection, type: index))
                }
                .frame(height: 14)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity)
    }
    
    // 状态图标
    func statusIcon(for status: StatusLevel) -> some View {
        ZStack {
            Circle()
                .fill(statusColor(for: status).opacity(0.15))
                .frame(width: 20, height: 20)
            
            Image(systemName: statusIconName(for: status))
                .font(.system(size: 10))
                .foregroundColor(statusColor(for: status))
        }
    }
    
    // 状态图标名称
    func statusIconName(for status: StatusLevel) -> String {
        switch status {
        case .normal: return "checkmark"
        case .attention: return "exclamationmark"
        case .warning: return "exclamationmark.triangle.fill"
        }
    }
    
    // 状态颜色
    func statusColor(for status: StatusLevel) -> Color {
        switch status {
        case .normal: return .green
        case .attention: return .orange
        case .warning: return .orange
        }
    }
    
    // 趋势指示器
    func trendIndicator(for trend: TrendDirection, color: Color) -> some View {
        HStack(spacing: 2) {
            Image(systemName: trendIconName(for: trend))
                .font(.system(size: 8))
                .foregroundColor(color)
            
            Text(trendPercentage(for: trend))
                .font(.system(size: 8))
                .foregroundColor(color)
        }
    }
    
    // 趋势图标名称
    func trendIconName(for trend: TrendDirection) -> String {
        switch trend {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .stable: return "arrow.forward"
        }
    }
    
    // 趋势百分比
    func trendPercentage(for trend: TrendDirection) -> String {
        switch trend {
        case .up: return "+2%"
        case .down: return "-3%"
        case .stable: return "0%"
        }
    }
    
    // 趋势颜色
    func trendColor(for trend: TrendDirection, type: Int) -> Color {
        switch type {
        case 0: // 血压
            return trend == .down ? .green : .orange
        case 1: // 心率
            return trend == .stable ? .green : (trend == .up ? .orange : .blue)
        case 2: // 血糖
            return trend == .down ? .green : .orange
        default:
            return .secondary
        }
    }
    
    // 指标详细视图
    func metricDetailView(for index: Int) -> some View {
        let (title, normalRange, description, recommendation) = detailInfo(for: index)
        
        return VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("\(title)详情")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    // 查看更多历史数据
                }) {
                    Text("查看历史")
                        .font(.caption)
                        .foregroundColor(.accentColor)
                }
            }
            
            // 图表占位符
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 110)
                .overlay(
                    Text("7日趋势图")
                        .foregroundColor(.secondary)
                )
            
            VStack(alignment: .leading, spacing: 10) {
                // 正常范围
                HStack(spacing: 6) {
                    Image(systemName: "ruler")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("正常范围: \(normalRange)")
                        .font(.subheadline)
                }
                
                // 说明
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 2)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // 建议
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .padding(.top, 2)
                    
                    Text(recommendation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
        )
    }
    
    // 详细信息
    func detailInfo(for index: Int) -> (String, String, String, String) {
        switch index {
        case 0:
            return (
                "血压",
                "90-120/60-80 mmHg",
                "收缩压120 mmHg，舒张压80 mmHg，处于正常偏高范围。您的血压在过去一周内有轻微波动，总体保持稳定。",
                "建议控制钠盐摄入，保持规律运动，避免熬夜和过度劳累，每天保持充足的睡眠时间。"
            )
        case 1:
            return (
                "心率",
                "60-100 次/分",
                "静息心率72次/分钟，处于理想范围内。过去一周您的平均心率稳定，显示心脏功能状态良好。",
                "继续保持适量有氧运动，避免剧烈情绪波动，规律作息有助于维持健康心率。"
            )
        case 2:
            return (
                "血糖",
                "3.9-5.5 mmol/L",
                "空腹血糖5.6 mmol/L，略高于正常参考值上限。建议密切关注，尤其是餐后血糖变化。",
                "建议控制精制碳水化合物摄入，增加膳食纤维，规律进餐，增加适度运动，定期监测血糖变化。"
            )
        default:
            return ("", "", "", "")
        }
    }
    
    // 健康评分颜色
    var healthScoreColor: Color {
        if healthScore >= 85 {
            return .green
        } else if healthScore >= 70 {
            return .yellow
        } else {
            return .orange
        }
    }
    
    // 状态级别枚举
    enum StatusLevel {
        case normal, attention, warning
    }
    
    // 趋势方向枚举
    enum TrendDirection {
        case up, down, stable
    }
}

// 健康详情视图
struct HealthDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 健康评分卡片
                    HealthScoreCard()
                    
                    // 各项指标详情
                    MetricDetailCard(
                        title: "血压",
                        value: "120/80",
                        unit: "mmHg",
                        status: .attention,
                        color: .red,
                        normalRange: "90-120/60-80",
                        description: "收缩压120 mmHg，舒张压80 mmHg，处于正常偏高范围。",
                        recommendation: "建议控制钠盐摄入，保持规律运动，避免熬夜和过度劳累。"
                    )
                    
                    MetricDetailCard(
                        title: "心率",
                        value: "72",
                        unit: "次/分",
                        status: .normal,
                        color: .pink,
                        normalRange: "60-100",
                        description: "静息心率72次/分钟，处于理想范围内。",
                        recommendation: "继续保持适量有氧运动，避免剧烈情绪波动，规律作息。"
                    )
                    
                    MetricDetailCard(
                        title: "血糖",
                        value: "5.6",
                        unit: "mmol/L",
                        status: .warning,
                        color: .orange,
                        normalRange: "3.9-5.5",
                        description: "空腹血糖5.6 mmol/L，略高于正常参考值上限。",
                        recommendation: "控制精制碳水化合物摄入，增加膳食纤维，规律进餐。"
                    )
                }
                .padding()
            }
            .navigationTitle("健康详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// 健康评分卡片
struct HealthScoreCard: View {
    let healthScore = 87
    
    var body: some View {
        VStack(spacing: 16) {
            Text("健康评分")
                .font(.headline)
                .fontWeight(.bold)
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.1), lineWidth: 16)
                    .frame(width: 160, height: 160)
                
                Circle()
                    .trim(from: 0, to: CGFloat(healthScore) / 100)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .green]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                
                VStack(spacing: 4) {
                    Text("\(healthScore)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                    
                    Text("良好")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack(spacing: 24) {
                StatItem(title: "上周", value: "82", change: "+5")
                StatItem(title: "上月", value: "79", change: "+8")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// 统计项
struct StatItem: View {
    let title: String
    let value: String
    let change: String
    
    var body: some View {
        VStack(spacing: 4) {
                Text(title)
                .font(.caption)
                    .foregroundColor(.secondary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(change)
                .font(.caption)
                .foregroundColor(.green)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
    }
}

// 指标详情卡片
struct MetricDetailCard: View {
    let title: String
    let value: String
    let unit: String
    let status: HealthSummaryCard.StatusLevel
    let color: Color
    let normalRange: String
    let description: String
    let recommendation: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 18))
                        .foregroundColor(color)
                }
                
                Text(title)
                .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            // 占位图表区域
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.gray.opacity(0.1))
                .frame(height: 120)
                .overlay(
                    Text("7日趋势图")
                        .foregroundColor(.secondary)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("单位")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(unit)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("正常范围")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(normalRange)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 6)
                
                HStack(alignment: .top) {
                    Image(systemName: "lightbulb.fill")
                        .font(.caption)
                        .foregroundColor(.yellow)
                        .padding(.top, 2)
                    
                    Text(recommendation)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(8)
                .background(Color.yellow.opacity(0.1))
                .cornerRadius(6)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
    
    // 指标图标
    var iconName: String {
        switch title {
        case "血压": return "waveform.path.ecg.rectangle"
        case "心率": return "heart.fill"
        case "血糖": return "drop.fill"
        default: return "heart.text.square.fill"
        }
    }
}

// 关键指标组件
struct KeyMetricView: View {
    let title: String
    let value: String
    let status: MetricStatus
    
    enum MetricStatus {
        case normal, attention, warning
    }
    
    var statusColor: Color {
        switch status {
        case .normal: return .green
        case .attention: return .orange
        case .warning: return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
                Text(value)
                .font(.headline)
                .fontWeight(.bold)
            
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
        }
        .frame(maxWidth: .infinity)
    }
}

//// 快速操作视图
//struct QuickActionsView: View {
//    let quickActions = [
//        QuickAction(title: "记录", icon: "plus.circle.fill", color: .blue),
//        QuickAction(title: "扫描", icon: "qrcode", color: .purple),
//        QuickAction(title: "设备", icon: "applewatch", color: .green),
//        QuickAction(title: "提醒", icon: "alarm.fill", color: .orange),
//        QuickAction(title: "更多", icon: "ellipsis.circle.fill", color: .gray)
//    ]
//    
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 20) {
//                ForEach(quickActions, id: \.title) { action in
//                    VStack(spacing: 8) {
//                        ZStack {
//                            Circle()
//                                .fill(action.color.opacity(0.1))
//                                .frame(width: 60, height: 60)
//                            
//                            Image(systemName: action.icon)
//                                .font(.system(size: 24))
//                                .foregroundColor(action.color)
//                        }
//                        
//                        Text(action.title)
//                            .font(.caption)
//                            .foregroundColor(.primary)
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
//        .padding(.vertical, 10)
//    }
//}

// 快速操作视图
struct QuickActionsView: View {
    // 添加这些状态变量来控制不同页面的显示
    @State private var showingHealthRecording = false
    @State private var showingMedicalScanner = false
    @State private var showingDeviceManagement = false
    @State private var showingReminders = false
    
    let quickActions = [
        QuickAction(title: "记录", icon: "plus.circle.fill", color: .blue),
        QuickAction(title: "扫描", icon: "qrcode", color: .purple),
        QuickAction(title: "设备", icon: "applewatch", color: .green),
        QuickAction(title: "提醒", icon: "alarm.fill", color: .orange),
//        QuickAction(title: "更多", icon: "ellipsis.circle.fill", color: .gray)
    ]
    
    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 35) {
                // 修改为单独处理每个按钮，以便添加不同的动作
                
                // 记录按钮
                Button(action: {
                    showingHealthRecording = true
                }) {
                    QuickActionButton(action: quickActions[0])
                }
                
                // 扫描按钮
                Button(action: {
                    showingMedicalScanner = true
                }) {
                    QuickActionButton(action: quickActions[1])
                }
                
                // 设备按钮
                Button(action: {
                    showingDeviceManagement = true
                }) {
                    QuickActionButton(action: quickActions[2])
                }
                
                // 提醒按钮
                Button(action: {
                    showingReminders = true
                }) {
                    QuickActionButton(action: quickActions[3])
                }
                
                // 更多按钮
//                Button(action: {
//                    // 更多选项的处理逻辑
//                }) {
//                    QuickActionButton(action: quickActions[4])
//                }
            }
            .padding(.horizontal)
//        }
        .padding(.vertical, 10)
        .sheet(isPresented: $showingHealthRecording) {
            HealthRecordingView()
        }
        .sheet(isPresented: $showingMedicalScanner) {
            MedicalScannerView()
        }
        .sheet(isPresented: $showingDeviceManagement) {
            DeviceManagementView()
        }
        .sheet(isPresented: $showingReminders) {
            RemindersView()
        }
        // 同样也可以为其他功能添加相应的 sheet
    }
}

// 提取出通用的按钮视图组件
struct QuickActionButton: View {
    let action: QuickAction
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(action.color.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                Image(systemName: action.icon)
                    .font(.system(size: 24))
                    .foregroundColor(action.color)
            }
            
            Text(action.title)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

// 功能部分视图
struct SectionView: View {
    let title: String
    let features: [Feature]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(features, id: \.title) { feature in
                    FeatureCard(feature: feature)
                }
            }
            .padding(.horizontal)
        }
    }
}

// 功能卡片
struct FeatureCard: View {
    let feature: Feature
    
    var body: some View {
        NavigationLink(destination: Text(feature.destination)) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(feature.color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: feature.icon)
                        .font(.system(size: 22))
                        .foregroundColor(feature.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(feature.title)
                .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("查看详情")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
        }
    }
}

// 今日提醒卡片
struct TodayRemindersCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("今日提醒")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {}) {
                    Text("全部")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }
            
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.red.opacity(0.1))
                        .frame(width: 45, height: 45)
                    
                    Image(systemName: "pills.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("降压药")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("12:00 | 每天两次")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                Button(action: {}) {
                    Text("完成")
                        .font(.caption)
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.accentColor.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            
            // 就医提醒
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.1))
                        .frame(width: 45, height: 45)
                    
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 20))
                        .foregroundColor(.green)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("心内科复诊")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("14:30 | 市第一医院")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("今天")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
    }
}

// 健康文章部分
struct HealthArticlesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("健康资讯")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {}) {
                    Text("更多")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(1...3, id: \.self) { _ in
                        ArticleCard()
                    }
                }
            }
        }
    }
}

// 文章卡片
struct ArticleCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    Image(systemName: "heart.text.square.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.accentColor)
                )
                .frame(height: 120)
            
            Text("高血压患者的饮食管理")
                .font(.headline)
                .lineLimit(2)
            
            HStack {
                Text("健康专栏")
                        .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.accentColor)
                    .cornerRadius(6)
                
                Spacer()
                
                Text("5分钟")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(width: 260)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
    }
}

// 数据模型
struct Feature {
    let title: String
    let icon: String
    let color: Color
    let destination: String
}

struct QuickAction {
    let title: String
    let icon: String
    let color: Color
}

#Preview {
    DashboardView()
} 
