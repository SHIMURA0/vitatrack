import SwiftUI

struct MedicationManagerView: View {
    @State private var selectedTab = 0
    @State private var searchText = ""
    @State private var showAddMedication = false
    @State private var showMedicationDetail: Medication? = nil
    @State private var showDiseaseDetail: DiseaseMedication? = nil
    @State private var showScanSheet = false
    @Namespace private var tabAnimation
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                // 顶部渐变背景
                LinearGradient(gradient: Gradient(colors: [Color(hex: "#5B8CFF"), Color(hex: "#A259FF")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(height: 220)
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    // 顶部Banner
                    BannerCarousel()
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    // 搜索栏和扫码
                    HStack(spacing: 10) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.secondary)
                            TextField("搜索药物/疾病/科普内容", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        .padding(10)
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1)
                        Button(action: { showScanSheet = true }) {
                            Image(systemName: "qrcode.viewfinder")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                                .padding(8)
                                .background(Color.white.opacity(0.8))
                                .clipShape(Circle())
                        }
                        .sheet(isPresented: $showScanSheet) {
                            ScanMedicationSheet()
                        }
                        Button(action: { showAddMedication = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.accentColor)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 2)
                    // Tab 切换
                    VStack(spacing: 12) {
                        // 第一行：我的用药、疾病用药
                        HStack(spacing: 12) {
                            // 我的用药
                            Button(action: { withAnimation(.spring()) { selectedTab = 0 } }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "pills.fill")
                                        .font(.system(size: 20, weight: .bold))
                                    Text("我的用药")
                                        .font(.caption)
                                }
                                .foregroundColor(selectedTab == 0 ? .white : .accentColor)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    ZStack {
                                        if selectedTab == 0 {
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#5B8CFF"), Color(hex: "#A259FF")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .matchedGeometryEffect(id: "tab", in: tabAnimation)
                                        } else {
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(Color(.systemGray6))
                                        }
                                    }
                                )
                                .scaleEffect(selectedTab == 0 ? 1.05 : 1.0)
                                .animation(.spring(), value: selectedTab)
                            }
                            
                            // 疾病用药
                            Button(action: { withAnimation(.spring()) { selectedTab = 1 } }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "cross.case.fill")
                                        .font(.system(size: 20, weight: .bold))
                                    Text("疾病用药")
                                        .font(.caption)
                                }
                                .foregroundColor(selectedTab == 1 ? .white : .accentColor)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    ZStack {
                                        if selectedTab == 1 {
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#5B8CFF"), Color(hex: "#A259FF")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .matchedGeometryEffect(id: "tab", in: tabAnimation)
                                        } else {
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(Color(.systemGray6))
                                        }
                                    }
                                )
                                .scaleEffect(selectedTab == 1 ? 1.05 : 1.0)
                                .animation(.spring(), value: selectedTab)
                            }
                        }
                        
                        // 第二行：药物科普、药物搜索
                        HStack(spacing: 12) {
                            // 药物科普
                            Button(action: { withAnimation(.spring()) { selectedTab = 2 } }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "book.fill")
                                        .font(.system(size: 20, weight: .bold))
                                    Text("药物科普")
                                        .font(.caption)
                                }
                                .foregroundColor(selectedTab == 2 ? .white : .accentColor)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    ZStack {
                                        if selectedTab == 2 {
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#5B8CFF"), Color(hex: "#A259FF")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .matchedGeometryEffect(id: "tab", in: tabAnimation)
                                        } else {
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(Color(.systemGray6))
                                        }
                                    }
                                )
                                .scaleEffect(selectedTab == 2 ? 1.05 : 1.0)
                                .animation(.spring(), value: selectedTab)
                            }
                            
                            // 药物搜索
                            Button(action: { withAnimation(.spring()) { selectedTab = 3 } }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 20, weight: .bold))
                                    Text("药物搜索")
                                        .font(.caption)
                                }
                                .foregroundColor(selectedTab == 3 ? .white : .accentColor)
                                .padding(.vertical, 16)
                                .frame(maxWidth: .infinity)
                                .background(
                                    ZStack {
                                        if selectedTab == 3 {
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#5B8CFF"), Color(hex: "#A259FF")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                                .matchedGeometryEffect(id: "tab", in: tabAnimation)
                                        } else {
                                            RoundedRectangle(cornerRadius: 14)
                                                .fill(Color(.systemGray6))
                                        }
                                    }
                                )
                                .scaleEffect(selectedTab == 3 ? 1.05 : 1.0)
                                .animation(.spring(), value: selectedTab)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .background(Color(.systemBackground).opacity(0.95))  
                    // 主内容
                    ZStack {
                        switch selectedTab {
                        case 0:
                            MyMedicationsSection(showDetail: $showMedicationDetail)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                        case 1:
                            DiseaseMedicationsSection(showDetail: $showDiseaseDetail)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                        case 2:
                            MedicationKnowledgeSection()
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                        case 3:
                            MedicationSearchSection(searchText: $searchText, showDetail: $showMedicationDetail)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                        default:
                            EmptyView()
                        }
                    }
                    .padding(.top, 8)
                    .animation(.easeInOut, value: selectedTab)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("用药管理")
            .sheet(isPresented: $showAddMedication) {
                AddMedicationSheet()
            }
            .sheet(item: $showMedicationDetail) { med in
                MedicationDetailSheet(medication: med)
            }
            .sheet(item: $showDiseaseDetail) { disease in
                DiseaseMedicationDetailSheet(disease: disease)
            }
        }
    }
}

// MARK: - Banner 轮播
struct BannerCarousel: View {
    @State private var current = 0
    let banners: [Banner] = Banner.mockList
    var body: some View {
        TabView(selection: $current) {
            ForEach(banners.indices, id: \ .self) { i in
                BannerCard(banner: banners[i])
                    .tag(i)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .frame(height: 90)
        .padding(.horizontal, 8)
        .onAppear {
            // 自动轮播
            Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
                withAnimation { current = (current + 1) % banners.count }
            }
        }
    }
}

struct BannerCard: View {
    let banner: Banner
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: banner.icon)
                .font(.system(size: 36))
                .foregroundColor(banner.color)
                .padding(12)
                .background(Circle().fill(banner.color.opacity(0.12)))
            VStack(alignment: .leading, spacing: 4) {
                Text(banner.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(banner.subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(18)
        .shadow(color: banner.color.opacity(0.08), radius: 8, x: 0, y: 3)
    }
}

struct Banner: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    static let mockList: [Banner] = [
        Banner(title: "用药提醒，健康无忧", subtitle: "开启提醒，按时服药不遗漏", icon: "alarm.fill", color: Color(hex: "#5B8CFF")),
        Banner(title: "扫码识别药品", subtitle: "快速录入药品信息", icon: "qrcode.viewfinder", color: Color(hex: "#A259FF")),
        Banner(title: "药物科普新知", subtitle: "了解更多用药知识", icon: "book.fill", color: .purple)
    ]
}

// MARK: - 扫码识别药品
struct ScanMedicationSheet: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "qrcode.viewfinder")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
                .padding(.top, 40)
            Text("扫码识别药品")
                .font(.title2)
                .fontWeight(.bold)
            Text("请将药品包装上的二维码/条形码对准扫描框，自动识别药品信息。")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
            Button(action: { /* TODO: 扫码功能 */ }) {
                HStack {
                    Image(systemName: "camera.fill")
                    Text("开始扫描")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color(hex: "#5B8CFF"), Color(hex: "#A259FF")]), startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(14)
            }
            .padding(.bottom, 40)
        }
        .padding()
    }
}

// MARK: - 我的用药
struct MyMedicationsSection: View {
    @Binding var showDetail: Medication?
    @State private var medications: [Medication] = Medication.mockList
    @State private var filter: String = ""
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Text("历史用药记录")
                        .font(.headline)
                    Spacer()
                    Button("筛选") { /* TODO: 筛选弹窗 */ }
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
                ForEach(medications.filter { filter.isEmpty || $0.name.contains(filter) }) { med in
                    MMedicationCard(medication: med, onTap: { showDetail = med })
                }
                Button(action: { /* TODO: 添加新药物 */ }) {
                    HStack {
                        Image(systemName: "plus")
                        Text("添加新药物")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.top, 8)
            }
            .padding()
        }
    }
}

struct MMedicationCard: View {
    let medication: Medication
    var onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                Image(systemName: medication.icon)
                    .font(.system(size: 32))
                    .foregroundColor(.accentColor)
                    .padding(8)
                    .background(Circle().fill(Color.accentColor.opacity(0.12)))
                VStack(alignment: .leading, spacing: 4) {
                    Text(medication.name)
                        .font(.headline)
                    Text(medication.usage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - 疾病用药
struct DiseaseMedicationsSection: View {
    @Binding var showDetail: DiseaseMedication?
    @State private var diseases: [DiseaseMedication] = DiseaseMedication.mockList
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("常见疾病药物推荐")
                    .font(.headline)
                ForEach(diseases) { disease in
                    MDiseaseMedicationCard(disease: disease, onTap: { showDetail = disease })
                }
            }
            .padding()
        }
    }
}

struct MDiseaseMedicationCard: View {
    let disease: DiseaseMedication
    var onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: disease.icon)
                        .font(.system(size: 28))
                        .foregroundColor(.blue)
                    Text(disease.name)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                Text("推荐药物：" + disease.recommendedMedications.joined(separator: ", "))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(14)
            .shadow(color: Color.blue.opacity(0.06), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - 药物科普
struct MedicationKnowledgeSection: View {
    @State private var knowledgeList: [MedicationKnowledge] = MedicationKnowledge.mockList
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("药物科普")
                    .font(.headline)
                ForEach(knowledgeList) { item in
                    MKnowledgeCard(knowledge: item)
                }
            }
            .padding()
        }
    }
}

struct MKnowledgeCard: View {
    let knowledge: MedicationKnowledge
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: knowledge.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.purple)
                Text(knowledge.title)
                    .font(.headline)
            }
            Text(knowledge.content)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: Color.purple.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

// MARK: - 药物搜索
struct MedicationSearchSection: View {
    @Binding var searchText: String
    @Binding var showDetail: Medication?
    @State private var allMedications: [Medication] = Medication.mockList
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("药物搜索结果")
                    .font(.headline)
                if searchText.isEmpty {
                    Text("请输入药物名/疾病名/成分名进行搜索")
                        .foregroundColor(.secondary)
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(allMedications.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.usage.localizedCaseInsensitiveContains(searchText) }) { med in
                        MMedicationCard(medication: med, onTap: { showDetail = med })
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Sheet & 详情
struct AddMedicationSheet: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("添加新药物")
                .font(.title2)
                .fontWeight(.bold)
            // TODO: 添加表单
            Spacer()
        }
        .padding()
    }
}

struct MedicationDetailSheet: View {
    let medication: Medication
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Image(systemName: medication.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.accentColor)
                VStack(alignment: .leading) {
                    Text(medication.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(medication.usage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Divider()
            Text("用药说明")
                .font(.headline)
            Text(medication.detail)
                .font(.body)
            Spacer()
        }
        .padding()
    }
}

struct DiseaseMedicationDetailSheet: View {
    let disease: DiseaseMedication
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Image(systemName: disease.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                Text(disease.name)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Divider()
            Text("推荐药物")
                .font(.headline)
            ForEach(disease.recommendedMedications, id: \ .self) { med in
                Text(med)
                    .font(.body)
            }
            Divider()
            Text("用药建议")
                .font(.headline)
            Text(disease.suggestion)
                .font(.body)
            Spacer()
        }
        .padding()
    }
}

// MARK: - Mock Data Models
struct Medication: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let usage: String
    let detail: String
    static let mockList: [Medication] = [
        Medication(name: "阿司匹林", icon: "pills.fill", usage: "每日1次，餐后服用", detail: "阿司匹林用于预防血栓、心脑血管疾病。注意胃肠道反应，避免与抗凝药同服。"),
        Medication(name: "二甲双胍", icon: "pills.fill", usage: "每日2次，餐前服用", detail: "二甲双胍用于2型糖尿病，降糖效果好。注意肾功能不全者慎用。"),
        Medication(name: "氯沙坦", icon: "pills.fill", usage: "每日1次，早晨服用", detail: "氯沙坦为降压药，适用于高血压患者。注意监测血钾。"),
        Medication(name: "阿莫西林", icon: "pills.fill", usage: "每日3次，饭后服用", detail: "阿莫西林为常用抗生素，注意过敏史。"),
        Medication(name: "瑞舒伐他汀", icon: "pills.fill", usage: "每日1次，睡前服用", detail: "瑞舒伐他汀用于降脂，注意肝功能监测。")
    ]
}

struct DiseaseMedication: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let icon: String
    let recommendedMedications: [String]
    let suggestion: String
    static let mockList: [DiseaseMedication] = [
        DiseaseMedication(name: "高血压", icon: "heart.fill", recommendedMedications: ["氯沙坦", "缬沙坦", "苯磺酸氨氯地平"], suggestion: "高血压患者应规律服药，监测血压，注意低盐饮食。"),
        DiseaseMedication(name: "糖尿病", icon: "drop.fill", recommendedMedications: ["二甲双胍", "格列美脲", "阿卡波糖"], suggestion: "糖尿病患者应控制饮食，规律服药，监测血糖。"),
        DiseaseMedication(name: "冠心病", icon: "bolt.heart.fill", recommendedMedications: ["阿司匹林", "瑞舒伐他汀", "硝酸甘油"], suggestion: "冠心病患者应避免剧烈运动，按时服药，定期复查。")
    ]
}

struct MedicationKnowledge: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let icon: String
    let content: String
    static let mockList: [MedicationKnowledge] = [
        MedicationKnowledge(title: "抗生素的正确使用", icon: "bandage.fill", content: "抗生素不可滥用，需遵医嘱按疗程服用，避免耐药。"),
        MedicationKnowledge(title: "降压药的服用时间", icon: "clock.fill", content: "大部分降压药建议早晨服用，部分药物需分次服用。"),
        MedicationKnowledge(title: "药物与食物的相互作用", icon: "fork.knife", content: "部分药物需空腹服用，部分药物需餐后服用，注意药物说明书。")
    ]
}

// MARK: - 颜色扩展
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 
