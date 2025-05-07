import SwiftUI

struct MedicalRecordsView: View {
    @State private var searchText = ""
    @State private var showingAddRecord = false
    
    var body: some View {
        NavigationView {
            List {
                // 按科室分类的病历
                Section(header: Text("按科室")) {
                    ForEach(Department.allCases, id: \.self) { department in
                        NavigationLink(destination: DepartmentRecordsView(department: department)) {
                            DepartmentRow(department: department)
                        }
                    }
                }
                
                // 最近病历
                Section(header: Text("最近病历")) {
                    ForEach(1...3, id: \.self) { _ in
                        RecentRecordRow()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "搜索病历")
            .navigationTitle("病历管理")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddRecord = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddRecord) {
                AddRecordView()
            }
        }
    }
}

enum Department: String, CaseIterable {
    case cardiology = "心内科"
    case neurology = "神经内科"
    case orthopedics = "骨科"
    case pediatrics = "儿科"
    case gynecology = "妇科"
    case dermatology = "皮肤科"
    case ophthalmology = "眼科"
    case dentistry = "口腔科"
    
    var icon: String {
        switch self {
        case .cardiology: return "heart.fill"
        case .neurology: return "brain.head.profile"
        case .orthopedics: return "figure.stand"
        case .pediatrics: return "figure.child"
        case .gynecology: return "figure.dress.line.vertical.figure"
        case .dermatology: return "hand.raised.fill"
        case .ophthalmology: return "eye.fill"
        case .dentistry: return "mouth.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .cardiology: return .red
        case .neurology: return .purple
        case .orthopedics: return .orange
        case .pediatrics: return .green
        case .gynecology: return .pink
        case .dermatology: return .yellow
        case .ophthalmology: return .blue
        case .dentistry: return .mint
        }
    }
}

struct DepartmentRow: View {
    let department: Department
    
    var body: some View {
        HStack {
            Image(systemName: department.icon)
                .foregroundColor(department.color)
                .font(.title2)
                .frame(width: 40)
            
            Text(department.rawValue)
                .font(.body)
            
            Spacer()
            
            Text("3份")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

struct RecentRecordRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("高血压复诊")
                    .font(.headline)
                Spacer()
                Text("2024-03-15")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text("张医生 - 心内科")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("血压控制良好，建议继续服用当前药物，注意监测血压。")
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

struct DepartmentRecordsView: View {
    let department: Department
    
    var body: some View {
        List {
            ForEach(1...5, id: \.self) { _ in
                RecordDetailRow()
            }
        }
        .navigationTitle(department.rawValue)
    }
}

struct RecordDetailRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("复诊记录")
                    .font(.headline)
                Spacer()
                Text("2024-03-15")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text("张医生")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("患者血压控制良好，建议继续服用当前药物，注意监测血压。")
                .font(.body)
                .foregroundColor(.secondary)
            
            HStack {
                ForEach(["处方", "检查单", "医嘱"], id: \.self) { tag in
                    Text(tag)
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

struct AddRecordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedDepartment: Department = .cardiology
    @State private var doctorName = ""
    @State private var visitDate = Date()
    @State private var diagnosis = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    Picker("科室", selection: $selectedDepartment) {
                        ForEach(Department.allCases, id: \.self) { department in
                            Text(department.rawValue).tag(department)
                        }
                    }
                    
                    TextField("医生姓名", text: $doctorName)
                    
                    DatePicker("就诊日期", selection: $visitDate, displayedComponents: .date)
                }
                
                Section(header: Text("诊断信息")) {
                    TextField("诊断结果", text: $diagnosis)
                    
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
                
                Section {
                    Button("添加附件") {
                        // 添加附件功能
                    }
                }
            }
            .navigationTitle("添加病历")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    // 保存病历
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    MedicalRecordsView()
} 