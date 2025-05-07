import SwiftUI

struct HealthRecordingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategory: RecordCategory = .bloodPressure
    @State private var showingSuccessMessage = false
    
    enum RecordCategory: String, CaseIterable, Identifiable {
        case bloodPressure = "血压"
        case heartRate = "心率"
        case bloodSugar = "血糖"
        case weight = "体重"
        case medication = "用药"
        case symptoms = "症状"
        case diet = "饮食"
        case exercise = "运动"
        
        var id: String { self.rawValue }
        
        var iconName: String {
            switch self {
            case .bloodPressure: return "heart.fill"
            case .heartRate: return "waveform.path.ecg"
            case .bloodSugar: return "drop.fill"
            case .weight: return "scalemass.fill"
            case .medication: return "pills.fill"
            case .symptoms: return "thermometer"
            case .diet: return "fork.knife"
            case .exercise: return "figure.walk"
            }
        }
        
        var color: Color {
            switch self {
            case .bloodPressure: return .red
            case .heartRate: return .orange
            case .bloodSugar: return .blue
            case .weight: return .purple
            case .medication: return .green
            case .symptoms: return .pink
            case .diet: return .teal
            case .exercise: return .indigo
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 类别选择器
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(RecordCategory.allCases) { category in
                            Button(action: { selectedCategory = category }) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(selectedCategory == category ? category.color : category.color.opacity(0.1))
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: category.iconName)
                                            .font(.system(size: 20))
                                            .foregroundColor(selectedCategory == category ? .white : category.color)
                                    }
                                    
                                    Text(category.rawValue)
                                        .font(.caption)
                                        .foregroundColor(selectedCategory == category ? category.color : .primary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .background(Color(.systemBackground))
                
                Divider()
                
                // 录入表单区域
                ScrollView {
                    VStack(spacing: 24) {
                        // 录入表单的标题
                        HStack {
                            Image(systemName: selectedCategory.iconName)
                                .font(.title2)
                                .foregroundColor(selectedCategory.color)
                            
                            Text("记录\(selectedCategory.rawValue)")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Spacer()
                        }
                        .padding(.top, 16)
                        
                        // 简化：仅展示一个通用表单
                        VStack(alignment: .leading, spacing: 16) {
                            Text("输入数据")
                                .font(.headline)
                            
                            TextField("输入\(selectedCategory.rawValue)值", text: .constant(""))
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                            
                            // 附加单位（因类别而异）
                            let unit = getUnit(for: selectedCategory)
                            if !unit.isEmpty {
                                Text("单位: \(unit)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        
                        // 记录时间选择
                        VStack(alignment: .leading, spacing: 12) {
                            Text("记录时间")
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.accentColor)
                                    .frame(width: 24, height: 24)
                                
                                DatePicker("选择日期和时间", selection: .constant(Date()))
                                    .labelsHidden()
                                
                                Spacer()
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        
                        // 备注区域
                        VStack(alignment: .leading, spacing: 12) {
                            Text("备注")
                                .font(.headline)
                            
                            TextEditor(text: .constant(""))
                                .frame(minHeight: 100)
                                .padding(8)
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(16)
                        
                        // 提交按钮
                        Button(action: {
                            // 处理提交逻辑
                            withAnimation {
                                showingSuccessMessage = true
                            }
                            
                            // 延迟后返回上一页
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }) {
                            Text("保存记录")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedCategory.color)
                                .cornerRadius(16)
                        }
                        .padding(.vertical)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
            .overlay(
                Group {
                    if showingSuccessMessage {
                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                            
                            Text("记录已保存")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        .padding(24)
                        .background(Color(.systemBackground))
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            )
            .navigationTitle("健康记录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // 查看历史记录
                    }) {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
    }
    
    // 根据类别获取单位
    private func getUnit(for category: RecordCategory) -> String {
        switch category {
        case .bloodPressure: return "mmHg"
        case .heartRate: return "bpm"
        case .bloodSugar: return "mmol/L"
        case .weight: return "kg"
        case .medication: return "mg"
        case .symptoms: return ""
        case .diet: return "kcal"
        case .exercise: return "分钟"
        }
    }
}

// 预览
struct HealthRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        HealthRecordingView()
    }
}
