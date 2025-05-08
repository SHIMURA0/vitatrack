
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

// 健康状态摘要卡片
struct HealthSummaryCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("健康状态")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    HStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                        
                        Text("整体良好")
                            .font(.subheadline)
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("查看详情")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .cornerRadius(20)
                }
            }
            
            // 关键指标预览
            HStack(spacing: 20) {
                KeyMetricView(title: "血压", value: "120/80", status: .normal)
                KeyMetricView(title: "心率", value: "72", status: .normal)
                KeyMetricView(title: "血糖", value: "5.6", status: .attention)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
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
        QuickAction(title: "更多", icon: "ellipsis.circle.fill", color: .gray)
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
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
                Button(action: {
                    // 更多选项的处理逻辑
                }) {
                    QuickActionButton(action: quickActions[4])
                }
            }
            .padding(.horizontal)
        }
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
