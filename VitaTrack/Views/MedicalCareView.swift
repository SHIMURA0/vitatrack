import SwiftUI

struct MedicalCareView: View {
    @State private var searchText = ""
    @State private var selectedTab = 0
    @State private var showingMedicalCode = false
    @State private var showingAIAssistant = false
    @State private var isRecording = false
    @State private var showingDiseaseAnalysis = false
    
    // 科室列表
    let departments = [
        MedicalDepartment(name: "内科", icon: "heart.fill", color: .red),
        MedicalDepartment(name: "外科", icon: "bandage.fill", color: .blue),
        MedicalDepartment(name: "妇产科", icon: "figure.dress.line.vertical.figure", color: .pink),
        MedicalDepartment(name: "儿科", icon: "figure.child", color: .green),
        MedicalDepartment(name: "眼科", icon: "eye.fill", color: .purple),
        MedicalDepartment(name: "口腔科", icon: "mouth.fill", color: .orange),
        MedicalDepartment(name: "皮肤科", icon: "hand.raised.fill", color: .indigo),
        MedicalDepartment(name: "更多", icon: "ellipsis.circle.fill", color: .gray)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 搜索栏
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                    
                    // 就医码快捷入口
                    MedicalCodeButton(showingMedicalCode: $showingMedicalCode)
                        .padding(.horizontal)
                    
                    // 科室导航
                    DepartmentGrid(departments: departments)
                        .padding(.horizontal)
                    
                    // 热门医生
                    PopularDoctorsSection()
                        .padding(.horizontal)
                    
                    // AI 辅助功能
                    AIAssistantSection(
                        showingAIAssistant: $showingAIAssistant,
                        showingDiseaseAnalysis: $showingDiseaseAnalysis
                    )
                    .padding(.horizontal)
                    
                    // 就医记录
                    MedicalRecordsSection()
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("就医服务")
            .sheet(isPresented: $showingMedicalCode) {
                MedicalCodeView()
            }
            .sheet(isPresented: $showingAIAssistant) {
                MedicalAIAssistantView()
            }
            .sheet(isPresented: $showingDiseaseAnalysis) {
                DiseaseAnalysisView()
            }
        }
    }
}

// 搜索栏
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("搜索医院、医生、科室", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// 就医码按钮
struct MedicalCodeButton: View {
    @Binding var showingMedicalCode: Bool
    
    var body: some View {
        Button(action: { showingMedicalCode = true }) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("就医码")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("快速查看健康档案")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "qrcode.viewfinder")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.blue, .purple]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
        }
    }
}

// 科室网格
struct DepartmentGrid: View {
    let departments: [MedicalDepartment]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("选择科室")
                .font(.title3)
                .fontWeight(.bold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 4), spacing: 15) {
                ForEach(departments) { department in
                    DepartmentButton(department: department)
                }
            }
        }
    }
}

// 科室按钮
struct DepartmentButton: View {
    let department: MedicalDepartment
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(department.color.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: department.icon)
                    .font(.system(size: 20))
                    .foregroundColor(department.color)
            }
            
            Text(department.name)
                .font(.caption)
                .foregroundColor(.primary)
        }
    }
}

// 热门医生部分
struct PopularDoctorsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("推荐医生")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {}) {
                    Text("查看全部")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(1...5, id: \.self) { _ in
                        DoctorCard()
                    }
                }
            }
        }
    }
}

// 医生卡片
struct DoctorCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 医生头像
            ZStack(alignment: .topTrailing) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("张医生")
                    .font(.headline)
                
                Text("心内科 | 主任医师")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("4.9")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Button(action: {}) {
                Text("预约")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
        .frame(width: 160)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// AI 辅助功能部分
struct AIAssistantSection: View {
    @Binding var showingAIAssistant: Bool
    @Binding var showingDiseaseAnalysis: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("AI 智能助手")
                .font(.title3)
                .fontWeight(.bold)
            
            HStack(spacing: 16) {
                // 症状描述优化
                AIFeatureCard(
                    title: "症状描述优化",
                    description: "AI 辅助润色症状描述",
                    icon: "text.bubble.fill",
                    color: .blue
                ) {
                    showingAIAssistant = true
                }
                
                // 疾病分析
                AIFeatureCard(
                    title: "疾病分析",
                    description: "AI 辅助诊断建议",
                    icon: "brain.head.profile",
                    color: .purple
                ) {
                    showingDiseaseAnalysis = true
                }
            }
        }
    }
}

// AI 功能卡片
struct AIFeatureCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

// 就医记录部分
struct MedicalRecordsSection: View {
    @State private var isRecording = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("就医记录")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: {}) {
                    Text("查看全部")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
            }
            
            VStack(spacing: 16) {
                // 录音功能
                RecordingCard(isRecording: $isRecording)
                
                // 最近就医记录
                ForEach(1...2, id: \.self) { _ in
                    MedicalRecordCard()
                }
            }
        }
    }
}

// 录音卡片
struct RecordingCard: View {
    @Binding var isRecording: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("就医录音")
                    .font(.headline)
                
                Text("记录与医生的对话")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { isRecording.toggle() }) {
                ZStack {
                    Circle()
                        .fill(isRecording ? Color.red : Color.blue)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// 就医记录卡片
struct MedicalRecordCard: View {
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 45, height: 45)
                
                Image(systemName: "stethoscope")
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("心内科复诊")
                    .font(.headline)
                
                Text("市第一医院 | 2024-03-15")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// 数据模型
struct MedicalDepartment: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

// 就医码视图
struct MedicalCodeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // 二维码显示
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .frame(width: 250, height: 250)
                        .shadow(radius: 10)
                    
                    Image(systemName: "qrcode")
                        .font(.system(size: 200))
                        .foregroundColor(.black)
                }
                
                // 健康档案摘要
                VStack(spacing: 20) {
                    MedicalInfoRow(title: "既往病史", value: "高血压、糖尿病")
                    MedicalInfoRow(title: "过敏药物", value: "青霉素")
                    MedicalInfoRow(title: "常用药物", value: "降压药、降糖药")
                    MedicalInfoRow(title: "最近症状", value: "头痛、胸闷")
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                
                Spacer()
            }
            .padding()
            .navigationTitle("就医码")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// 信息行
struct MedicalInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
        }
    }
}

// AI 助手视图
struct MedicalAIAssistantView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var symptomText = ""
    @State private var optimizedText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 输入区域
                VStack(alignment: .leading, spacing: 10) {
                    Text("请描述您的症状")
                        .font(.headline)
                    
                    TextEditor(text: $symptomText)
                        .frame(height: 150)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                
                // 优化按钮
                Button(action: optimizeText) {
                    Text("AI 优化描述")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                
                // 优化结果
                if !optimizedText.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("优化后的描述")
                            .font(.headline)
                        
                        Text(optimizedText)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("症状描述优化")
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
    
    private func optimizeText() {
        // 这里添加 AI 优化文本的逻辑
        optimizedText = "经过 AI 优化后的症状描述：\n" + symptomText
    }
}

// 疾病分析视图
struct DiseaseAnalysisView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var symptoms = ""
    @State private var analysisResults: [DiseaseAnalysis] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 症状输入
                    VStack(alignment: .leading, spacing: 10) {
                        Text("请输入您的症状")
                            .font(.headline)
                        
                        TextEditor(text: $symptoms)
                            .frame(height: 150)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    // 分析按钮
                    Button(action: analyzeSymptoms) {
                        Text("开始分析")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    // 分析结果
                    if !analysisResults.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("可能的疾病方向")
                                .font(.headline)
                            
                            ForEach(analysisResults) { result in
                                DiseaseAnalysisCard(analysis: result)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("疾病分析")
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
    
    private func analyzeSymptoms() {
        // 这里添加 AI 分析症状的逻辑
        analysisResults = [
            DiseaseAnalysis(
                disease: "高血压",
                probability: 0.85,
                description: "根据症状描述，可能存在高血压风险",
                recommendations: ["建议测量血压", "控制钠盐摄入", "规律运动"]
            ),
            DiseaseAnalysis(
                disease: "冠心病",
                probability: 0.65,
                description: "症状可能与冠心病相关",
                recommendations: ["建议进行心电图检查", "避免剧烈运动", "保持情绪稳定"]
            )
        ]
    }
}

// 疾病分析卡片
struct DiseaseAnalysisCard: View {
    let analysis: DiseaseAnalysis
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(analysis.disease)
                    .font(.headline)
                
                Spacer()
                
                Text("\(Int(analysis.probability * 100))%")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            
            Text(analysis.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("建议")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                ForEach(analysis.recommendations, id: \.self) { recommendation in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        
                        Text(recommendation)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// 疾病分析数据模型
struct DiseaseAnalysis: Identifiable {
    let id = UUID()
    let disease: String
    let probability: Double
    let description: String
    let recommendations: [String]
}

#Preview {
    MedicalCareView()
} 