import SwiftUI

struct KingDisease: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let timeline: [DiseaseTimelineNode]
}

struct DiseaseTimelineNode: Identifiable {
    let id = UUID()
    let date: String
    let title: String
    let description: String
    let doctor: String
    let hospital: String
    let report: String?
}

struct ProfileArchiveView: View {
    @State private var selectedTab: Int = 0
    @State private var showingAddRecord = false
    @State private var showingDisease: KingDisease? = nil
    @State private var showingTimelineNode: DiseaseTimelineNode? = nil
    @State private var searchText = ""
    
    // 示例数据
    let diseases: [KingDisease] = [
        KingDisease(
            name: "高血压",
            icon: "heart.fill",
            color: .red,
            timeline: [
                DiseaseTimelineNode(date: "2020-01-10", title: "首次诊断", description: "血压升高，头痛、心悸，确诊高血压。", doctor: "李医生", hospital: "王国医院", report: "血压 150/95mmHg"),
                DiseaseTimelineNode(date: "2021-03-05", title: "加重", description: "血压控制不佳，出现胸闷。", doctor: "王医生", hospital: "王国医院", report: "血压 160/100mmHg"),
                DiseaseTimelineNode(date: "2022-06-15", title: "好转", description: "调整用药后血压平稳。", doctor: "李医生", hospital: "王国医院", report: "血压 130/85mmHg")
            ]
        ),
        KingDisease(
            name: "糖尿病",
            icon: "drop.fill",
            color: .orange,
            timeline: [
                DiseaseTimelineNode(date: "2018-05-20", title: "首次诊断", description: "空腹血糖升高，确诊2型糖尿病。", doctor: "赵医生", hospital: "王国医院", report: "空腹血糖 7.2mmol/L"),
                DiseaseTimelineNode(date: "2020-08-10", title: "并发症", description: "出现轻度视网膜病变。", doctor: "赵医生", hospital: "王国医院", report: "眼底检查异常")
            ]
        )
    ]
    
    // 统计信息
    let medicalStats = MedicalStatistics(
        diseaseCategories: [
            ArchiveStatItem(name: "慢性病", value: 3, color: .red),
            ArchiveStatItem(name: "急性病", value: 2, color: .orange),
            ArchiveStatItem(name: "传染病", value: 0, color: .green),
            ArchiveStatItem(name: "其他", value: 1, color: .blue)
        ],
        visitFrequency: [
            ArchiveStatItem(name: "2022年", value: 8, color: .blue),
            ArchiveStatItem(name: "2023年", value: 5, color: .green),
            ArchiveStatItem(name: "2024年", value: 3, color: .orange)
        ],
        topHospitals: [
            ArchiveStatItem(name: "王国中心医院", value: 10, color: .purple),
            ArchiveStatItem(name: "皇家专科医院", value: 5, color: .blue),
            ArchiveStatItem(name: "城堡医疗中心", value: 3, color: .teal)
        ],
        topMedications: [
            ArchiveStatItem(name: "降压药", value: 365, color: .red, unit: "天"),
            ArchiveStatItem(name: "降糖药", value: 300, color: .orange, unit: "天"),
            ArchiveStatItem(name: "抗生素", value: 21, color: .green, unit: "天")
        ]
    )
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 28) {
                    ProfileCard()
                    HealthStatisticsPanel(stats: medicalStats)
                    DiseaseHistorySection(diseases: diseases, showingDisease: $showingDisease)
                    ArchiveSearchSection(searchText: $searchText)
                    MedicalVisitSection()
                    HospitalizationSection()
                    MedicationSection()
                    ReportSection()
                    HealthTrendsSection()
                    HealthAchievementsSection()
                    HealthCalendarSection()
                    HealthDiarySection()
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("国王档案")
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Button(action: { showingAddRecord = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.accentColor)
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddRecord) {
                Text("添加新档案记录")
            }
            .sheet(item: $showingDisease) { disease in
                DiseaseTimelineView(disease: disease, showingNode: $showingTimelineNode)
            }
            .sheet(item: $showingTimelineNode) { node in
                DiseaseTimelineNodeDetailView(node: node)
            }
        }
    }
}

// 个人信息卡片
struct ProfileCard: View {
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: "crown.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.yellow)
                .background(Circle().fill(Color.yellow.opacity(0.15)))
            VStack(alignment: .leading, spacing: 8) {
                Text("国王陛下")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("男 | 52岁")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("健康档案编号：KING-0001")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
    }
}

// 过往病史分区
struct DiseaseHistorySection: View {
    let diseases: [KingDisease]
    @Binding var showingDisease: KingDisease?
    @State private var animateItems = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 标题与描述
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("过往病史")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    Text("点击了解更多详细病史记录")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 添加按钮
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(.accentColor)
                }
            }
            
            // 疾病卡片横向滚动
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(Array(diseases.enumerated()), id: \.element.id) { index, disease in
                        Button(action: { showingDisease = disease }) {
                            VStack(spacing: 16) {
                                // 图标和状态指示
                                ZStack {
                                    // 背景圆形
                                    Circle()
                                        .fill(disease.color.opacity(0.15))
                                        .frame(width: 70, height: 70)
                                    
                                    // 图标
                                    Image(systemName: disease.icon)
                                        .font(.system(size: 28))
                                        .foregroundColor(disease.color)
                                    
                                    // 状态指示（仅用于示例）
                                    if index == 0 {
                                        Circle()
                                            .fill(Color.green)
                                            .frame(width: 14, height: 14)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 7)
                                                    .stroke(Color.white, lineWidth: 2)
                                            )
                                            .offset(x: 30, y: -30)
                                    }
                                }
                                
                                // 标题与记录数
                                VStack(spacing: 4) {
                                    Text(disease.name)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Text("\(disease.timeline.count)条记录")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                // 时间段与状态
                                if let firstDate = disease.timeline.last?.date,
                                   let lastDate = disease.timeline.first?.date {
                                    Text("\(firstDate) - \(lastDate)")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(4)
                                }
                                
                                // 查看更多按钮
                                HStack(spacing: 4) {
                                    Text("查看详情")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                    
                                    Image(systemName: "chevron.right")
                                        .font(.caption2)
                                }
                                .foregroundColor(disease.color)
                            }
                            .frame(width: 140)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: disease.color.opacity(0.1), radius: 12, x: 0, y: 4)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(disease.color.opacity(0.1), lineWidth: 1)
                            )
                            .opacity(animateItems ? 1 : 0)
                            .offset(y: animateItems ? 0 : 20)
                            .animation(.easeOut(duration: 0.4).delay(0.1 * Double(index)), value: animateItems)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 3)
        )
        .onAppear {
            // 添加出现动画
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 0.5)) {
                    animateItems = true
                }
            }
        }
    }
}

// 疾病时间线弹窗
struct DiseaseTimelineView: View {
    let disease: KingDisease
    @Binding var showingNode: DiseaseTimelineNode?
    @Environment(\.dismiss) var dismiss
    @State private var animateNodes = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 标题与指示符
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(disease.name)发展时间线")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("查看完整发病历程与治疗记录")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(disease.color.opacity(0.15))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: disease.icon)
                                .font(.system(size: 24))
                                .foregroundColor(disease.color)
                        }
                    }
                    .padding(.horizontal)
                    
                    // 统计指标
                    HStack(spacing: 15) {
                        // 发病时长
                        TimelineStatCard(
                            title: "发病时长",
                            value: "4年2个月",
                            icon: "clock.fill",
                            color: disease.color
                        )
                        
                        // 就诊次数
                        TimelineStatCard(
                            title: "累计就诊",
                            value: "\(disease.timeline.count)次",
                            icon: "stethoscope",
                            color: disease.color
                        )
                    }
                    .padding(.horizontal)
                    
                    // 时间线
                    VStack(spacing: 0) {
                        ForEach(Array(disease.timeline.enumerated()), id: \.element.id) { index, node in
                            VStack(spacing: 0) {
                                // 节点按钮
                                Button(action: { showingNode = node }) {
                                    HStack(alignment: .top, spacing: 18) {
                                        // 节点标记和线条
                                        ZStack(alignment: .center) {
                                            // 垂直连接线（上部）
                                            if index > 0 {
                                                Rectangle()
                                                    .fill(disease.color.opacity(0.3))
                                                    .frame(width: 2, height: 35)
                                                    .offset(y: -35)
                                            }
                                            
                                            // 节点圆圈
                                            ZStack {
                                                Circle()
                                                    .fill(disease.color.opacity(0.15))
                                                    .frame(width: 36, height: 36)
                                                Circle()
                                                    .fill(disease.color)
                                                    .frame(width: index == 0 ? 16 : 12, height: index == 0 ? 16 : 12)
                                            }
                                            
                                            // 垂直连接线（下部）
                                            if index < disease.timeline.count - 1 {
                                                Rectangle()
                                                    .fill(disease.color.opacity(0.3))
                                                    .frame(width: 2, height: 35)
                                                    .offset(y: 35)
                                            }
                                        }
                                        .frame(width: 36)
                                        
                                        // 节点内容
                                        VStack(alignment: .leading, spacing: 12) {
                                            // 时间日期
                                            HStack {
                                                Text(node.date)
                                                    .font(.headline)
                                                    .foregroundColor(disease.color)
                                                
                                                Spacer()
                                                
                                                // 状态标签
                                                if index == 0 {
                                                    Text("最新")
                                                        .font(.caption)
                                                        .fontWeight(.medium)
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 3)
                                                        .background(
                                                            Capsule()
                                                                .fill(Color.green.opacity(0.15))
                                                        )
                                                        .foregroundColor(.green)
                                                } else if index == disease.timeline.count - 1 {
                                                    Text("首次")
                                                        .font(.caption)
                                                        .fontWeight(.medium)
                                                        .padding(.horizontal, 8)
                                                        .padding(.vertical, 3)
                                                        .background(
                                                            Capsule()
                                                                .fill(Color.orange.opacity(0.15))
                                                        )
                                                        .foregroundColor(.orange)
                                                }
                                            }
                                            
                                            // 标题与描述
                                            VStack(alignment: .leading, spacing: 6) {
                                                Text(node.title)
                                                    .font(.title3)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.primary)
                                                
                                                Text(node.description)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                    .lineLimit(2)
                                            }
                                            
                                            // 医院与医生
                                            HStack(spacing: 12) {
                                                Label(node.hospital, systemImage: "building.2")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                
                                                Label(node.doctor, systemImage: "person")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            // 报告标签（如果有）
                                            if let report = node.report {
                                                Text(report)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                    .padding(.vertical, 4)
                                                    .padding(.horizontal, 10)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .fill(Color(.systemGray6))
                                                    )
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        // 箭头
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.secondary.opacity(0.5))
                                            .padding(.top, 12)
                                    }
                                    .padding(.vertical, 18)
                                    .padding(.horizontal)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color(.systemBackground))
                                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                    )
                                    .opacity(animateNodes ? 1 : 0)
                                    .offset(y: animateNodes ? 0 : 15)
                                    .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.1), value: animateNodes)
                                }
                                
                                // 间距
                                if index < disease.timeline.count - 1 {
                                    Spacer().frame(height: 12)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.title3)
                    }
                }
                
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Menu {
                        Button(action: {}) {
                            Label("导出记录", systemImage: "square.and.arrow.up")
                        }
                        Button(action: {}) {
                            Label("添加新记录", systemImage: "plus")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.primary)
                    }
                }
            }
            .onAppear {
                // 添加出现动画
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation(.easeOut(duration: 0.6)) {
                        animateNodes = true
                    }
                }
            }
        }
    }
}

// 时间线统计卡片
struct TimelineStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            // 图标
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
            }
            
            // 数值
            Text(value)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // 标题
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        )
    }
}

// 时间线节点详情弹窗
struct DiseaseTimelineNodeDetailView: View {
    let node: DiseaseTimelineNode
    @Environment(\.dismiss) var dismiss
    @State private var animateContent = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 标题与日期
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(node.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            // 分享按钮
                            Button(action: {}) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title3)
                                    .foregroundColor(.accentColor)
                            }
                        }
                        
                        Text(node.date)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.4), value: animateContent)
                    
                    // 医疗信息
                    VStack(alignment: .leading, spacing: 16) {
                        Text("医疗信息")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        // 信息卡片
                        VStack(spacing: 16) {
                            EnhancedInfoItemView(icon: "person.fill", iconColor: .blue, title: "主治医生", value: node.doctor)
                            
                            Divider()
                                .padding(.horizontal, 5)
                            
                            EnhancedInfoItemView(icon: "building.2.fill", iconColor: .purple, title: "就诊医院", value: node.hospital)
                            
                            if let report = node.report {
                                Divider()
                                    .padding(.horizontal, 5)
                                
                                EnhancedInfoItemView(icon: "doc.text.fill", iconColor: .orange, title: "检查报告", value: report)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
                        )
                    }
                    .padding(.horizontal)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.4).delay(0.1), value: animateContent)
                    
                    // 描述内容
                    VStack(alignment: .leading, spacing: 16) {
                        Text("详细描述")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(node.description)
                            .font(.body)
                            .lineSpacing(5)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
                            )
                    }
                    .padding(.horizontal)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.4).delay(0.2), value: animateContent)
                    
                    // 治疗方案
                    VStack(alignment: .leading, spacing: 16) {
                        Text("治疗方案")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            TreatmentItem(text: "保持良好生活习惯")
                            TreatmentItem(text: "定期服药，按医嘱调整用量")
                            TreatmentItem(text: "注意饮食，避免高盐高脂")
                            TreatmentItem(text: "定期复查，监测病情变化")
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
                        )
                    }
                    .padding(.horizontal)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.4).delay(0.3), value: animateContent)
                    
                    // 下一步建议
                    VStack(alignment: .leading, spacing: 16) {
                        Text("下一步建议")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack(spacing: 16) {
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "calendar.badge.plus")
                                    Text("预约复诊")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "bell.fill")
                                    Text("设置提醒")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(Color.accentColor.opacity(0.15))
                                .foregroundColor(.accentColor)
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .opacity(animateContent ? 1 : 0)
                    .offset(y: animateContent ? 0 : 20)
                    .animation(.easeOut(duration: 0.4).delay(0.4), value: animateContent)
                }
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("返回")
                        }
                        .foregroundColor(.accentColor)
                    }
                }
                
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    Menu {
                        Button(action: {}) {
                            Label("编辑记录", systemImage: "pencil")
                        }
                        Button(action: {}, label: {
                            Label("添加提醒", systemImage: "bell.badge.plus")
                        })
                        Button(action: {}, label: {
                            Label("删除记录", systemImage: "trash")
                        })
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(.primary)
                    }
                }
            }
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    animateContent = true
                }
            }
        }
    }
}

// 增强版信息项
struct EnhancedInfoItemView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 14) {
            // 图标
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
            }
            
            // 标题和值
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.headline)
            }
            
            Spacer()
        }
    }
}

// 治疗项目
struct TreatmentItem: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            
            Text(text)
                .font(.body)
        }
    }
}

// 搜索与智能助手
struct ArchiveSearchSection: View {
    @Binding var searchText: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("搜索档案内容/关键字/日期", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(10)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.04), radius: 3, x: 0, y: 1)
            Button(action: {}) {
                HStack {
                    Image(systemName: "wand.and.stars")
                        .foregroundColor(.purple)
                    Text("AI 智能归档助手")
                        .font(.subheadline)
                        .foregroundColor(.purple)
                }
                .padding(8)
                .background(Color.purple.opacity(0.08))
                .cornerRadius(8)
            }
        }
        .padding(.vertical, 2)
    }
}

// 通用分区卡片
struct ArchiveSection<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                Spacer()
            }
            content()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
}

// 就医记录卡片
struct MedicalVisitCard: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "stethoscope")
                .font(.system(size: 24))
                .foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 4) {
                Text("2023-12-10 门诊复诊")
                    .font(.headline)
                Text("主诉：头晕、乏力")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }
}

// 住院记录卡片
struct HospitalizationCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "bed.double.fill")
                    .foregroundColor(.purple)
                Text("2022-03-05 ~ 2022-03-20 住院")
                    .font(.headline)
            }
            Text("科室：心内科 主治：李医生")
                .font(.caption)
                .foregroundColor(.secondary)
            Text("出院小结：恢复良好，建议定期复查")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }
}

// 用药记录卡片
struct MedicationCard: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "pills.fill")
                .foregroundColor(.orange)
            VStack(alignment: .leading, spacing: 4) {
                Text("降压药（2022-04-01 ~ 2023-04-01）")
                    .font(.headline)
                Text("剂量：每日2次，早晚各一次")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }
}

// 检查报告卡片
struct ReportCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "doc.text.fill")
                    .foregroundColor(.teal)
                Text("2023-05-20 血常规报告")
                    .font(.headline)
            }
            Text("白细胞 6.2，红细胞 4.5，血红蛋白 140")
                .font(.caption)
                .foregroundColor(.secondary)
            Button(action: {}) {
                HStack(spacing: 4) {
                    Image(systemName: "eye.fill")
                    Text("查看原始报告")
                        .font(.caption)
                }
                .foregroundColor(.teal)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }
}

// 健康趋势分析
struct HealthTrendsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("健康趋势分析")
                .font(.title3)
                .fontWeight(.bold)
            HStack(spacing: 24) {
                TrendChart(title: "血压", color: .red, values: [120, 125, 130, 128, 122])
                TrendChart(title: "血糖", color: .orange, values: [5.6, 5.8, 5.4, 5.2, 5.5])
                TrendChart(title: "体重", color: .blue, values: [70, 69.5, 69, 68.8, 68.5])
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
}

struct TrendChart: View {
    let title: String
    let color: Color
    let values: [Double]
    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
            GeometryReader { geo in
                let maxVal = values.max() ?? 1
                let minVal = values.min() ?? 0
                let height = geo.size.height
                let points = values.enumerated().map { (i, v) in
                    CGPoint(x: CGFloat(i) / CGFloat(values.count-1) * geo.size.width,
                            y: height - CGFloat((v-minVal)/(maxVal-minVal+0.01)) * height)
                }
                Path { path in
                    if let first = points.first {
                        path.move(to: first)
                        for p in points.dropFirst() { path.addLine(to: p) }
                    }
                }
                .stroke(color, lineWidth: 2)
            }
            .frame(height: 50)
        }
        .frame(width: 80)
    }
}

// 健康成就徽章
struct HealthAchievementsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("健康成就")
                .font(.title3)
                .fontWeight(.bold)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<4) { i in
                        AchievementBadge(index: i)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
}

struct AchievementBadge: View {
    let index: Int
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: ["crown.fill", "star.fill", "flame.fill", "bolt.heart.fill"][index % 4])
                .font(.system(size: 32))
                .foregroundColor([.yellow, .orange, .red, .pink][index % 4])
            Text(["坚持服药30天", "连续复查3次", "运动打卡7天", "健康饮食达人"][index % 4])
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// 健康日历
struct HealthCalendarSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("健康日历")
                .font(.title3)
                .fontWeight(.bold)
            HStack(spacing: 16) {
                CalendarEventCard(title: "复查提醒", date: "2024-07-01", color: .blue)
                CalendarEventCard(title: "疫苗接种", date: "2024-08-15", color: .green)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
}

struct CalendarEventCard: View {
    let title: String
    let date: String
    let color: Color
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "calendar")
                .font(.system(size: 24))
                .foregroundColor(color)
            Text(title)
                .font(.headline)
            Text(date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 100)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// 健康日记
struct HealthDiarySection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("国王语录 · 健康日记")
                .font(.title3)
                .fontWeight(.bold)
            ForEach(0..<2) { i in
                DiaryCard(index: i)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 2)
    }
}

struct DiaryCard: View {
    let index: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(["2024-06-01", "2024-06-10"][index % 2])
                .font(.caption)
                .foregroundColor(.secondary)
            Text(["今日坚持锻炼，感觉精神很好。", "服药后血压平稳，感谢医生的建议！"][index % 2])
                .font(.body)
            Button(action: {}) {
                HStack(spacing: 4) {
                    Image(systemName: "wand.and.stars")
                    Text("AI 润色")
                        .font(.caption)
                }
                .foregroundColor(.purple)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// 统计数据模型
struct MedicalStatistics {
    let diseaseCategories: [ArchiveStatItem]
    let visitFrequency: [ArchiveStatItem]
    let topHospitals: [ArchiveStatItem]
    let topMedications: [ArchiveStatItem]
}

struct ArchiveStatItem {
    let name: String
    let value: Int
    let color: Color
    var unit: String = ""
}

// 健康统计面板
struct HealthStatisticsPanel: View {
    let stats: MedicalStatistics
    @State private var selectedTab = 0
    @State private var animateChart = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            titleSection
//            tabSection
            chartSection
            Divider().padding(.horizontal)
            statListSection
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 5)
        )
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("健康统计")
                .font(.title3)
                .fontWeight(.bold)
        }
    }
    
//    private var tabSection: some View {
//        HStack(spacing: 12) {
//            ForEach(0..<4, id: \.self) { index in
//                let isSelected = selectedTab == index
//                let labels = ["疾病","就诊","医院","药物"]
//                let icons = ["heart.fill", "stethoscope", "building.2", "pills"]
//                Button(action: {
//                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                        selectedTab = index
//                        animateChart = false
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            withAnimation(.easeOut(duration: 0.8)) {
//                                animateChart = true
//                            }
//                        }
//                    }
//                }) {
//                    VStack(spacing: 8) {
//                        Image(systemName: icons[index])
//                            .font(.system(size: isSelected ? 18 : 16))
//                            .foregroundColor(isSelected ? .white : .primary.opacity(0.7))
//                        Text(labels[index])
//                            .font(.caption)
//                            .fontWeight(isSelected ? .semibold : .regular)
//                            .foregroundColor(isSelected ? .white : .primary.opacity(0.7))
//                    }
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 12)
//                    .background(isSelected ?
//                        Color.accentColor.shadow(.drop(color: .accentColor.opacity(0.3), radius: 5, x: 0, y: 3)) :
//                        Color(.systemGray6))
//                    .cornerRadius(14)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 14)
//                            .stroke(isSelected ? Color.accentColor.opacity(0.1) : Color.clear, lineWidth: 1)
//                    )
//                }
//            }
//        }
//    }  
    
    private var chartSection: some View {
        ZStack {
            if selectedTab == 0 {
                EnhancedStatChartView(items: stats.diseaseCategories, title: "疾病分类", animate: animateChart)
            } else if selectedTab == 1 {
                EnhancedStatChartView(items: stats.visitFrequency, title: "就诊频率", animate: animateChart)
            } else if selectedTab == 2 {
                EnhancedStatChartView(items: stats.topHospitals, title: "常去医院", animate: animateChart)
            } else {
                EnhancedStatChartView(items: stats.topMedications, title: "药物使用", animate: animateChart)
            }
        }
        .frame(height: 240)
        .animation(.easeInOut, value: selectedTab)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeOut(duration: 0.8)) {
                    animateChart = true
                }
            }
        }
    }
    
    private var statListSection: some View {
        VStack(spacing: 12) {
            let items = selectedTab == 0 ? stats.diseaseCategories :
                       selectedTab == 1 ? stats.visitFrequency :
                       selectedTab == 2 ? stats.topHospitals :
                       stats.topMedications
            ForEach(0..<items.count, id: \.self) { index in
                EnhancedStatItemRow(
                    item: items[index],
                    maxValue: items.map { $0.value }.max() ?? 1,
                    index: index,
                    total: items.count,
                    animate: animateChart
                )
            }
        }
        .padding(.horizontal, 8)
    }
}

// 增强版统计图表视图
struct EnhancedStatChartView: View {
    let items: [ArchiveStatItem]
    let title: String
    let animate: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {            
            // 饼图
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    // 饼图
                    ZStack {
                        EnhancedPieChartView(items: items, animate: animate)
                            .frame(width: min(geometry.size.width, geometry.size.height) * 0.9,
                                   height: min(geometry.size.width, geometry.size.height) * 0.9)
                        
                        // 显示总量
                        let total = items.reduce(0) { $0 + $1.value }
                        VStack(spacing: 4) {
                            Text("\(total)")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text("总计")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(10)
                        .background(
                            Circle()
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        )
                    }
                    .frame(width: geometry.size.width * 0.6)
                    
                    // 图例
                    VStack(alignment: .leading, spacing: 14) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.bottom, 4)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 14) {
                                ForEach(0..<min(items.count, 6), id: \.self) { index in
                                    HStack(spacing: 10) {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(items[index].color)
                                            .frame(width: 14, height: 14)
                                        
                                        Text(items[index].name)
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Text("\(items[index].value)\(items[index].unit)")
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(items[index].color)
                                    }
                                    .opacity(animate ? 1 : 0)
                                    .offset(x: animate ? 0 : 20)
                                    .animation(
                                        .easeOut(duration: 0.4).delay(0.1 + Double(index) * 0.07),
                                        value: animate
                                    )
                                }
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 12)
                    .frame(width: geometry.size.width * 0.4, alignment: .leading)
                }
            }
        }
    }
}

// 增强版饼图视图
struct EnhancedPieChartView: View {
    let items: [ArchiveStatItem]
    let animate: Bool
    
    var body: some View {
        ZStack {
            ForEach(0..<items.count, id: \.self) { index in
                EnhancedPieSliceView(
                    startAngle: startAngle(for: index),
                    endAngle: endAngle(for: index),
                    color: items[index].color,
                    animate: animate,
                    delay: Double(index) * 0.05
                )
            }
        }
    }
    
    private func startAngle(for index: Int) -> Double {
        let total = items.reduce(0) { $0 + $1.value }
        let proportions = items.map { Double($0.value) / Double(total) }
        
        var startAngle: Double = 0
        for i in 0..<index {
            startAngle += proportions[i] * 360
        }
        
        return startAngle
    }
    
    private func endAngle(for index: Int) -> Double {
        startAngle(for: index + 1)
    }
}

// 增强版饼图切片
struct EnhancedPieSliceView: View {
    let startAngle: Double
    let endAngle: Double
    let color: Color
    let animate: Bool
    let delay: Double
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                
                path.move(to: center)
                path.addArc(center: center,
                           radius: radius,
                           startAngle: .degrees(animate ? startAngle - 90 : 0),
                           endAngle: .degrees(animate ? endAngle - 90 : 0),
                           clockwise: false)
                path.closeSubpath()
            }
            .fill(color.shadow(.inner(color: .white.opacity(0.1), radius: 2, x: 0, y: 1)))
            .animation(.easeOut(duration: 0.8).delay(delay), value: animate)
            .overlay(
                // 添加轻微的光泽效果
                Path { path in
                    let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    let radius = min(geometry.size.width, geometry.size.height) / 2
                    
                    path.move(to: center)
                    path.addArc(center: center,
                               radius: radius,
                               startAngle: .degrees(animate ? startAngle - 90 : 0),
                               endAngle: .degrees(animate ? endAngle - 90 : 0),
                               clockwise: false)
                    path.closeSubpath()
                }
                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                .animation(.easeOut(duration: 0.8).delay(delay), value: animate)
            )
        }
    }
}

// 增强版统计项行视图
struct EnhancedStatItemRow: View {
    let item: ArchiveStatItem
    let maxValue: Int
    let index: Int
    let total: Int
    let animate: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            // 名称和图标区域
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(item.color)
                    .frame(width: 10, height: 10)
                
                Text(item.name)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            .frame(width: 110, alignment: .leading)
            
            // 进度条
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // 背景
                    Capsule()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 10)
                    
                    // 进度
                    Capsule()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [item.color.opacity(0.8), item.color]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: animate ? (CGFloat(item.value) / CGFloat(maxValue) * geometry.size.width) : 0, height: 10)
                        .animation(.easeOut(duration: 0.6).delay(0.2 + Double(index) * 0.1), value: animate)
                }
            }
            .frame(height: 10)
            
            // 数值
            Text("\(item.value)\(item.unit)")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(item.color)
                .frame(width: 50, alignment: .trailing)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
        )
        .opacity(animate ? 1 : 0)
        .offset(y: animate ? 0 : 10)
        .animation(.easeOut(duration: 0.4).delay(0.3 + Double(index) * 0.1), value: animate)
    }
}

// --- Section 拆分 ---
struct MedicalVisitSection: View {
    var body: some View {
        ArchiveSection(title: "就医记录", icon: "stethoscope", color: .blue) {
            ForEach(0..<2, id: \ .self) { _ in MedicalVisitCard() }
        }
    }
}

struct HospitalizationSection: View {
    var body: some View {
        ArchiveSection(title: "住院记录", icon: "bed.double.fill", color: .purple) {
            ForEach(0..<1, id: \ .self) { _ in HospitalizationCard() }
        }
    }
}

struct MedicationSection: View {
    var body: some View {
        ArchiveSection(title: "用药记录", icon: "pills.fill", color: .orange) {
            ForEach(0..<2, id: \ .self) { _ in MedicationCard() }
        }
    }
}

struct ReportSection: View {
    var body: some View {
        ArchiveSection(title: "检查报告与化验单", icon: "doc.text.fill", color: .teal) {
            ForEach(0..<2, id: \ .self) { _ in ReportCard() }
        }
    }
}

#Preview {
    ProfileArchiveView()
} 
