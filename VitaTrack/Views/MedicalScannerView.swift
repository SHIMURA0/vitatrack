//
//  MedicalScannerView.swift
//  VitaTrack
//
//  Created by Riemann on 2025/5/7.
//

import SwiftUI
import AVFoundation

struct MedicalScannerView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var scannerModel = ScannerViewModel()
    @State private var showingManualInput = false
    @State private var showingHistory = false
    @State private var showingScanResult = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // 相机背景层
                CameraPreviewLayer(scannerModel: scannerModel)
                    .ignoresSafeArea()
                
                // 扫描UI层
                VStack(spacing: 0) {
                    // 中间扫描区域（弹性占据大部分空间）
                    Spacer()
                    
                    // 扫描识别状态文本
                    scanStatusText
                    
                    // 底部控制区域
                    bottomControlArea
                }
                
                // 扫描框覆盖层
                scannerOverlay
                
                // 扫描结果层
                if showingScanResult {
                    scanResultOverlay
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("医疗扫描")
            .toolbar {
                // 左侧关闭按钮
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("关闭") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                // 右侧历史记录按钮
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingHistory = true
                    }) {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(.white)
                    }
                }
            }
            .toolbarBackground(Color.black.opacity(0.6), for: .navigationBar) // iOS 16+
            .toolbarBackground(.visible, for: .navigationBar) // iOS 16+
        }
        .accentColor(.white) // 设置导航栏文本颜色
        .onAppear {
            scannerModel.setupCamera()
            scannerModel.startScanning()
            // 添加调试信息
            print("扫描页面已出现")
        }
        .onDisappear {
            scannerModel.stopScanning()
        }
        .sheet(isPresented: $showingManualInput) {
            ManualInputView(onSubmit: { code in
                handleManualInput(code)
            })
        }
        .sheet(isPresented: $showingHistory) {
            ScanHistoryView(history: scannerModel.scanHistory)
        }
        .onChange(of: scannerModel.lastDetectedCode) { newCode in
            if let code = newCode, !code.isEmpty {
                handleScannedCode(code)
            }
        }
    }
    
    // MARK: - UI Components
    
    // 扫描类型选择器
    var scanTypeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(ScanType.allCases, id: \.self) { type in
                    Button(action: {
                        withAnimation {
                            scannerModel.selectedScanType = type
                        }
                    }) {
                        VStack(spacing: 6) {
                            Image(systemName: type.iconName)
                                .font(.system(size: 20))
                                .foregroundColor(scannerModel.selectedScanType == type ? .white : .white.opacity(0.7))
                            
                            Text(type.displayName)
                                .font(.caption)
                                .foregroundColor(scannerModel.selectedScanType == type ? .white : .white.opacity(0.7))
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(scannerModel.selectedScanType == type ? type.color : Color.black.opacity(0.3))
                        )
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .background(Color.black.opacity(0.3))
    }
    
    // 扫描状态文本
    var scanStatusText: some View {
        Text(scanStatusMessage)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding(.bottom, 20)
    }
    
    // 底部控制区域 - 修改后的版本，将类型选择器移至上方
    var bottomControlArea: some View {
        ZStack {
            // 背景渐变
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 240) // 增加高度以适应新的布局
            
            VStack(spacing: 16) {
                // 扫描类型选择器 - 现在放在顶部
                scanTypeSelector
                
                // 控制按钮组
                HStack(spacing: 40) {
                    // 相册按钮
                    ControlButton(
                        icon: "photo",
                        label: "相册",
                        action: {
                            // 添加反馈
                            print("相册按钮点击")
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            
                            // 模拟从相册获取一个代码
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                scannerModel.lastDetectedCode = "PHOTO_CODE_\(Int.random(in: 10000...99999))"
                            }
                        }
                    )
                    
                    // 主扫描按钮
                    ZStack {
                        Circle()
                            .fill(scannerModel.selectedScanType.color)
                            .frame(width: 70, height: 70)
                            .shadow(color: scannerModel.selectedScanType.color.opacity(0.5), radius: 10, x: 0, y: 0)
                        
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 76, height: 76)
                        
                        Button(action: {
                            // 添加反馈
                            print("扫描按钮点击")
                            let generator = UIImpactFeedbackGenerator(style: .heavy)
                            generator.impactOccurred()
                            
                            // 如果已经在捕获中，则停止
                            if scannerModel.isCapturing {
                                scannerModel.isCapturing = false
                                return
                            }
                            
                            // 开始捕获
                            scannerModel.captureImage()
                        }) {
                            Image(systemName: scannerModel.isCapturing ? "stop.fill" : "camera.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                        .frame(width: 70, height: 70)
                    }
                    
                    // 手动输入按钮
                    ControlButton(
                        icon: "keyboard",
                        label: "手动输入",
                        action: {
                            // 添加反馈
                            print("手动输入按钮点击")
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            
                            showingManualInput = true
                        }
                    )
                }
                
                // 提示文本
                Text(getTipForScanType(scannerModel.selectedScanType))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
            }
        }
    }
    
    // 扫描覆盖层
    var scannerOverlay: some View {
        GeometryReader { geometry in
            ZStack {
                // 四角边框
                ScannerCorners(
                    rectSize: getScanRectSize(in: geometry),
                    color: scannerModel.selectedScanType.color
                )
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
                
                // 扫描线
                if scannerModel.isScanning {
                    ScannerAnimationLine(
                        rectSize: getScanRectSize(in: geometry),
                        color: scannerModel.selectedScanType.color
                    )
                    .position(
                        x: geometry.size.width / 2,
                        y: geometry.size.height / 2
                    )
                }
            }
        }
    }
    
    // 扫描结果覆盖层
    var scanResultOverlay: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景遮罩
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showingScanResult = false
                            scannerModel.resetScan()
                        }
                    }
                
                // 结果卡片
                VStack(spacing: 0) {
                    // 顶部颜色标签
                    HStack {
                        Text(scannerModel.scanResult?.type.displayName ?? "")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(scannerModel.scanResult?.type.color ?? Color.blue)
                    .cornerRadius(12, corners: [.topLeft, .topRight])
                    
                    // 内容区域
                    VStack(alignment: .leading, spacing: 16) {
                        // 标题和图标
                        HStack {
                            Image(systemName: scannerModel.scanResult?.type.iconName ?? "doc.text")
                                .font(.system(size: 24))
                                .foregroundColor(scannerModel.scanResult?.type.color ?? .blue)
                            
                            Text(scannerModel.scanResult?.title ?? "未识别内容")
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            if scannerModel.isAnalyzing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            }
                        }
                        
                        Divider()
                        
                        // 详细内容
                        if let result = scannerModel.scanResult {
                            ScanResultDetailView(result: result)
                        } else {
                            Text("无法识别扫描内容")
                                .foregroundColor(.secondary)
                        }
                        
                        // 操作按钮
                        HStack(spacing: 16) {
                            ResultActionButton(
                                title: "保存",
                                icon: "square.and.arrow.down",
                                color: .blue,
                                action: {
                                    scannerModel.saveScanResult()
                                }
                            )
                            
                            ResultActionButton(
                                title: "分享",
                                icon: "square.and.arrow.up",
                                color: .green,
                                action: {
                                    scannerModel.shareScanResult()
                                }
                            )
                            
                            if scannerModel.scanResult?.type == .medicine {
                                ResultActionButton(
                                    title: "添加用药",
                                    icon: "pills",
                                    color: .purple,
                                    action: {
                                        scannerModel.addToMedication()
                                    }
                                )
                            } else if scannerModel.scanResult?.type == .labReport {
                                ResultActionButton(
                                    title: "查看详情",
                                    icon: "chart.xyaxis.line",
                                    color: .orange,
                                    action: {
                                        scannerModel.viewDetailedReport()
                                    }
                                )
                            }
                        }
                        
                        // 关闭按钮
                        Button(action: {
                            withAnimation(.spring()) {
                                showingScanResult = false
                                scannerModel.resetScan()
                            }
                        }) {
                            Text("关闭")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray5))
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
                }
                .frame(width: min(geometry.size.width - 40, 400))
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
                .transition(.scale(scale: 0.9).combined(with: .opacity))
            }
        }
    }
    
    // MARK: - Helper Functions
    
    // 获取扫描状态消息
    var scanStatusMessage: String {
        if scannerModel.isAnalyzing {
            return "正在分析内容..."
        } else if scannerModel.isCapturing {
            return "捕捉图像中..."
        } else {
            return "将\(scannerModel.selectedScanType.displayName)放入框内，自动扫描"
        }
    }
    
    // 获取扫描框大小
    func getScanRectSize(in geometry: GeometryProxy) -> CGSize {
        let width = min(geometry.size.width * 0.8, 300)
        let height = scannerModel.selectedScanType == .medicine ? width : (width * 1.4)
        return CGSize(width: width, height: height)
    }
    
    // 根据扫描类型获取提示文本
    func getTipForScanType(_ type: ScanType) -> String {
        switch type {
        case .medicine:
            return "扫描药品包装上的条形码或二维码，获取药品信息和使用说明"
        case .labReport:
            return "扫描检验报告上的二维码，自动解析并保存检验结果"
        case .medicalCard:
            return "扫描医保卡或就诊卡，快速获取个人医疗信息"
        case .deviceCode:
            return "扫描医疗设备条码，了解设备信息并关联个人设备"
        case .prescription:
            return "扫描处方单，自动识别药品名称、用法用量"
        }
    }
    
    // 处理扫描到的代码
    func handleScannedCode(_ code: String) {
        // 模拟处理结果
        scannerModel.analyzeScannedCode(code)
        
        // 显示结果
        withAnimation(.spring()) {
            showingScanResult = true
        }
    }
    
    // 处理手动输入
    func handleManualInput(_ code: String) {
        handleScannedCode(code)
    }
}

// MARK: - 支持视图

// 相机预览层
struct CameraPreviewLayer: View {
    @ObservedObject var scannerModel: ScannerViewModel
    
    var body: some View {
        ZStack {
            // 在实际应用中，这里会是实际的相机预览视图
            // 在设计阶段，使用深色背景模拟
            Color.black
                .overlay(
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 100))
                        .foregroundColor(.white.opacity(0.1))
                )
            
            // 测试模式指示
            VStack {
                Text("📱 测试模式")
                    .font(.caption)
                    .padding(6)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(4)
                
                Spacer()
            }
            .padding(.top, 120)
        }
    }
}

// 扫描框四角
struct ScannerCorners: View {
    let rectSize: CGSize
    let color: Color
    let cornerLength: CGFloat = 30
    let lineWidth: CGFloat = 5
    
    var body: some View {
        ZStack {
            // 透明区域蒙版
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .mask(
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        .overlay(
                            Rectangle()
                                .frame(width: rectSize.width, height: rectSize.height)
                                .blendMode(.destinationOut)
                        )
                )
            
            // 左上角
            Path { path in
                path.move(to: CGPoint(x: -rectSize.width/2, y: -rectSize.height/2 + cornerLength))
                path.addLine(to: CGPoint(x: -rectSize.width/2, y: -rectSize.height/2))
                path.addLine(to: CGPoint(x: -rectSize.width/2 + cornerLength, y: -rectSize.height/2))
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
            
            // 右上角
            Path { path in
                path.move(to: CGPoint(x: rectSize.width/2 - cornerLength, y: -rectSize.height/2))
                path.addLine(to: CGPoint(x: rectSize.width/2, y: -rectSize.height/2))
                path.addLine(to: CGPoint(x: rectSize.width/2, y: -rectSize.height/2 + cornerLength))
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
            
            // 左下角
            Path { path in
                path.move(to: CGPoint(x: -rectSize.width/2, y: rectSize.height/2 - cornerLength))
                path.addLine(to: CGPoint(x: -rectSize.width/2, y: rectSize.height/2))
                path.addLine(to: CGPoint(x: -rectSize.width/2 + cornerLength, y: rectSize.height/2))
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
            
            // 右下角
            Path { path in
                path.move(to: CGPoint(x: rectSize.width/2 - cornerLength, y: rectSize.height/2))
                path.addLine(to: CGPoint(x: rectSize.width/2, y: rectSize.height/2))
                path.addLine(to: CGPoint(x: rectSize.width/2, y: rectSize.height/2 - cornerLength))
            }
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
        }
    }
}

// 扫描动画线
struct ScannerAnimationLine: View {
    let rectSize: CGSize
    let color: Color
    @State private var animationY: CGFloat = 0
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [color.opacity(0), color.opacity(0.8), color.opacity(0)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: rectSize.width, height: 2)
            .offset(y: animationY)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true)
                ) {
                    animationY = rectSize.height / 2 - 10
                }
            }
            .offset(y: -rectSize.height / 2)
    }
}

// 控制按钮
struct ControlButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .scaleEffect(isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 10, pressing: { pressing in
            self.isPressed = pressing
        }, perform: {})
    }
}

// 结果操作按钮
struct ResultActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// 扫描结果详情视图
struct ScanResultDetailView: View {
    let result: ScanResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if result.type == .medicine {
                // 药品信息
                Group {
                    InfoRow(title: "药品名称", value: result.title)
                    InfoRow(title: "规格", value: result.details["规格"] ?? "")
                    InfoRow(title: "生产企业", value: result.details["生产企业"] ?? "")
                    InfoRow(title: "批准文号", value: result.details["批准文号"] ?? "")
                }
            } else if result.type == .labReport {
                // 化验单信息
                Group {
                    InfoRow(title: "检查项目", value: result.title)
                    InfoRow(title: "检查时间", value: result.details["检查时间"] ?? "")
                    InfoRow(title: "检查结果", value: result.details["检查结果"] ?? "")
                    
                    if let abnormalItems = result.details["异常项目"] {
                        Text("异常项目")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(abnormalItems)
                            .font(.body)
                            .foregroundColor(.red)
                            .padding(8)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
            } else {
                // 其他类型的通用展示
                ForEach(result.details.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                    InfoRow(title: key, value: value)
                }
            }
        }
    }
}

// 信息行
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.body)
        }
    }
}

// 手动输入视图
struct ManualInputView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var inputCode: String = ""
    let onSubmit: (String) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // 图标
                Image(systemName: "keyboard")
                    .font(.system(size: 60))
                    .foregroundColor(.accentColor)
                    .padding(.top, 40)
                
                // 标题
                Text("手动输入")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // 说明
                Text("请输入药品条形码或检验单上的编码")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // 输入框
                TextField("输入条码或编码", text: $inputCode)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .keyboardType(.asciiCapable)
                    .padding(.horizontal)
                
                // 提交按钮
                Button(action: {
                    if !inputCode.isEmpty {
                        onSubmit(inputCode)
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("确认")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(inputCode.isEmpty ? Color.gray : Color.accentColor)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(inputCode.isEmpty)
                
                Spacer()
            }
            .navigationBarTitle("", displayMode: .inline)
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
}

// 扫描历史视图
struct ScanHistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    let history: [ScanResult]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(history) { result in
                    ScanHistoryRow(result: result)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("扫描历史")
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
}

// 扫描历史行
struct ScanHistoryRow: View {
    let result: ScanResult
    
    var body: some View {
        HStack(spacing: 16) {
            // 图标
            ZStack {
                Circle()
                    .fill(result.type.color.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: result.type.iconName)
                    .font(.system(size: 22))
                    .foregroundColor(result.type.color)
            }
            
            // 内容
            VStack(alignment: .leading, spacing: 4) {
                Text(result.title)
                    .font(.headline)
                
                Text(result.scanTime.formatted())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Model & View Model

// 扫描类型
enum ScanType: CaseIterable {
    case medicine, labReport, medicalCard, deviceCode, prescription
    
    var displayName: String {
        switch self {
        case .medicine: return "药品"
        case .labReport: return "化验单"
        case .medicalCard: return "医疗卡"
        case .deviceCode: return "医疗设备"
        case .prescription: return "处方"
        }
    }
    
    var iconName: String {
        switch self {
        case .medicine: return "pills.fill"
        case .labReport: return "doc.text.fill"
        case .medicalCard: return "person.crop.rectangle.fill"
        case .deviceCode: return "waveform.path.ecg"
        case .prescription: return "list.bullet.rectangle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .medicine: return .blue
        case .labReport: return .orange
        case .medicalCard: return .green
        case .deviceCode: return .purple
        case .prescription: return .red
        }
    }
}

// 扫描结果
struct ScanResult: Identifiable {
    let id = UUID()
    let type: ScanType
    let title: String
    var details: [String: String]
    let scanTime: Date
    let rawCode: String
}

// 扫描器视图模型
class ScannerViewModel: ObservableObject {
    @Published var isScanning: Bool = true
    @Published var isCapturing: Bool = false
    @Published var isAnalyzing: Bool = false
    @Published var selectedScanType: ScanType = .medicine
    @Published var lastDetectedCode: String?
    @Published var scanResult: ScanResult?
    @Published var scanHistory: [ScanResult] = []
    
    // 模拟历史记录
    init() {
        self.scanHistory = [
            ScanResult(
                type: .medicine,
                title: "阿司匹林肠溶片",
                details: [
                    "规格": "100mg*30片",
                    "生产企业": "拜耳医药保健有限公司",
                    "批准文号": "国药准字H20065050"
                ],
                scanTime: Date().addingTimeInterval(-86400),
                rawCode: "6923685111575"
            ),
            ScanResult(
                type: .labReport,
                title: "血常规检查",
                details: [
                    "检查时间": "2023-05-05",
                    "检查结果": "异常",
                    "异常项目": "白细胞计数略高"
                ],
                scanTime: Date().addingTimeInterval(-172800),
                rawCode: "QR12345678"
            )
        ]
    }
    
    // 设置相机
    func setupCamera() {
        // 在实际应用中，这里会设置AVCaptureSession
        print("设置相机")
    }
    
    // 开始扫描
    func startScanning() {
        isScanning = true
    }
    
    // 停止扫描
    func stopScanning() {
        isScanning = false
    }
    
    // 捕获图像
    func captureImage() {
        isCapturing = true
        
        // 模拟捕获过程
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isCapturing = false
            
            // 模拟检测到二维码
            self.lastDetectedCode = "SAMPLE_CODE_\(Int.random(in: 10000...99999))"
        }
    }
    
    // 打开相册
    func openPhotoLibrary() {
        // 在实际应用中，这里会打开UIImagePickerController
        print("打开相册")
    }
    
    // 分析扫描的代码
    func analyzeScannedCode(_ code: String) {
        isAnalyzing = true
        
        // 模拟分析过程
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isAnalyzing = false
            
            // 根据扫描类型创建不同的示例结果
            switch self.selectedScanType {
            case .medicine:
                self.scanResult = ScanResult(
                    type: .medicine,
                    title: "氨氯地平贝那普利片",
                    details: [
                        "规格": "5mg/10mg*7片",
                        "生产企业": "诺华制药",
                        "批准文号": "国药准字H20030123",
                        "适应症": "用于高血压治疗",
                        "用法用量": "口服，每日一次，每次1片",
                        "有效期": "24个月"
                    ],
                    scanTime: Date(),
                    rawCode: code
                )
            case .labReport:
                self.scanResult = ScanResult(
                    type: .labReport,
                    title: "生化全项",
                    details: [
                        "检查时间": "2023-05-07",
                        "检查单位": "首都医科大学附属北京朝阳医院",
                        "检查结果": "部分异常",
                        "异常项目": "总胆固醇(TC): 5.28 mmol/L↑\n甘油三酯(TG): 2.35 mmol/L↑",
                        "检验医师": "张医生"
                    ],
                    scanTime: Date(),
                    rawCode: code
                )
            case .medicalCard:
                self.scanResult = ScanResult(
                    type: .medicalCard,
                    title: "北京医保卡",
                    details: [
                        "姓名": "王小明",
                        "卡号": "1100123456789",
                        "身份证号": "1101**********1234",
                        "医保类型": "职工医保"
                    ],
                    scanTime: Date(),
                    rawCode: code
                )
            case .deviceCode:
                self.scanResult = ScanResult(
                    type: .deviceCode,
                    title: "欧姆龙电子血压计",
                    details: [
                        "型号": "HEM-7136",
                        "序列号": "SN20230501789",
                        "生产日期": "2023-01-15",
                        "注册证号": "国械注准20153540555"
                    ],
                    scanTime: Date(),
                    rawCode: code
                )
            case .prescription:
                self.scanResult = ScanResult(
                    type: .prescription,
                    title: "门诊处方",
                    details: [
                        "处方号": "RX2023050700123",
                        "医院": "北京协和医院",
                        "开方医生": "李医生",
                        "开方日期": "2023-05-07",
                        "药品清单": "1. 苯磺酸氨氯地平片 5mg 30片\n2. 阿托伐他汀钙片 20mg 7片"
                    ],
                    scanTime: Date(),
                    rawCode: code
                )
            }
            
            // 添加到历史记录
            if let result = self.scanResult {
                self.scanHistory.insert(result, at: 0)
            }
        }
    }
    
    // 保存扫描结果
    func saveScanResult() {
        // 实际应用中，这里会将结果保存到数据库
        print("保存结果: \(scanResult?.title ?? "")")
    }
    
    // 分享扫描结果
    func shareScanResult() {
        // 实际应用中，这里会调用UIActivityViewController
        print("分享结果: \(scanResult?.title ?? "")")
    }
    
    // 添加到用药管理
    func addToMedication() {
        // 实际应用中，这里会添加到用药管理模块
        print("添加到用药管理: \(scanResult?.title ?? "")")
    }
    
    // 查看详细报告
    func viewDetailedReport() {
        // 实际应用中，这里会导航到详细报告页面
        print("查看详细报告: \(scanResult?.title ?? "")")
    }
    
    // 重置扫描
    func resetScan() {
        lastDetectedCode = nil
        scanResult = nil
    }
}

// MARK: - Extensions

// 圆角扩展
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCornerShape(radius: radius, corners: corners))
    }
}

// 圆角形状
struct RoundedCornerShape: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview
struct MedicalScannerView_Previews: PreviewProvider {
    static var previews: some View {
        MedicalScannerView()
    }
}
