import SwiftUI

struct MedicationView: View {
    @State private var showingAddMedication = false
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 标签选择器
                Picker("", selection: $selectedTab) {
                    Text("今日").tag(0)
                    Text("全部").tag(1)
                }
                .pickerStyle(.segmented)
                .padding()
                
                if selectedTab == 0 {
                    TodayMedicationsView()
                } else {
                    AllMedicationsView()
                }
            }
            .navigationTitle("用药提醒")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddMedication = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddMedication) {
                AddMedicationView()
            }
        }
    }
}

struct TodayMedicationsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 今日用药概览
                TodayOverviewCard()
                
                // 待服用药物
                UpcomingMedicationsCard()
                
                // 已服用药物
                TakenMedicationsCard()
            }
            .padding()
        }
    }
}

struct TodayOverviewCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("今日概览")
                .font(.headline)
            
            HStack(spacing: 20) {
                StatView(title: "待服用", value: "3", icon: "clock.fill", color: .orange)
                StatView(title: "已服用", value: "2", icon: "checkmark.circle.fill", color: .green)
                StatView(title: "已跳过", value: "0", icon: "xmark.circle.fill", color: .red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct StatView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .bold()
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct UpcomingMedicationsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("待服用")
                .font(.headline)
            
            ForEach(1...3, id: \.self) { _ in
                MedicationRow(
                    name: "降压药",
                    dosage: "1片",
                    time: "12:00",
                    isTaken: false
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct TakenMedicationsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("已服用")
                .font(.headline)
            
            ForEach(1...2, id: \.self) { _ in
                MedicationRow(
                    name: "降糖药",
                    dosage: "1片",
                    time: "08:00",
                    isTaken: true
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct MedicationRow: View {
    let name: String
    let dosage: String
    let time: String
    let isTaken: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text(dosage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(time)
                    .font(.headline)
                    .foregroundColor(isTaken ? .green : .blue)
                
                if isTaken {
                    Text("已服用")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct AllMedicationsView: View {
    var body: some View {
        List {
            ForEach(1...5, id: \.self) { _ in
                MedicationDetailRow()
            }
        }
    }
}

struct MedicationDetailRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("降压药")
                        .font(.headline)
                    Text("每天 2 次")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            
            HStack {
                ForEach(["早餐后", "晚餐后"], id: \.self) { time in
                    Text(time)
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

struct AddMedicationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var medicationName = ""
    @State private var dosage = ""
    @State private var frequency = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var notes = ""
    @State private var selectedTimes: Set<Date> = []
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本信息")) {
                    TextField("药物名称", text: $medicationName)
                    TextField("剂量", text: $dosage)
                    TextField("服用频率", text: $frequency)
                }
                
                Section(header: Text("服用时间")) {
                    DatePicker("开始日期", selection: $startDate, displayedComponents: .date)
                    DatePicker("结束日期", selection: $endDate, displayedComponents: .date)
                    
                    ForEach(1...3, id: \.self) { _ in
                        DatePicker("时间", selection: .constant(Date()), displayedComponents: .hourAndMinute)
                    }
                }
                
                Section(header: Text("备注")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("添加用药")
            .navigationBarItems(
                leading: Button("取消") {
                    dismiss()
                },
                trailing: Button("保存") {
                    // 保存用药信息
                    dismiss()
                }
            )
        }
    }
}

#Preview {
    MedicationView()
} 