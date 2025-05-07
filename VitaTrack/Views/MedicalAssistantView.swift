import SwiftUI

struct MedicalAssistantView: View {
    @State private var searchText = ""
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 标签选择器
                Picker("", selection: $selectedTab) {
                    Text("症状").tag(0)
                    Text("医院").tag(1)
                    Text("医生").tag(2)
                }
                .pickerStyle(.segmented)
                .padding()
                
                if selectedTab == 0 {
                    SymptomView()
                } else if selectedTab == 1 {
                    HospitalView()
                } else {
                    DoctorView()
                }
            }
            .navigationTitle("就医助手")
        }
    }
}

struct SymptomView: View {
    @State private var symptoms = ""
    @State private var showingAIAssistant = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 症状描述输入
                VStack(alignment: .leading, spacing: 12) {
                    Text("症状描述")
                        .font(.headline)
                    
                    TextEditor(text: $symptoms)
                        .frame(height: 120)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    
                    Button(action: {
                        showingAIAssistant = true
                    }) {
                        HStack {
                            Image(systemName: "wand.and.stars")
                            Text("AI 辅助描述")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(radius: 5)
                
                // 常见症状
                VStack(alignment: .leading, spacing: 12) {
                    Text("常见症状")
                        .font(.headline)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(commonSymptoms, id: \.self) { symptom in
                            SymptomButton(symptom: symptom)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(radius: 5)
                
                // 科室推荐
                VStack(alignment: .leading, spacing: 12) {
                    Text("推荐科室")
                        .font(.headline)
                    
                    ForEach(1...3, id: \.self) { _ in
                        DepartmentRecommendationRow()
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(radius: 5)
            }
            .padding()
        }
        .sheet(isPresented: $showingAIAssistant) {
            AIAssistantView(symptoms: $symptoms)
        }
    }
    
    let commonSymptoms = [
        "头痛", "发热", "咳嗽", "腹痛",
        "恶心", "呕吐", "腹泻", "皮疹",
        "关节痛", "胸闷", "心悸", "头晕"
    ]
}

struct SymptomButton: View {
    let symptom: String
    
    var body: some View {
        Button(action: {
            // 添加症状
        }) {
            Text(symptom)
                .font(.subheadline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(10)
        }
    }
}

struct DepartmentRecommendationRow: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("心内科")
                    .font(.headline)
                Text("匹配度：90%")
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

struct AIAssistantView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var symptoms: String
    @State private var aiResponse = ""
    @State private var isGenerating = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 原始症状
                VStack(alignment: .leading, spacing: 8) {
                    Text("原始症状")
                        .font(.headline)
                    Text(symptoms)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // AI 优化后的症状
                VStack(alignment: .leading, spacing: 8) {
                    Text("AI 优化描述")
                        .font(.headline)
                    
                    if isGenerating {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text(aiResponse)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                Spacer()
                
                // 操作按钮
                HStack {
                    Button("取消") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("使用此描述") {
                        symptoms = aiResponse
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
            .navigationTitle("AI 辅助描述")
            .navigationBarItems(trailing: Button("关闭") {
                dismiss()
            })
            .onAppear {
                generateAIResponse()
            }
        }
    }
    
    private func generateAIResponse() {
        isGenerating = true
        // 模拟 AI 生成响应
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            aiResponse = "患者主诉：持续性头痛3天，伴有轻微发热（37.5℃），无其他明显不适。头痛位于前额部，呈钝痛，程度中等，影响日常活动。"
            isGenerating = false
        }
    }
}

struct HospitalView: View {
    @State private var searchText = ""
    
    var body: some View {
        List {
            ForEach(1...5, id: \.self) { _ in
                HospitalRow()
            }
        }
        .searchable(text: $searchText, prompt: "搜索医院")
    }
}

struct HospitalRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("协和医院")
                        .font(.headline)
                    Text("三甲医院")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("4.9")
                    .font(.headline)
                    .foregroundColor(.orange)
            }
            
            Text("北京市东城区帅府园一号")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                ForEach(["心内科", "神经内科", "骨科"], id: \.self) { department in
                    Text(department)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct DoctorView: View {
    @State private var searchText = ""
    
    var body: some View {
        List {
            ForEach(1...5, id: \.self) { _ in
                DoctorRow()
            }
        }
        .searchable(text: $searchText, prompt: "搜索医生")
    }
}

struct DoctorRow: View {
    var body: some View {
        HStack(spacing: 15) {
            // 医生头像
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("张医生")
                    .font(.headline)
                Text("心内科 主任医师")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("协和医院")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("4.9")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    MedicalAssistantView()
} 