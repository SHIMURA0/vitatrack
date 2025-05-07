import SwiftUI

struct ReportsView: View {
    @State private var searchText = ""
    @State private var selectedCategory: ReportCategory = .all
    @State private var showingAddReport = false
    
    enum ReportCategory: String, CaseIterable {
        case all = "全部"
        case blood = "血液检查"
        case imaging = "影像检查"
        case ecg = "心电图"
        case ultrasound = "超声检查"
        case other = "其他"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 分类选择器
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(ReportCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                title: category.rawValue,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding()
                }
                
                // 报告列表
                List {
                    ForEach(1...5, id: \.self) { _ in
                        ReportRow()
                    }
                }
            }
            .searchable(text: $searchText, prompt: "搜索报告")
            .navigationTitle("检查报告")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddReport = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddReport) {
                AddReportView()
            }
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

struct ReportRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("血常规检查")
                        .font(.headline)
                    Text("2024-03-15")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            
            // 关键指标
            HStack(spacing: 20) {
                IndicatorView(title: "血红蛋白", value: "135", unit: "g/L", isNormal: true)
                IndicatorView(title: "白细胞", value: "6.5", unit: "10^9/L", isNormal: true)
                IndicatorView(title: "血小板", value: "250", unit: "10^9/L", isNormal: true)
            }
            
            // 标签
            HStack {
                ForEach(["血常规", "门诊"], id: \.self) { tag in
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

struct IndicatorView: View {
    let title: String
    let value: String
    let unit: String
    let isNormal: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.subheadline)
                    .bold()
                Text(unit)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !isNormal {
                Text("异常")
                    .font(.caption2)
                    .foregroundColor(.red)
            }
        }
    }
}

struct AddReportView: View {
    @Environment(\.dismiss) var dismiss
    @State private var reportType = ""
    @State private var reportDate = Date()
    @State private var hospital = ""
    @State private var department = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("检查类型", text: $reportType)
                    DatePicker("检查日期", selection: $reportDate, displayedComponents: .date)
                    TextField("医院", text: $hospital)
                    TextField("科室", text: $department)
                }
                
                Section(header: Text("检查结果")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
                
                Section {
                    Button("上传报告图片") {
                        // 上传图片功能
                    }
                }
            }
            .navigationTitle("添加报告")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    // 保存报告
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    ReportsView()
} 