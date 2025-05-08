//
//  RemaindersView.swift
//  VitaTrack
//
//  Created by Riemann on 2025/5/8.
//

import SwiftUI

// 提醒管理视图
struct RemindersView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    @State private var showingAddReminder = false
    
    // 示例提醒数据
    @State private var reminders = [
        ReminderItem(id: 1, title: "降压药", description: "每天两次", time: "8:00, 20:00", type: .medication, date: Date(), isCompleted: false),
        ReminderItem(id: 2, title: "血糖检测", description: "空腹", time: "7:30", type: .measurement, date: Date(), isCompleted: true),
        ReminderItem(id: 3, title: "心内科复诊", description: "市第一医院", time: "14:30", type: .appointment, date: Date().addingTimeInterval(86400), isCompleted: false),
        ReminderItem(id: 4, title: "服用维生素", description: "每天一次", time: "12:00", type: .medication, date: Date(), isCompleted: false),
        ReminderItem(id: 5, title: "散步", description: "30分钟", time: "18:00", type: .exercise, date: Date(), isCompleted: false)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 顶部分段控制器
                Picker("提醒类型", selection: $selectedTab) {
                    Text("今日").tag(0)
                    Text("待办").tag(1)
                    Text("已完成").tag(2)
                    Text("全部").tag(3)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // 提醒列表
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredReminders) { reminder in
                            ReminderItemView(reminder: reminder) {
                                toggleReminderCompletion(reminder)
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("提醒管理")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("关闭") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddReminder = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddReminder) {
                AddReminderView(isPresented: $showingAddReminder, onSave: addNewReminder)
            }
        }
    }
    
    // 根据所选标签过滤提醒
    var filteredReminders: [ReminderItem] {
        let calendar = Calendar.current
        switch selectedTab {
        case 0: // 今日
            return reminders.filter { calendar.isDateInToday($0.date) }
        case 1: // 待办
            return reminders.filter { !$0.isCompleted }
        case 2: // 已完成
            return reminders.filter { $0.isCompleted }
        default: // 全部
            return reminders
        }
    }
    
    // 切换提醒完成状态
    func toggleReminderCompletion(_ reminder: ReminderItem) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index].isCompleted.toggle()
        }
    }
    
    // 添加新提醒
    func addNewReminder(_ reminder: ReminderItem) {
        reminders.append(reminder)
    }
}

// 提醒项目视图
struct ReminderItemView: View {
    let reminder: ReminderItem
    let onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // 提醒类型图标
            ZStack {
                Circle()
                    .fill(reminderTypeColor.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: reminderTypeIcon)
                    .font(.system(size: 22))
                    .foregroundColor(reminderTypeColor)
            }
            
            // 提醒内容
            VStack(alignment: .leading, spacing: 4) {
                Text(reminder.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(reminder.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(reminder.time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if !Calendar.current.isDateInToday(reminder.date) {
                        Text("・\(formattedDate)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            // 完成按钮
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .stroke(reminder.isCompleted ? Color.green : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 28, height: 28)
                    
                    if reminder.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 6, x: 0, y: 3)
    }
    
    // 根据提醒类型返回对应图标
    var reminderTypeIcon: String {
        switch reminder.type {
        case .medication: return "pills.fill"
        case .measurement: return "waveform.path.ecg"
        case .appointment: return "calendar.badge.clock"
        case .exercise: return "figure.walk"
        case .other: return "bell.fill"
        }
    }
    
    // 根据提醒类型返回对应颜色
    var reminderTypeColor: Color {
        switch reminder.type {
        case .medication: return .red
        case .measurement: return .purple
        case .appointment: return .green
        case .exercise: return .blue
        case .other: return .orange
        }
    }
    
    // 格式化日期显示
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        return formatter.string(from: reminder.date)
    }
}

// 添加提醒视图
struct AddReminderView: View {
    @Binding var isPresented: Bool
    let onSave: (ReminderItem) -> Void
    
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var time = Date()
    @State private var selectedType: ReminderType = .medication
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("提醒信息")) {
                    TextField("标题", text: $title)
                    TextField("描述", text: $description)
                }
                
                Section(header: Text("时间")) {
                    DatePicker("日期", selection: $date, displayedComponents: .date)
                    DatePicker("时间", selection: $time, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("类型")) {
                    Picker("提醒类型", selection: $selectedType) {
                        Text("用药提醒").tag(ReminderType.medication)
                        Text("检测提醒").tag(ReminderType.measurement)
                        Text("就诊提醒").tag(ReminderType.appointment)
                        Text("锻炼提醒").tag(ReminderType.exercise)
                        Text("其他提醒").tag(ReminderType.other)
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section {
                    Button("设置重复") {
                        // 设置重复逻辑
                    }
                }
                
                Section {
                    Button("保存提醒") {
                        saveReminder()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.accentColor)
                }
            }
            .navigationTitle("新增提醒")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    // 保存提醒
    func saveReminder() {
        // 合并日期和时间
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute], from: time)
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        let combinedDate = calendar.date(from: dateComponents) ?? Date()
        
        // 格式化时间
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let timeString = formatter.string(from: combinedDate)
        
        // 创建新提醒
        let newReminder = ReminderItem(
            id: Int.random(in: 100...10000),
            title: title,
            description: description,
            time: timeString,
            type: selectedType,
            date: combinedDate,
            isCompleted: false
        )
        
        onSave(newReminder)
        isPresented = false
    }
}

// 提醒数据模型
struct ReminderItem: Identifiable {
    let id: Int
    let title: String
    let description: String
    let time: String
    let type: ReminderType
    let date: Date
    var isCompleted: Bool
}

// 提醒类型枚举
enum ReminderType {
    case medication
    case measurement
    case appointment
    case exercise
    case other
}

#Preview{
    RemindersView()
}
