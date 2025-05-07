//
//  DeviceManagementView.swift
//  VitaTrack
//
//  Created by Riemann on 2025/5/7.
//

import SwiftUI

struct DeviceManagementView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var deviceManager = DeviceManager()
    @State private var showingAddDevice = false
    @State private var showingDeviceDetail: Device? = nil
    @State private var selectedCategory: DeviceCategory = .all
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 设备类别选择器
                deviceCategorySelector
                
                // 设备列表
                if deviceManager.isSearching {
                    searchingDevicesView
                } else if filteredDevices.isEmpty {
                    emptyDevicesView
                } else {
                    deviceListView
                }
            }
            .navigationTitle("我的设备")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 关闭按钮
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
                
                // 添加设备按钮
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddDevice = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $showingAddDevice) {
                AddDeviceView(deviceManager: deviceManager)
            }
            .sheet(item: $showingDeviceDetail) { device in
                DeviceDetailView(device: device, deviceManager: deviceManager)
            }
        }
    }
    
    // MARK: - 子视图
    
    // 设备类别选择器
    var deviceCategorySelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(DeviceCategory.allCases, id: \.self) { category in
                    Button(action: {
                        withAnimation {
                            selectedCategory = category
                        }
                    }) {
                        HStack {
                            Image(systemName: category.iconName)
                                .font(.system(size: 14))
                            Text(category.displayName)
                                .font(.subheadline)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(selectedCategory == category ? Color.accentColor : Color(.systemGray5))
                        )
                        .foregroundColor(selectedCategory == category ? .white : .primary)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }
    
    // 设备列表视图
    var deviceListView: some View {
        List {
            // 已连接设备
            if !connectedDevices.isEmpty {
                Section(header: Text("已连接")) {
                    ForEach(connectedDevices) { device in
                        DeviceRow(device: device)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showingDeviceDetail = device
                            }
                    }
                }
            }
            
            // 已保存但未连接的设备
            if !savedDevices.isEmpty {
                Section(header: Text("已保存")) {
                    ForEach(savedDevices) { device in
                        DeviceRow(device: device)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showingDeviceDetail = device
                            }
                    }
                    .onDelete(perform: deleteDevice)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    // 正在搜索设备的视图
    var searchingDevicesView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // 加载动画
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 8)
                    .frame(width: 100, height: 100)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(Color.accentColor, lineWidth: 8)
                    .frame(width: 100, height: 100)
                    .rotationEffect(Angle(degrees: deviceManager.rotationDegrees))
                    .onAppear {
                        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                            deviceManager.rotationDegrees = 360
                        }
                    }
            }
            
            Text("正在搜索附近的设备...")
                .font(.headline)
            
            Text("请确保您的设备已开启并处于配对模式")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                deviceManager.isSearching = false
            }) {
                Text("取消")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray5))
                    )
            }
            .padding(.top, 20)
            
            Spacer()
        }
    }
    
    // 无设备时的空视图
    var emptyDevicesView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "applewatch.radiowaves.left.and.right")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            
            Text("没有\(selectedCategory == .all ? "" : selectedCategory.displayName)设备")
                .font(.headline)
            
            Text("点击右上角"+"按钮添加新的健康设备")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                showingAddDevice = true
            }) {
                Text("添加设备")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.accentColor)
                    )
            }
            .padding(.top, 20)
            
            Spacer()
        }
    }
    
    // MARK: - 计算属性
    
    // 根据类别筛选设备
    var filteredDevices: [Device] {
        if selectedCategory == .all {
            return deviceManager.devices
        } else {
            return deviceManager.devices.filter { $0.category == selectedCategory }
        }
    }
    
    // 已连接的设备
    var connectedDevices: [Device] {
        filteredDevices.filter { $0.isConnected }
    }
    
    // 已保存但未连接的设备
    var savedDevices: [Device] {
        filteredDevices.filter { !$0.isConnected }
    }
    
    // MARK: - 操作方法
    
    // 删除设备
    func deleteDevice(at offsets: IndexSet) {
        for index in offsets {
            if index < savedDevices.count {
                let deviceId = savedDevices[index].id
                deviceManager.removeDevice(withId: deviceId)
            }
        }
    }
}

// MARK: - 设备行
struct DeviceRow: View {
    let device: Device
    
    var body: some View {
        HStack(spacing: 16) {
            // 设备图标
            ZStack {
                Circle()
                    .fill(device.category.color.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: device.category.iconName)
                    .font(.system(size: 22))
                    .foregroundColor(device.category.color)
            }
            
            // 设备信息
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.headline)
                
                Text(device.model)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 连接状态
            if device.isConnected {
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    
                    Text("已连接")
                        .font(.caption)
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(Color.green.opacity(0.1))
                )
            } else if device.batteryLevel < 20 {
                // 电量低警告
                HStack(spacing: 4) {
                    Image(systemName: "battery.25")
                        .foregroundColor(.red)
                    
                    Text("\(device.batteryLevel)%")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            } else {
                // 显示电量
                HStack(spacing: 4) {
                    Image(systemName: getBatteryIcon(for: device.batteryLevel))
                        .foregroundColor(.secondary)
                    
                    Text("\(device.batteryLevel)%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
    
    // 根据电量选择电池图标
    private func getBatteryIcon(for level: Int) -> String {
        switch level {
        case 0...25:
            return "battery.25"
        case 26...50:
            return "battery.50"
        case 51...75:
            return "battery.75"
        default:
            return "battery.100"
        }
    }
}

// MARK: - 添加设备视图
struct AddDeviceView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var deviceManager: DeviceManager
    @State private var selectedCategory: DeviceCategory = .bloodPressure
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 设备类别选择
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(DeviceCategory.allCases.filter { $0 != .all }, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                VStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(selectedCategory == category ? category.color : category.color.opacity(0.1))
                                            .frame(width: 70, height: 70)
                                        
                                        Image(systemName: category.iconName)
                                            .font(.system(size: 30))
                                            .foregroundColor(selectedCategory == category ? .white : category.color)
                                    }
                                    
                                    Text(category.displayName)
                                        .font(.subheadline)
                                        .foregroundColor(selectedCategory == category ? category.color : .primary)
                                }
                                .padding(.vertical, 10)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                }
                
                Divider()
                
                // 设备列表
                ScrollView {
                    VStack(spacing: 16) {
                        // 厂商列表
                        ForEach(getManufacturers(for: selectedCategory), id: \.self) { manufacturer in
                            VStack(alignment: .leading, spacing: 12) {
                                Text(manufacturer)
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                // 该厂商的设备型号
                                ForEach(getDeviceModels(manufacturer: manufacturer, category: selectedCategory), id: \.self) { model in
                                    Button(action: {
                                        // 添加设备并开始搜索配对
                                        addDevice(manufacturer: manufacturer, model: model)
                                        deviceManager.isSearching = true
                                        presentationMode.wrappedValue.dismiss()
                                    }) {
                                        HStack {
                                            Image(systemName: selectedCategory.iconName)
                                                .font(.system(size: 18))
                                                .foregroundColor(selectedCategory.color)
                                                .frame(width: 40, height: 40)
                                                .background(
                                                    Circle()
                                                        .fill(selectedCategory.color.opacity(0.1))
                                                )
                                            
                                            Text(model)
                                                .font(.body)
                                                .foregroundColor(.primary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 12)
                                        .background(Color(.systemBackground))
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    if model != getDeviceModels(manufacturer: manufacturer, category: selectedCategory).last {
                                        Divider()
                                            .padding(.leading, 72)
                                    }
                                }
                            }
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        
                        // 手动添加设备
                        Button(action: {
                            // 手动添加设备逻辑
                        }) {
                            HStack {
                                Spacer()
                                
                                Text("没有找到您的设备？手动添加")
                                    .font(.subheadline)
                                    .foregroundColor(.accentColor)
                                
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                        .padding(.top, 8)
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.vertical)
                }
                .background(Color(.systemGray6))
            }
            .navigationTitle("添加新设备")
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
            }
        }
    }
    
    // 获取某类别下的厂商列表
    private func getManufacturers(for category: DeviceCategory) -> [String] {
        switch category {
        case .bloodPressure:
            return ["欧姆龙", "鱼跃", "小米", "松下", "乐心"]
        case .glucometer:
            return ["强生", "雅培", "三诺", "欧姆龙"]
        case .thermometer:
            return ["小米", "鱼跃", "华为", "欧姆龙"]
        case .scale:
            return ["小米", "华为", "乐心", "PICOOC"]
        case .pulseOximeter:
            return ["鱼跃", "康泰", "欧姆龙"]
        case .ecg:
            return ["Apple", "华为", "小米", "Withings"]
        case .all:
            return []
        }
    }
    
    // 获取某厂商下该类别的设备型号
    private func getDeviceModels(manufacturer: String, category: DeviceCategory) -> [String] {
        switch (manufacturer, category) {
        case ("欧姆龙", .bloodPressure):
            return ["HEM-7156", "HEM-7320", "HEM-8732T", "HEM-7136"]
        case ("小米", .bloodPressure):
            return ["iHealth 智能血压计", "米家血压计2", "米家血压计"]
        case ("欧姆龙", .glucometer):
            return ["HGM-114", "HGM-121"]
        case ("小米", .thermometer):
            return ["米家电子体温计", "米家红外体温计"]
        default:
            return ["标准型号", "高级型号", "专业型号"]
        }
    }
    
    // 添加设备
    private func addDevice(manufacturer: String, model: String) {
        let newDevice = Device(
            id: UUID().uuidString,
            name: "\(manufacturer) \(model)",
            model: model,
            manufacturer: manufacturer,
            category: selectedCategory,
            isConnected: false,
            batteryLevel: Int.random(in: 30...100),
            lastSyncDate: nil,
            macAddress: generateRandomMacAddress()
        )
        
        deviceManager.addDevice(newDevice)
    }
    
    // 生成随机MAC地址
    private func generateRandomMacAddress() -> String {
        let characters = "0123456789ABCDEF"
        var macAddress = ""
        
        for i in 0..<6 {
            let segment = String((0..<2).map { _ in characters.randomElement()! })
            macAddress += segment
            if i < 5 {
                macAddress += ":"
            }
        }
        
        return macAddress
    }
}

// MARK: - 设备详情视图
struct DeviceDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let device: Device
    @ObservedObject var deviceManager: DeviceManager
    @State private var showingReconnect = false
    @State private var showingRemoveConfirmation = false
    
    var body: some View {
        NavigationView {
            Form {
                // 设备信息
                Section(header: Text("设备信息")) {
                    DeviceInfoRow(title: "设备名称", value: device.name)
                    DeviceInfoRow(title: "型号", value: device.model)
                    DeviceInfoRow(title: "厂商", value: device.manufacturer)
                    DeviceInfoRow(title: "MAC地址", value: device.macAddress)
                }
                
                // 连接信息
                Section(header: Text("连接状态")) {
                    HStack {
                        Text("状态")
                        Spacer()
                        HStack(spacing: 4) {
                            Circle()
                                .fill(device.isConnected ? Color.green : Color.red)
                                .frame(width: 8, height: 8)
                            Text(device.isConnected ? "已连接" : "未连接")
                                .foregroundColor(device.isConnected ? .green : .red)
                        }
                    }
                    
                    DeviceInfoRow(title: "电池电量", value: "\(device.batteryLevel)%")
                    
                    if let lastSync = device.lastSyncDate {
                        DeviceInfoRow(title: "最后同步", value: lastSync.formatted())
                    }
                    
                    if !device.isConnected {
                        Button(action: {
                            showingReconnect = true
                            
                            // 模拟重新连接过程
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                deviceManager.connectDevice(withId: device.id)
                                showingReconnect = false
                            }
                        }) {
                            Text("重新连接")
                                .foregroundColor(.accentColor)
                        }
                    }
                }
                
                // 数据同步和设置
                Section(header: Text("数据与设置")) {
                    NavigationLink(destination: DeviceDataHistoryView(device: device)) {
                        Text("查看测量历史")
                    }
                    
                    NavigationLink(destination: DeviceSettingsView(device: device)) {
                        Text("设备设置")
                    }
                }
                
                // 删除设备
                Section {
                    Button(action: {
                        showingRemoveConfirmation = true
                    }) {
                        Text("移除设备")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle(device.name)
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
            }
            .overlay(
                Group {
                    if showingReconnect {
                        VStack(spacing: 20) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("正在连接设备...")
                                .font(.headline)
                        }
                        .padding(30)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                        )
                    }
                }
            )
            .alert(isPresented: $showingRemoveConfirmation) {
                Alert(
                    title: Text("移除设备"),
                    message: Text("确定要移除此设备吗？设备数据将保留，但您需要重新配对才能继续使用。"),
                    primaryButton: .destructive(Text("移除")) {
                        deviceManager.removeDevice(withId: device.id)
                        presentationMode.wrappedValue.dismiss()
                    },
                    secondaryButton: .cancel(Text("取消"))
                )
            }
        }
    }
}

// 信息行
struct DeviceInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

// 设备数据历史视图（占位）
struct DeviceDataHistoryView: View {
    let device: Device
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("暂无历史数据")
                .font(.headline)
            Text("使用设备测量后，数据将自动同步到这里")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            Spacer()
        }
        .navigationTitle("测量历史")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 设备设置视图（占位）
struct DeviceSettingsView: View {
    let device: Device
    
    var body: some View {
        List {
            Section(header: Text("通用设置")) {
                Toggle("自动同步数据", isOn: .constant(true))
                Toggle("低电量提醒", isOn: .constant(true))
            }
            
            Section(header: Text("个性化")) {
                TextField("设备名称", text: .constant(device.name))
            }
        }
        .navigationTitle("设备设置")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - 设备模型与管理器

// 设备类别
enum DeviceCategory: CaseIterable {
    case all, bloodPressure, glucometer, thermometer, scale, pulseOximeter, ecg
    
    var displayName: String {
        switch self {
        case .all: return "全部"
        case .bloodPressure: return "血压计"
        case .glucometer: return "血糖仪"
        case .thermometer: return "体温计"
        case .scale: return "体重秤"
        case .pulseOximeter: return "血氧仪"
        case .ecg: return "心电图"
        }
    }
    
    var iconName: String {
        switch self {
        case .all: return "heart.text.square"
        case .bloodPressure: return "heart.circle"
        case .glucometer: return "drop.circle"
        case .thermometer: return "thermometer"
        case .scale: return "scalemass"
        case .pulseOximeter: return "lungs"
        case .ecg: return "waveform.path.ecg"
        }
    }
    
    var color: Color {
        switch self {
        case .all: return .gray
        case .bloodPressure: return .red
        case .glucometer: return .blue
        case .thermometer: return .orange
        case .scale: return .purple
        case .pulseOximeter: return .indigo
        case .ecg: return .green
        }
    }
}

// 设备模型
struct Device: Identifiable {
    let id: String
    let name: String
    let model: String
    let manufacturer: String
    let category: DeviceCategory
    var isConnected: Bool
    var batteryLevel: Int
    var lastSyncDate: Date?
    let macAddress: String
}

// 设备管理器
class DeviceManager: ObservableObject {
    @Published var devices: [Device] = []
    @Published var isSearching: Bool = false
    @Published var rotationDegrees: Double = 0
    
    init() {
        // 添加示例设备
        devices = [
            Device(
                id: "1",
                name: "欧姆龙血压计",
                model: "HEM-7156",
                manufacturer: "欧姆龙",
                category: .bloodPressure,
                isConnected: true,
                batteryLevel: 85,
                lastSyncDate: Date().addingTimeInterval(-3600),
                macAddress: "B4:C3:D2:E1:F0:A9"
            ),
            Device(
                id: "2",
                name: "强生血糖仪",
                model: "OneTouch",
                manufacturer: "强生",
                category: .glucometer,
                isConnected: false,
                batteryLevel: 45,
                lastSyncDate: Date().addingTimeInterval(-86400),
                macAddress: "A1:B2:C3:D4:E5:F6"
            ),
            Device(
                id: "3",
                name: "小米体重秤",
                model: "体脂秤2",
                manufacturer: "小米",
                category: .scale,
                isConnected: false,
                batteryLevel: 12,
                lastSyncDate: Date().addingTimeInterval(-259200),
                macAddress: "F6:E5:D4:C3:B2:A1"
            )
        ]
    }
    
    // 添加设备
    func addDevice(_ device: Device) {
        devices.append(device)
    }
    
    // 删除设备
    func removeDevice(withId id: String) {
        devices.removeAll { $0.id == id }
    }
    
    // 连接设备
    func connectDevice(withId id: String) {
        if let index = devices.firstIndex(where: { $0.id == id }) {
            devices[index].isConnected = true
            devices[index].lastSyncDate = Date()
        }
    }
    
    // 断开设备连接
    func disconnectDevice(withId id: String) {
        if let index = devices.firstIndex(where: { $0.id == id }) {
            devices[index].isConnected = false
        }
    }
}

// MARK: - 预览
struct DeviceManagementView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceManagementView()
    }
}
