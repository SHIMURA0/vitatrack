//
//  MedicalAssistanceView.swift
//  VitaTrack
//
//  Created by Riemann on 2025/5/10.
//



import SwiftUI

struct MedicalAssistanceView: View {
    @State private var searchText = ""
    @State private var showingAIAssistant = false
    @State private var showingHospitalDetail = false
    @State private var showingDoctorDetail = false
    @State private var showingQRCodeDetail = false
    @State private var selectedFilter = "全部"
    @State private var selectedRegion = "附近"
    @State private var selectedSpecialty = "全科"
    @State private var isShowingFilters = false
    @State private var scrolledUp = false
    
    let filters = ["全部", "医院", "医生", "专家", "科室"]
    let regions = ["附近", "城区", "郊区", "全市"]
    let specialties = ["全科", "内科", "外科", "妇产科", "儿科", "骨科", "神经科", "皮肤科", "眼科", "耳鼻喉科"]
    
    // 健康服务模型
    struct HealthService {
        let name: String
        let icon: String
        let color: Color
    }
    
    let healthServices: [HealthService] = [
        HealthService(name: "体检预约", icon: "heart.text.square.fill", color: .pink),
        HealthService(name: "疫苗接种", icon: "syringe.fill", color: .green),
        HealthService(name: "慢病管理", icon: "pills.fill", color: .orange),
        HealthService(name: "心理咨询", icon: "brain.head.profile", color: .purple),
        HealthService(name: "远程问诊", icon: "video.fill", color: .blue),
        HealthService(name: "家庭医生", icon: "house.fill", color: .teal)
    ]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(.systemGray6)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 15) {
                        // 主卡片区域
                        VStack(spacing: 15) {
                            topCardsSection
                            searchSection
                            hospitalRecommendationSection
                            expertRecommendationSection
                            todayAvailableSection
                            healthServicesSection
                        }
                        .padding(.vertical)
                    }
                    .padding(.top)
                    .background(Color(.systemGray6))
                }
                .coordinateSpace(name: "scroll")
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 0)
                }
            }
            .navigationTitle("就医助手")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // 消息通知
                    }) {
                        Image(systemName: "bell.badge")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAIAssistant) {
                Text("AI症状助手") // 临时替代
            }
            .sheet(isPresented: $showingHospitalDetail) {
                Text("医院详情") // 临时替代
            }
            .sheet(isPresented: $showingDoctorDetail) {
                Text("医生详情") // 临时替代
            }
            .sheet(isPresented: $showingQRCodeDetail) {
                Text("就医码详情") // 临时替代
            }
        }
    }
    
    // MARK: - 视图组件
    
    // 顶部卡片区域
    private var topCardsSection: some View {
        HStack(spacing: 12) {
            // 就医码卡片
            qrCodeCard
            
            // AI症状助手卡片
            aiAssistantCard
        }
        .padding(.horizontal)
    }
    
    // 就医码卡片
    private var qrCodeCard: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
                
                VStack(spacing: 10) {
                    HStack {
                        Image(systemName: "qrcode")
                            .font(.headline)
                            .foregroundColor(.blue)
                        Text("就医码")
                            .font(.headline)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    Image(systemName: "qrcode")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 5)
                        )
                    
                    Button(action: {
                        showingQRCodeDetail = true
                    }) {
                        Text("查看详情")
                            .font(.caption)
                            .foregroundColor(.blue)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 12)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // AI症状助手卡片
    private var aiAssistantCard: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color.blue.opacity(0.2), radius: 10, x: 0, y: 2)
                
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "brain.head.profile")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("AI症状助手")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    Image(systemName: "waveform.path.ecg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white.opacity(0.9))
                        .padding()
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.2))
                        )
                    
                    Button(action: {
                        showingAIAssistant = true
                    }) {
                        Text("开始描述症状")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    // 搜索和筛选区域
    private var searchSection: some View {
        VStack(spacing: 15) {
            // 搜索框
            searchBar
            
            // 筛选选项
            if isShowingFilters {
                filterOptions
            }
        }
    }
    
    // 搜索框
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("搜索医院、医生或症状...", text: $searchText)
                .font(.system(size: 16))
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            
            Button(action: {
                withAnimation {
                    isShowingFilters.toggle()
                }
            }) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundColor(.blue)
                    .padding(8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    // 筛选选项
    private var filterOptions: some View {
        VStack(spacing: 15) {
            // 类别筛选
            filterCategory(title: "类别", items: filters, selectedItem: $selectedFilter)
            
            // 地区筛选
            filterCategory(title: "地区", items: regions, selectedItem: $selectedRegion)
            
            // 科室筛选
            filterCategory(title: "科室", items: specialties, selectedItem: $selectedSpecialty)
        }
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    // 通用筛选类别组件
    private func filterCategory(title: String, items: [String], selectedItem: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(items, id: \.self) { item in
                        Button(action: {
                            selectedItem.wrappedValue = item
                        }) {
                            Text(item)
                                .font(.subheadline)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 12)
                                .background(selectedItem.wrappedValue == item ? Color.blue : Color.white)
                                .foregroundColor(selectedItem.wrappedValue == item ? .white : .primary)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.03), radius: 3)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // 医院推荐部分
    private var hospitalRecommendationSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            sectionHeader(title: "附近推荐医院", showMore: true)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(1...4, id: \.self) { i in
                        hospitalCard(index: i)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // 医院卡片
    private func hospitalCard(index: Int) -> some View {
        Button(action: {
            showingHospitalDetail = true
        }) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "building.2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.8)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .foregroundColor(.white)
                    
                    if index % 2 == 0 {
                        Text("三甲")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(Color.red)
                            .cornerRadius(6)
                            .offset(x: 8, y: -8)
                    }
                }
                
                Text("第\(index)人民医院")
                    .font(.headline)
                    .foregroundColor(.primary)
                
//                HStack {
//                    Image(systemName: "mappin.circle.fill")
//                        .foregroundColor(.secondary)
//                    Text("\(index * 0.8, specifier: "%.1f")km")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
                
                hospitalRating(index: index)
                
                Text("综合医院")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.vertical, 3)
                    .padding(.horizontal, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(5)
            }
            .frame(width: 160)
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
    
    // 医院评分星级
    private func hospitalRating(index: Int) -> some View {
        HStack {
            ForEach(0..<5) { star in
                Image(systemName: star < (5 - index % 2) ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
            
            Text("\(4.0 + Double(index % 5) * 0.2, specifier: "%.1f")")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // 专家推荐部分
    private var expertRecommendationSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            sectionHeader(title: "热门专家", showMore: true)
                .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(1...5, id: \.self) { i in
                        doctorCard(index: i)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // 医生卡片
    private func doctorCard(index: Int) -> some View {
        Button(action: {
            showingDoctorDetail = true
        }) {
            VStack(alignment: .center, spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                    
                    if index % 3 == 0 {
                        Circle()
                            .stroke(Color.green, lineWidth: 3)
                            .frame(width: 70, height: 70)
                    }
                }
                
                Text("张医生")
                    .font(.headline)
                
                Text(["内科", "外科", "儿科", "皮肤科", "神经科"][index % 5])
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("主任医师")
                        .font(.caption)
                        .foregroundColor(.orange)
                        .padding(.vertical, 3)
                        .padding(.horizontal, 8)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(5)
                }
                
                Button(action: {
                    // 预约action
                }) {
                    Text("预约")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
            }
            .frame(width: 120)
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
    
    // 今日可约部分
    private var todayAvailableSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("今日可约")
                    .font(.headline)
                
                Image(systemName: "clock.fill")
                    .foregroundColor(.green)
                    .font(.caption)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            VStack(spacing: 12) {
                ForEach(1...3, id: \.self) { i in
                    availableDoctorItem(index: i)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // 今日可约医生项
    private func availableDoctorItem(index: Int) -> some View {
        Button(action: {
            showingDoctorDetail = true
        }) {
            HStack(spacing: 15) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("李医生")
                        .font(.headline)
                    
                    Text(["内科 · 消化系统", "外科 · 骨科", "儿科 · 儿童保健"][index % 3])
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(["主任医师", "副主任医师", "主治医师"][index % 3])
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("·")
                            .foregroundColor(.gray)
                        
                        Text("第\(index)人民医院")
                            .font(.caption)
                            .lineLimit(1)
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                VStack(spacing: 5) {
                    Text("剩余\(index * 3)个号")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    Button(action: {
                        // 预约action
                    }) {
                        Text("预约")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 15)
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
    
    // 健康服务部分
    private var healthServicesSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("健康服务")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 10)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                ForEach(healthServices.indices, id: \.self) { index in
                    healthServiceItem(service: healthServices[index])
                }
            }
            .padding(.horizontal)
        }
    }
    
    // 健康服务项目
    private func healthServiceItem(service: HealthService) -> some View {
        Button(action: {
            // 服务点击
        }) {
            VStack(spacing: 10) {
                Image(systemName: service.icon)
                    .font(.title2)
                    .foregroundColor(service.color)
                    .frame(width: 50, height: 50)
                    .background(service.color.opacity(0.1))
                    .cornerRadius(12)
                
                Text(service.name)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
    
    // 通用区块标题
    private func sectionHeader(title: String, showMore: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(.headline)
            
            Spacer()
            
            if showMore {
                Button(action: {
                    // 更多操作
                }) {
                    Text("更多")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// 使用新的#Preview宏
#Preview {
    MedicalAssistanceView()
}

//// 医院详情视图
//struct HospitalDetailView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State private var selectedTab = 0
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 0) {
//                // 头部图片区域
//                ZStack(alignment: .bottom) {
//                    // 医院图片
//                    Rectangle()
//                        .fill(
//                            LinearGradient(
//                                gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.blue.opacity(0.9)]),
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
//                        .frame(height: 200)
//                    
//                    // 医院信息卡片
//                    VStack(alignment: .leading, spacing: 10) {
//                        HStack(alignment: .top) {
//                            VStack(alignment: .leading, spacing: 8) {
//                                Text("北京协和医院")
//                                    .font(.title2)
//                                    .fontWeight(.bold)
//                                
//                                HStack {
//                                    Text("三级甲等")
//                                        .font(.caption)
//                                        .padding(.horizontal, 8)
//                                        .padding(.vertical, 4)
//                                        .background(Color.red.opacity(0.1))
//                                        .foregroundColor(.red)
//                                        .cornerRadius(4)
//                                    
//                                    Text("公立医院")
//                                        .font(.caption)
//                                        .padding(.horizontal, 8)
//                                        .padding(.vertical, 4)
//                                        .background(Color.blue.opacity(0.1))
//                                        .foregroundColor(.blue)
//                                        .cornerRadius(4)
//                                }
//                            }
//                            
//                            Spacer()
//                            
//                            HStack(spacing: 15) {
//                                VStack {
//                                    Image(systemName: "phone.fill")
//                                        .foregroundColor(.blue)
//                                    Text("电话")
//                                        .font(.caption)
//                                }
//                                
//                                VStack {
//                                    Image(systemName: "location.fill")
//                                        .foregroundColor(.blue)
//                                    Text("导航")
//                                        .font(.caption)
//                                }
//                                
//                                VStack {
//                                    Image(systemName: "star.fill")
//                                        .foregroundColor(.blue)
//                                    Text("收藏")
//                                        .font(.caption)
//                                }
//                            }
//                        }
//                        
//                        HStack {
//                            Image(systemName: "mappin.circle.fill")
//                                .foregroundColor(.gray)
//                            Text("北京市东城区东单帅府园1号")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        HStack {
//                            ForEach(0..<5) { star in
//                                Image(systemName: "star.fill")
//                                    .font(.caption)
//                                    .foregroundColor(.yellow)
//                            }
//                            
//                            Text("4.9")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            
//                            Text("(2543条评价)")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            
//                            Spacer()
//                            
//                            Text("2.5km")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(16)
//                    .shadow(color: Color.black.opacity(0.1), radius: 10)
//                    .offset(y: 50)
//                    .padding(.horizontal)
//                }
//                
//                Spacer().frame(height: 60)
//                
//                // 分类选项卡
//                VStack(spacing: 0) {
//                    HStack(spacing: 0) {
//                        ForEach(["医院介绍", "科室导航", "医生团队", "就诊须知"].indices, id: \.self) { index in
//                            Button(action: {
//                                selectedTab = index
//                            }) {
//                                VStack(spacing: 8) {
//                                    Text(["医院介绍", "科室导航", "医生团队", "就诊须知"][index])
//                                        .font(.subheadline)
//                                        .foregroundColor(selectedTab == index ? .blue : .gray)
//                                    
//                                    Rectangle()
//                                        .fill(selectedTab == index ? Color.blue : Color.clear)
//                                        .frame(height: 2)
//                                }
//                            }
//                            .frame(maxWidth: .infinity)
//                        }
//                    }
//                    .padding(.horizontal)
//                    
//                    Rectangle()
//                        .fill(Color.gray.opacity(0.1))
//                        .frame(height: 1)
//                }
//                
//                // 选项卡内容
//                TabView(selection: $selectedTab) {
//                    // 介绍
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("医院介绍")
//                            .font(.headline)
//                            .padding(.top)
//                        
//                        Text("北京协和医院是中国最早的西医医院之一，建立于1921年，是集医疗、教学、科研于一体的综合性医院。医院拥有顶尖的医疗设备和专业的医疗团队，在国内外享有盛誉。\n\n医院设有内科、外科、妇产科、儿科等多个临床科室，以及多个医技科室，能够为患者提供全方位的医疗服务。")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                            .lineSpacing(5)
//                        
//                        Divider()
//                        
//                        Text("医院设施")
//                            .font(.headline)
//                        
//                        // 医院设施图标
//                        LazyVGrid(columns: [
//                            GridItem(.flexible()),
//                            GridItem(.flexible()),
//                            GridItem(.flexible()),
//                            GridItem(.flexible())
//                        ], spacing: 15) {
//                            ForEach(["停车场", "ATM机", "药房", "食堂", "便利店", "轮椅", "无障碍", "母婴室"].indices, id: \.self) { index in
//                                VStack {
//                                    Image(systemName: ["car.fill", "creditcard.fill", "pills.fill", "fork.knife", "bag.fill", "figure.roll", "figure.roll.runningpace", "figure.child.and.lock"][index])
//                                        .foregroundColor(.blue)
//                                    Text(["停车场", "ATM机", "药房", "食堂", "便利店", "轮椅", "无障碍", "母婴室"][index])
//                                        .font(.caption)
//                                }
//                            }
//                        }
//                    }
//                    .padding()
//                    .tag(0)
//                    
//                    // 科室导航
//                    VStack(alignment: .leading, spacing: 15) {
//                        ForEach(["内科", "外科", "妇产科", "儿科", "皮肤科"].indices, id: \.self) { index in
//                            VStack(alignment: .leading, spacing: 10) {
//                                Text(["内科", "外科", "妇产科", "儿科", "皮肤科"][index])
//                                    .font(.headline)
//                                
//                                VStack(alignment: .leading, spacing: 5) {
//                                    ForEach(1...3, id: \.self) { i in
//                                        HStack {
//                                            Text("• \(["消化内科", "心血管内科", "呼吸内科", "神经内科", "内分泌科", "肾内科"][i % 6])")
//                                                .font(.subheadline)
//                                                .foregroundColor(.secondary)
//                                            
//                                            Spacer()
//                                            
//                                            Text("1号楼\(i)层")
//                                                .font(.caption)
//                                                .foregroundColor(.gray)
//                                        }
//                                    }
//                                }
//                                .padding(.leading, 5)
//                                
//                                if index < 4 {
//                                    Divider()
//                                }
//                            }
//                        }
//                    }
//                    .padding()
//                    .tag(1)
//                    
//                    // 医生团队
//                    VStack(spacing: 15) {
//                        ForEach(1...5, id: \.self) { i in
//                            HStack(spacing: 15) {
//                                Image(systemName: "person.circle.fill")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: 50, height: 50)
//                                    .foregroundColor(.blue)
//                                
//                                VStack(alignment: .leading, spacing: 5) {
//                                    Text("\(["张", "李", "王", "赵", "刘"][i % 5])医生")
//                                        .font(.headline)
//                                    
//                                    Text("\(["主任医师", "副主任医师", "主治医师"][i % 3]) · \(["内科", "外科", "妇产科", "儿科", "皮肤科"][i % 5])")
//                                        .font(.subheadline)
//                                        .foregroundColor(.secondary)
//                                    
//                                    Text("专长：\(["消化系统疾病", "心血管疾病", "呼吸系统疾病", "神经系统疾病", "儿童常见病"][i % 5])")
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                                
//                                Spacer()
//                                
//                                Button(action: {
//                                    // 预约
//                                }) {
//                                    Text("预约")
//                                        .font(.subheadline)
//                                        .foregroundColor(.white)
//                                        .padding(.vertical, 5)
//                                        .padding(.horizontal, 15)
//                                        .background(Color.blue)
//                                        .cornerRadius(15)
//                                }
//                            }
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(10)
//                            .shadow(color: Color.black.opacity(0.05), radius: 5)
//                        }
//                    }
//                    .padding()
//                    .tag(2)
//                    
//                    // 就诊须知
//                    VStack(alignment: .leading, spacing: 15) {
//                        Text("挂号指南")
//                            .font(.headline)
//                            .padding(.top)
//                        
//                        Text("1. 在线预约：通过本APP或医院官网提前预约\n2. 现场挂号：到医院自助机或挂号窗口\n3. 电话预约：拨打114预约平台")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                            .lineSpacing(8)
//                        
//                        Divider()
//                        
//                        Text("就诊流程")
//                            .font(.headline)
//                        
//                        HStack {
//                            ForEach(["挂号", "候诊", "就诊", "缴费", "取药"].indices, id: \.self) { index in
//                                VStack {
//                                    Text("\(index + 1)")
//                                        .font(.headline)
//                                        .foregroundColor(.white)
//                                        .frame(width: 30, height: 30)
//                                        .background(Color.blue)
//                                        .cornerRadius(15)
//                                    
//                                    Text(["挂号", "候诊", "就诊", "缴费", "取药"][index])
//                                        .font(.caption)
//                                    
//                                    if index < 4 {
//                                        Image(systemName: "arrow.right")
//                                            .font(.caption)
//                                            .foregroundColor(.gray)
//                                    }
//                                }
//                                .frame(maxWidth: .infinity)
//                            }
//                        }
//                        
//                        Divider()
//                        
//                        Text("注意事项")
//                            .font(.headline)
//                        
//                        Text("• 请携带有效身份证件\n• 建议提前15分钟到达候诊区\n• 特需门诊需提前预约\n• 节假日门诊时间可能调整\n• 医保报销需带医保卡")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                            .lineSpacing(8)
//                    }
//                    .padding()
//                    .tag(3)
//                }
//                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                .frame(height: 500)
//            }
//        }
//        .ignoresSafeArea(edges: .top)
//        .overlay(
//            Button(action: {
//                presentationMode.wrappedValue.dismiss()
//            }) {
//                Image(systemName: "xmark")
//                    .foregroundColor(.white)
//                    .padding(8)
//                    .background(Color.black.opacity(0.6))
//                    .clipShape(Circle())
//            }
//            .padding(),
//            alignment: .topTrailing
//        )
//    }
//}
//
//// 医生详情视图
//struct DoctorDetailView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State private var selectedDate = Date()
//    @State private var selectedTimeSlot: String?
//    
//    let timeSlots = ["08:30", "09:00", "09:30", "10:00", "10:30", "14:00", "14:30", "15:00", "15:30", "16:00"]
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 20) {
//                // 医生信息
//                HStack(spacing: 15) {
//                    Image(systemName: "person.circle.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 80, height: 80)
//                        .foregroundColor(.blue)
//                    
//                    VStack(alignment: .leading, spacing: 8) {
//                        HStack {
//                            Text("张医生")
//                                .font(.title2)
//                                .fontWeight(.bold)
//                            
//                            Image(systemName: "checkmark.seal.fill")
//                                .foregroundColor(.blue)
//                        }
//                        
//                        Text("主任医师 · 内科")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                        
//                        HStack {
//                            ForEach(0..<5) { star in
//                                Image(systemName: "star.fill")
//                                    .font(.caption)
//                                    .foregroundColor(.yellow)
//                            }
//                            
//                            Text("4.9")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                            
//                            Text("(386条评价)")
//                                .font(.caption)
//                                .foregroundColor(.gray)
//                        }
//                        
//                        Text("北京协和医院")
//                            .font(.subheadline)
//                            .foregroundColor(.gray)
//                    }
//                    
//                    Spacer()
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(16)
//                .shadow(color: Color.black.opacity(0.05), radius: 5)
//                
//                // 医生简介
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("医生简介")
//                        .font(.headline)
//                    
//                    Text("张医生，主任医师，医学博士，从事临床工作30余年，擅长消化系统疾病的诊断与治疗，尤其在胃肠道疾病、肝胆疾病方面有丰富经验。曾赴美国哈佛大学医学院进修，发表学术论文50余篇，主持多项国家级科研项目。")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                        .lineSpacing(5)
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(16)
//                .shadow(color: Color.black.opacity(0.05), radius: 5)
//                
//                // 专长
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("专业特长")
//                        .font(.headline)
//                    
//                    HStack {
//                        ForEach(["消化道疾病", "肝胆疾病", "胃肠炎", "溃疡病", "胆结石"].indices, id: \.self) { index in
//                            Text(["消化道疾病", "肝胆疾病", "胃肠炎", "溃疡病", "胆结石"][index])
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                                .padding(.vertical, 5)
//                                .padding(.horizontal, 10)
//                                .background(Color.blue.opacity(0.1))
//                                .cornerRadius(15)
//                        }
//                    }
//                    .padding(.horizontal, -5)
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(16)
//                .shadow(color: Color.black.opacity(0.05), radius: 5)
//                
//                // 预约日期选择
//                VStack(alignment: .leading, spacing: 15) {
//                    Text("选择预约日期")
//                        .font(.headline)
//                    
//                    // 简化版日期选择器
//                    HStack {
//                        ForEach(0..<5) { dayOffset in
//                            let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date())!
//                            Button(action: {
//                                selectedDate = date
//                            }) {
//                                VStack(spacing: 8) {
//                                    Text(weekdayString(from: date))
//                                        .font(.caption)
//                                    
//                                    Text("\(Calendar.current.component(.day, from: date))")
//                                        .font(.headline)
//                                    
//                                    Text(dayOffset == 0 ? "今天" : "")
//                                        .font(.caption)
//                                        .foregroundColor(.blue)
//                                }
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 12)
//                                .background(Calendar.current.isDate(selectedDate, inSameDayAs: date) ? Color.blue : Color.clear)
//                                .foregroundColor(Calendar.current.isDate(selectedDate, inSameDayAs: date) ? .white : .primary)
//                                .cornerRadius(10)
//                            }
//                            .frame(maxWidth: .infinity)
//                        }
//                    }
//                    
//                    Divider()
//                    
//                    // 可预约时段
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("可预约时段")
//                            .font(.headline)
//                        
//                        LazyVGrid(columns: [
//                            GridItem(.flexible()),
//                            GridItem(.flexible()),
//                            GridItem(.flexible())
//                        ], spacing: 10) {
//                            ForEach(timeSlots, id: \.self) { time in
//                                Button(action: {
//                                    selectedTimeSlot = time
//                                }) {
//                                    Text(time)
//                                        .font(.subheadline)
//                                        .padding(.vertical, 8)
//                                        .frame(maxWidth: .infinity)
//                                        .background(selectedTimeSlot == time ? Color.blue : Color.gray.opacity(0.1))
//                                        .foregroundColor(selectedTimeSlot == time ? .white : .primary)
//                                        .cornerRadius(8)
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(16)
//                .shadow(color: Color.black.opacity(0.05), radius: 5)
//                
//                // 患者评价
//                VStack(alignment: .leading, spacing: 15) {
//                    HStack {
//                        Text("患者评价")
//                            .font(.headline)
//                        
//                        Spacer()
//                        
//                        Button(action: {
//                            // 更多评价
//                        }) {
//                            Text("更多")
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                        }
//                    }
//                    
//                    ForEach(1...3, id: \.self) { i in
//                        VStack(alignment: .leading, spacing: 8) {
//                            HStack {
//                                Image(systemName: "person.crop.circle.fill")
//                                    .foregroundColor(.gray)
//                                
//                                Text("患者\(i)")
//                                    .font(.subheadline)
//                                    .foregroundColor(.primary)
//                                
//                                Spacer()
//                                
//                                Text("\(5 - (i % 2))个月前")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                            
//                            HStack {
//                                ForEach(0..<5) { star in
//                                    Image(systemName: star < (5 - i % 2) ? "star.fill" : "star")
//                                        .font(.caption)
//                                        .foregroundColor(.yellow)
//                                }
//                            }
//                            
//                            Text(["医生很专业，态度和蔼，详细解释了我的病情和治疗方案，感觉很放心。", "看诊过程很耐心，问诊很细致，让我对自己的病情有了更清晰的认识。", "医生医术精湛，热情负责，为我解决了长期困扰的问题，非常感谢！"][i % 3])
//                                .font(.subheadline)
//                                .foregroundColor(.secondary)
//                                .lineSpacing(4)
//                            
//                            if i < 3 {
//                                Divider()
//                            }
//                        }
//                    }
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(16)
//                .shadow(color: Color.black.opacity(0.05), radius: 5)
//            }
//            .padding()
//        }
//        .overlay(
//            VStack {
//                Spacer()
//                
//                HStack {
//                    VStack(alignment: .leading) {
//                        Text("预约费用")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                        
//                        Text("¥120")
//                            .font(.title3)
//                            .fontWeight(.bold)
//                            .foregroundColor(.red)
//                    }
//                    
//                    Spacer()
//                    
//                    Button(action: {
//                        // 预约操作
//                    }) {
//                        Text("立即预约")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(height: 50)
//                            .frame(width: 200)
//                            .background(selectedTimeSlot != nil ? Color.blue : Color.gray)
//                            .cornerRadius(25)
//                    }
//                    .disabled(selectedTimeSlot == nil)
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(16, corners: [.topLeft, .topRight])
//                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
//            }
//        )
//        .ignoresSafeArea(edges: .bottom)
//        .navigationBarTitle("医生详情", displayMode: .inline)
//        .navigationBarItems(leading: Button(action: {
//            presentationMode.wrappedValue.dismiss()
//        }) {
//            Image(systemName: "chevron.left")
//                .foregroundColor(.blue)
//        })
//    }
//    
//    func weekdayString(from date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "E"
//        formatter.locale = Locale(identifier: "zh_CN")
//        return formatter.string(from: date)
//    }
//}
//
//// 就医码详情视图
//struct MedicalQRCodeDetailView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State private var selectedTab = 0
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 20) {
//                    // 就医码
//                    VStack(spacing: 15) {
//                        Image(systemName: "qrcode")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 200, height: 200)
//                            .padding()
//                            .background(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .fill(Color.white)
//                                    .shadow(color: Color.black.opacity(0.1), radius: 10)
//                            )
//                        
//                        Text("扫描此码可获取您的医疗信息")
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                        
//                        HStack {
//                            Button(action: {
//                                // 刷新二维码
//                            }) {
//                                HStack {
//                                    Image(systemName: "arrow.clockwise")
//                                    Text("刷新")
//                                }
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                                .padding(.horizontal, 15)
//                                .padding(.vertical, 8)
//                                .background(Color.blue.opacity(0.1))
//                                .cornerRadius(20)
//                            }
//                            
//                            Button(action: {
//                                // 分享二维码
//                            }) {
//                                HStack {
//                                    Image(systemName: "square.and.arrow.up")
//                                    Text("分享")
//                                }
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                                .padding(.horizontal, 15)
//                                .padding(.vertical, 8)
//                                .background(Color.blue.opacity(0.1))
//                                .cornerRadius(20)
//                            }
//                        }
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(16)
//                    .shadow(color: Color.black.opacity(0.05), radius: 5)
//                    
//                    // 信息类别标签页
//                    VStack(spacing: 0) {
//                        HStack(spacing: 0) {
//                            ForEach(["基本信息", "过敏史", "疾病史", "用药史", "体征记录"].indices, id: \.self) { index in
//                                Button(action: {
//                                    selectedTab = index
//                                }) {
//                                    VStack(spacing: 8) {
//                                        Text(["基本信息", "过敏史", "疾病史", "用药史", "体征记录"][index])
//                                            .font(.subheadline)
//                                            .foregroundColor(selectedTab == index ? .blue : .gray)
//                                        
//                                        Rectangle()
//                                            .fill(selectedTab == index ? Color.blue : Color.clear)
//                                            .frame(height: 2)
//                                    }
//                                }
//                                .frame(maxWidth: .infinity)
//                            }
//                        }
//                        .padding(.horizontal)
//                        
//                        Rectangle()
//                            .fill(Color.gray.opacity(0.1))
//                            .frame(height: 1)
//                    }
//                    .background(Color.white)
//                    .cornerRadius(16)
//                    .shadow(color: Color.black.opacity(0.05), radius: 5)
//                    
//                    // 各标签页内容
//                    TabView(selection: $selectedTab) {
//                        // 基本信息
//                        VStack(alignment: .leading, spacing: 15) {
//                            infoRow(title: "姓名", value: "张三")
//                            infoRow(title: "性别", value: "男")
//                            infoRow(title: "年龄", value: "35岁")
//                            infoRow(title: "身份证号", value: "3****************X", isPrivate: true)
//                            infoRow(title: "血型", value: "A型")
//                            infoRow(title: "紧急联系人", value: "李四 (138****5678)")
//                            
//                            HStack {
//                                Spacer()
//                                
//                                Button(action: {
//                                    // 编辑信息
//                                }) {
//                                    HStack {
//                                        Image(systemName: "pencil")
//                                        Text("编辑信息")
//                                    }
//                                    .font(.subheadline)
//                                    .foregroundColor(.blue)
//                                    .padding(.horizontal, 15)
//                                    .padding(.vertical, 8)
//                                    .background(Color.blue.opacity(0.1))
//                                    .cornerRadius(20)
//                                }
//                            }
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(16)
//                        .shadow(color: Color.black.opacity(0.05), radius: 5)
//                        .tag(0)
//                        
//                        // 过敏史
//                        VStack(alignment: .leading, spacing: 15) {
//                            HStack {
//                                Text("药物过敏")
//                                    .font(.headline)
//                                
//                                Spacer()
//                                
//                                Button(action: {
//                                    // 添加记录
//                                }) {
//                                    Label("添加", systemImage: "plus")
//                                        .font(.caption)
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                            
//                            VStack(spacing: 12) {
//                                allergyItem(name: "青霉素", severity: "严重", date: "2018年")
//                                allergyItem(name: "磺胺类药物", severity: "中度", date: "2015年")
//                            }
//                            
//                            Divider()
//                            
//                            HStack {
//                                Text("其他过敏")
//                                    .font(.headline)
//                                
//                                Spacer()
//                            }
//                            
//                            VStack(spacing: 12) {
//                                allergyItem(name: "花粉", severity: "轻度", date: "2020年")
//                                allergyItem(name: "海鲜", severity: "中度", date: "不详")
//                            }
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(16)
//                        .shadow(color: Color.black.opacity(0.05), radius: 5)
//                        .tag(1)
//                        
//                        // 疾病史
//                        VStack(alignment: .leading, spacing: 15) {
//                            HStack {
//                                Text("疾病记录")
//                                    .font(.headline)
//                                
//                                Spacer()
//                                
//                                Button(action: {
//                                    // 添加记录
//                                }) {
//                                    Label("添加", systemImage: "plus")
//                                        .font(.caption)
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                            
//                            VStack(spacing: 15) {
//                                diseaseItem(
//                                    name: "高血压",
//                                    status: "慢性",
//                                    date: "2017年至今",
//                                    treatment: "降压药物控制",
//                                    hospital: "北京协和医院"
//                                )
//                                
//                                Divider()
//                                
//                                diseaseItem(
//                                    name: "胃炎",
//                                    status: "间歇发作",
//                                    date: "2019年",
//                                    treatment: "质子泵抑制剂",
//                                    hospital: "第三人民医院"
//                                )
//                                
//                                Divider()
//                                
//                                diseaseItem(
//                                    name: "急性阑尾炎",
//                                    status: "已治愈",
//                                    date: "2010年",
//                                    treatment: "手术治疗",
//                                    hospital: "北京大学人民医院"
//                                )
//                            }
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(16)
//                        .shadow(color: Color.black.opacity(0.05), radius: 5)
//                        .tag(2)
//                        
//                        // 用药史
//                        VStack(alignment: .leading, spacing: 15) {
//                            HStack {
//                                Text("长期用药")
//                                    .font(.headline)
//                                
//                                Spacer()
//                                
//                                Button(action: {
//                                    // 添加用药
//                                }) {
//                                    Label("添加", systemImage: "plus")
//                                        .font(.caption)
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                            
//                            VStack(spacing: 15) {
//                                medicationItem(
//                                    name: "硝苯地平缓释片",
//                                    dosage: "30mg",
//                                    frequency: "每日1次",
//                                    purpose: "控制血压",
//                                    startDate: "2017年至今"
//                                )
//                                
//                                Divider()
//                                
//                                medicationItem(
//                                    name: "阿司匹林肠溶片",
//                                    dosage: "100mg",
//                                    frequency: "每日1次",
//                                    purpose: "抗血小板",
//                                    startDate: "2018年至今"
//                                )
//                            }
//                            
//                            Divider()
//                            
//                            HStack {
//                                Text("近期用药")
//                                    .font(.headline)
//                                
//                                Spacer()
//                            }
//                            
//                            VStack(spacing: 15) {
//                                medicationItem(
//                                    name: "奥美拉唑肠溶胶囊",
//                                    dosage: "20mg",
//                                    frequency: "每日1次",
//                                    purpose: "胃炎",
//                                    startDate: "2023年5月-2023年6月"
//                                )
//                            }
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(16)
//                        .shadow(color: Color.black.opacity(0.05), radius: 5)
//                        .tag(3)
//                        
//                        // 体征记录
//                        VStack(alignment: .leading, spacing: 15) {
//                            HStack {
//                                Text("最近体征")
//                                    .font(.headline)
//                                
//                                Spacer()
//                                
//                                Button(action: {
//                                    // 查看全部
//                                }) {
//                                    Text("查看全部")
//                                        .font(.caption)
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                            
//                            // 体征图表示例
//                            VStack(spacing: 10) {
//                                HStack {
//                                    Text("血压记录")
//                                        .font(.subheadline)
//                                    
//                                    Spacer()
//                                    
//                                    Text("单位: mmHg")
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                                
//                                // 示意图
//                                Rectangle()
//                                    .fill(Color.blue.opacity(0.1))
//                                    .frame(height: 150)
//                                    .overlay(
//                                        Text("血压趋势图")
//                                            .foregroundColor(.blue)
//                                    )
//                            }
//                            
//                            Divider()
//                            
//                            VStack(alignment: .leading, spacing: 10) {
//                                Text("体检记录")
//                                    .font(.headline)
//                                
//                                VStack(spacing: 15) {
//                                    recordItem(
//                                        title: "2023年度体检",
//                                        date: "2023-03-15",
//                                        institution: "北京协和医院",
//                                        note: "总体健康状况良好，血压轻度升高"
//                                    )
//                                    
//                                    Divider()
//                                    
//                                    recordItem(
//                                        title: "2022年度体检",
//                                        date: "2022-04-10",
//                                        institution: "北京大学人民医院",
//                                        note: "正常范围"
//                                    )
//                                }
//                            }
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(16)
//                        .shadow(color: Color.black.opacity(0.05), radius: 5)
//                        .tag(4)
//                    }
//                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//                    .frame(height: 400)
//                    
//                    VStack(spacing: 10) {
//                        Text("使用说明")
//                            .font(.headline)
//                        
//                        Text("• 就医码中包含您的健康信息，扫描后医生可快速了解您的病史\n• 可通过"编辑"按钮更新各项信息，确保资料准确性\n• 您的隐私数据受到加密保护，仅授权医务人员可访问\n• 建议定期更新您的健康记录，以便医生提供更精准的诊疗")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                            .lineSpacing(5)
//                            .padding()
//                            .background(Color.blue.opacity(0.05))
//                            .cornerRadius(10)
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(16)
//                    .shadow(color: Color.black.opacity(0.05), radius: 5)
//                }
//                .padding()
//            }
//            .navigationTitle("健康信息")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Text("关闭")
//                            .foregroundColor(.blue)
//                    }
//                }
//            }
//        }
//    }
//    
//    // 信息行
//    func infoRow(title: String, value: String, isPrivate: Bool = false) -> some View {
//        HStack(alignment: .top) {
//            Text(title)
//                .font(.subheadline)
//                .foregroundColor(.gray)
//                .frame(width: 80, alignment: .leading)
//            
//            Text(value)
//                .font(.subheadline)
//            
//            if isPrivate {
//                Image(systemName: "eye.slash")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            
//            Spacer()
//        }
//    }
//    
//    // 过敏项目
//    func allergyItem(name: String, severity: String, date: String) -> some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 5) {
//                Text(name)
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                
//                Text("发现时间: \(date)")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            
//            Spacer()
//            
//            Text(severity)
//                .font(.caption)
//                .padding(.horizontal, 10)
//                .padding(.vertical, 5)
//                .background(
//                    severity == "严重" ? Color.red.opacity(0.1) :
//                        severity == "中度" ? Color.orange.opacity(0.1) :
//                        Color.yellow.opacity(0.1)
//                )
//                .foregroundColor(
//                    severity == "严重" ? Color.red :
//                        severity == "中度" ? Color.orange :
//                        Color.yellow
//                )
//                .cornerRadius(5)
//        }
//    }
//    
//    // 疾病项目
//    func diseaseItem(name: String, status: String, date: String, treatment: String, hospital: String) -> some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Text(name)
//                    .font(.headline)
//                
//                Spacer()
//                
//                Text(status)
//                    .font(.caption)
//                    .padding(.horizontal, 10)
//                    .padding(.vertical, 5)
//                    .background(
//                        status == "慢性" || status == "间歇发作" ? Color.orange.opacity(0.1) :
//                            status == "已治愈" ? Color.green.opacity(0.1) :
//                            Color.blue.opacity(0.1)
//                    )
//                    .foregroundColor(
//                        status == "慢性" || status == "间歇发作" ? Color.orange :
//                            status == "已治愈" ? Color.green :
//                            Color.blue
//                    )
//                    .cornerRadius(5)
//            }
//            
//            Text("发病/诊断时间: \(date)")
//                .font(.caption)
//                .foregroundColor(.gray)
//            
//            Text("治疗: \(treatment)")
//                .font(.subheadline)
//            
//            Text("就诊医院: \(hospital)")
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//    }
//    
//    // 用药项目
//    func medicationItem(name: String, dosage: String, frequency: String, purpose: String, startDate: String) -> some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Text(name)
//                    .font(.headline)
//                
//                Spacer()
//                
//                Text(dosage)
//                    .font(.subheadline)
//                    .foregroundColor(.blue)
//            }
//            
//            Text("用药频次: \(frequency)")
//                .font(.subheadline)
//            
//            Text("适应症: \(purpose)")
//                .font(.subheadline)
//            
//            Text("用药时间: \(startDate)")
//                .font(.caption)
//                .foregroundColor(.gray)
//        }
//    }
//    
//    // 体征记录项目
//    func recordItem(title: String, date: String, institution: String, note: String) -> some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Text(title)
//                    .font(.subheadline)
//                    .fontWeight(.medium)
//                
//                Spacer()
//                
//                Text(date)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            
//            Text("机构: \(institution)")
//                .font(.caption)
//                .foregroundColor(.gray)
//            
//            Text("备注: \(note)")
//                .font(.subheadline)
//        }
//    }
//}
//
//// 用于特定圆角的扩展
//extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape(RoundedCorner(radius: radius, corners: corners))
//    }
//}
//
//struct RoundedCorner: Shape {
//    var radius: CGFloat = .infinity
//    var corners: UIRectCorner = .allCorners
//    
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}
//
//struct AISymptomAssistantView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State private var currentSymptom = ""
//    @State private var symptoms: [String] = []
//    @State private var description = ""
//    @State private var currentStep = 0
//    @State private var checkingSymptoms = false
//    @State private var askingQuestions = false
//    @State private var questions = [
//        Question(id: 1, text: "您的症状持续了多久？", options: ["1-3天", "4-7天", "1-2周", "2周以上"], answer: nil),
//        Question(id: 2, text: "症状在什么时间加重？", options: ["早晨", "白天", "晚上", "夜间", "不规律"], answer: nil),
//        Question(id: 3, text: "有什么因素会加重症状？", options: ["活动后", "进食后", "情绪变化时", "天气变化", "不确定"], answer: nil)
//    ]
//    @State private var symptomHistory: [String] = []
//    @State private var isGeneratingDescription = false
//    @State private var generatedDescription = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                // 进度指示器
//                VStack(spacing: 0) {
//                    HStack(spacing: 0) {
//                        ForEach(0..<3) { step in
//                            VStack(spacing: 5) {
//                                Circle()
//                                    .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
//                                    .frame(width: 30, height: 30)
//                                    .overlay(
//                                        Group {
//                                            if step < currentStep {
//                                                Image(systemName: "checkmark")
//                                                    .foregroundColor(.white)
//                                            } else {
//                                                Text("\(step + 1)")
//                                                    .foregroundColor(step == currentStep ? .white : .gray)
//                                            }
//                                        }
//                                    )
//                                
//                                Text(["主要症状", "具体情况", "AI分析"][step])
//                                    .font(.caption)
//                                    .foregroundColor(step == currentStep ? .blue : .gray)
//                            }
//                            
//                            if step < 2 {
//                                Rectangle()
//                                    .fill(step < currentStep ? Color.blue : Color.gray.opacity(0.3))
//                                    .frame(height: 2)
//                                    .frame(maxWidth: .infinity)
//                            }
//                        }
//                    }
//                    .padding(.vertical, 15)
//                    .padding(.horizontal)
//                    .background(Color.white)
//                    .cornerRadius(16)
//                    .shadow(color: Color.black.opacity(0.05), radius: 5)
//                }
//                .padding()
//                
//                ScrollView {
//                    VStack(spacing: 20) {
//                        // 步骤1: 添加主要症状
//                        if currentStep == 0 {
//                            VStack(alignment: .leading, spacing: 15) {
//                                Text("请告诉我您的主要症状")
//                                    .font(.headline)
//                                
//                                Text("输入您感到不适的症状，可以添加多个")
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                                
//                                HStack {
//                                    TextField("例如：头痛、发热、咳嗽...", text: $currentSymptom)
//                                        .padding()
//                                        .background(Color(.systemGray6))
//                                        .cornerRadius(10)
//                                    
//                                    Button(action: {
//                                        if !currentSymptom.isEmpty {
//                                            withAnimation {
//                                                symptoms.append(currentSymptom)
//                                                currentSymptom = ""
//                                            }
//                                        }
//                                    }) {
//                                        Text("添加")
//                                            .foregroundColor(.white)
//                                            .padding(.vertical, 15)
//                                            .padding(.horizontal, 20)
//                                            .background(Color.blue)
//                                            .cornerRadius(10)
//                                    }
//                                }
//                                
//                                if !symptoms.isEmpty {
//                                    Text("已添加的症状:")
//                                        .font(.subheadline)
//                                    
//                                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
//                                        ForEach(symptoms, id: \.self) { symptom in
//                                            HStack {
//                                                Text(symptom)
//                                                    .font(.subheadline)
//                                                
//                                                Button(action: {
//                                                    withAnimation {
//                                                        symptoms.removeAll { $0 == symptom }
//                                                    }
//                                                }) {
//                                                    Image(systemName: "xmark.circle.fill")
//                                                        .foregroundColor(.gray)
//                                                }
//                                            }
//                                            .padding(.vertical, 5)
//                                            .padding(.horizontal, 10)
//                                            .background(Color.blue.opacity(0.1))
//                                            .cornerRadius(15)
//                                        }
//                                    }
//                                }
//                                
//                                if symptoms.isEmpty {
//                                    VStack(spacing: 10) {
//                                        Text("常见症状:")
//                                            .font(.subheadline)
//                                        
//                                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
//                                            ForEach(["头痛", "发热", "咳嗽", "恶心", "腹痛", "头晕", "乏力", "腹泻", "胸痛"], id: \.self) { symptom in
//                                                Button(action: {
//                                                    symptoms.append(symptom)
//                                                }) {
//                                                    Text(symptom)
//                                                        .font(.subheadline)
//                                                        .padding(.vertical, 5)
//                                                        .padding(.horizontal, 10)
//                                                        .background(Color.gray.opacity(0.1))
//                                                        .cornerRadius(15)
//                                                }
//                                            }
//                                        }
//                                    }
//                                    .padding()
//                                    .background(Color(.systemGray6))
//                                    .cornerRadius(10)
//                                }
//                                
//                                // 历史症状查询
//                                if !checkingSymptoms && symptoms.isEmpty {
//                                    Button(action: {
//                                        checkingSymptoms = true
//                                        // 模拟从健康记录中获取历史症状
//                                        symptomHistory = ["咳嗽", "头痛", "发热", "胸闷"]
//                                    }) {
//                                        HStack {
//                                            Image(systemName: "clock.arrow.circlepath")
//                                            Text("查看历史症状记录")
//                                        }
//                                        .font(.subheadline)
//                                        .foregroundColor(.blue)
//                                        .padding(.vertical, 10)
//                                    }
//                                }
//                                
//                                if checkingSymptoms {
//                                    VStack(alignment: .leading, spacing: 10) {
//                                        Text("历史症状记录:")
//                                            .font(.subheadline)
//                                        
//                                        ForEach(symptomHistory, id: \.self) { symptom in
//                                            HStack {
//                                                Text(symptom)
//                                                
//                                                Spacer()
//                                                
//                                                Button(action: {
//                                                    symptoms.append(symptom)
//                                                }) {
//                                                    Text("添加")
//                                                        .font(.caption)
//                                                        .foregroundColor(.blue)
//                                                        .padding(.vertical, 3)
//                                                        .padding(.horizontal, 10)
//                                                        .background(Color.blue.opacity(0.1))
//                                                        .cornerRadius(10)
//                                                }
//                                            }
//                                            .padding(.vertical, 5)
//                                        }
//                                        
//                                        Button(action: {
//                                            checkingSymptoms = false
//                                        }) {
//                                            Text("关闭")
//                                                .font(.caption)
//                                                .foregroundColor(.gray)
//                                        }
//                                    }
//                                    .padding()
//                                    .background(Color(.systemGray6))
//                                    .cornerRadius(10)
//                                }
//                            }
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(16)
//                            .shadow(color: Color.black.opacity(0.05), radius: 5)
//                        }
//                        
//                        // 步骤2: 具体问题回答
//                        if currentStep == 1 {
//                            VStack(alignment: .leading, spacing: 15) {
//                                Text("请提供更多细节")
//                                    .font(.headline)
//                                
//                                Text("这将帮助我们更准确地分析您的症状")
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                                
//                                VStack(alignment: .leading, spacing: 20) {
//                                    ForEach(questions.indices, id: \.self) { index in
//                                        VStack(alignment: .leading, spacing: 10) {
//                                            Text("\(index + 1). \(questions[index].text)")
//                                                .font(.subheadline)
//                                                .fontWeight(.medium)
//                                            
//                                            VStack(spacing: 8) {
//                                                ForEach(questions[index].options.indices, id: \.self) { optionIndex in
//                                                    Button(action: {
//                                                        var updatedQuestions = questions
//                                                        updatedQuestions[index].answer = questions[index].options[optionIndex]
//                                                        questions = updatedQuestions
//                                                    }) {
//                                                        HStack {
//                                                            Text(questions[index].options[optionIndex])
//                                                                .foregroundColor(.primary)
//                                                            
//                                                            Spacer()
//                                                            
//                                                            if questions[index].answer == questions[index].options[optionIndex] {
//                                                                Image(systemName: "checkmark.circle.fill")
//                                                                    .foregroundColor(.blue)
//                                                            } else {
//                                                                Image(systemName: "circle")
//                                                                    .foregroundColor(.gray)
//                                                            }
//                                                        }
//                                                        .padding()
//                                                        .background(
//                                                            questions[index].answer == questions[index].options[optionIndex] ?
//                                                            Color.blue.opacity(0.1) : Color(.systemGray6)
//                                                        )
//                                                        .cornerRadius(10)
//                                                    }
//                                                }
//                                            }
//                                        }
//                                        
//                                        if index < questions.count - 1 {
//                                            Divider()
//                                        }
//                                    }
//                                }
//                                
//                                VStack(alignment: .leading, spacing: 10) {
//                                    Text("补充说明 (选填)")
//                                        .font(.subheadline)
//                                        .fontWeight(.medium)
//                                    
//                                    TextEditor(text: $description)
//                                        .frame(minHeight: 100)
//                                        .padding(5)
//                                        .background(Color(.systemGray6))
//                                        .cornerRadius(10)
//                                        .overlay(
//                                            RoundedRectangle(cornerRadius: 10)
//                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                                        )
//                                }
//                                .padding(.top, 10)
//                            }
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(16)
//                            .shadow(color: Color.black.opacity(0.05), radius: 5)
//                        }
//                        
//                        // 步骤3: AI分析
//                        if currentStep == 2 {
//                            VStack(alignment: .leading, spacing: 15) {
//                                Text("AI症状分析")
//                                    .font(.headline)
//                                
//                                if isGeneratingDescription {
//                                    VStack(spacing: 20) {
//                                        ProgressView()
//                                            .scaleEffect(1.5)
//                                            .padding()
//                                        
//                                        Text("AI正在分析您的症状...")
//                                            .font(.subheadline)
//                                            .foregroundColor(.gray)
//                                    }
//                                    .frame(maxWidth: .infinity, alignment: .center)
//                                    .padding()
//                                } else {
//                                    VStack(alignment: .leading, spacing: 15) {
//                                        Text("根据您提供的信息")
//                                            .font(.subheadline)
//                                            .foregroundColor(.gray)
//                                        
//                                        HStack(alignment: .top, spacing: 10) {
//                                            Image(systemName: "text.bubble.fill")
//                                                .foregroundColor(.blue)
//                                                .padding(.top, 3)
//                                            
//                                            Text(generateAIDescription())
//                                                .font(.body)
//                                                .lineSpacing(5)
//                                        }
//                                        .padding()
//                                        .background(Color.blue.opacity(0.05))
//                                        .cornerRadius(16)
//                                        
//                                        Divider()
//                                        
//                                        Text("可能相关的症状")
//                                            .font(.subheadline)
//                                            .foregroundColor(.gray)
//                                        
//                                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
//                                            ForEach(relatedSymptoms(), id: \.self) { symptom in
//                                                Button(action: {
//                                                    if !symptoms.contains(symptom) {
//                                                        symptoms.append(symptom)
//                                                        currentStep = 0 // 返回第一步添加新症状
//                                                    }
//                                                }) {
//                                                    HStack {
//                                                        Text(symptom)
//                                                            .font(.caption)
//                                                        
//                                                        Image(systemName: "plus.circle")
//                                                            .font(.caption)
//                                                    }
//                                                    .padding(.vertical, 5)
//                                                    .padding(.horizontal, 10)
//                                                    .background(Color.gray.opacity(0.1))
//                                                    .cornerRadius(15)
//                                                }
//                                            }
//                                        }
//                                        
//                                        Divider()
//                                        
//                                        VStack(alignment: .leading, spacing: 10) {
//                                            Text("重要提示")
//                                                .font(.subheadline)
//                                                .foregroundColor(.red)
//                                            
//                                            Text("AI分析仅供参考，不构成医疗诊断。如有严重症状，请立即就医。")
//                                                .font(.caption)
//                                                .foregroundColor(.gray)
//                                                .padding()
//                                                .background(Color.red.opacity(0.05))
//                                                .cornerRadius(10)
//                                        }
//                                        
//                                        HStack {
//                                            Button(action: {
//                                                // 复制到剪贴板
//                                            }) {
//                                                HStack {
//                                                    Image(systemName: "doc.on.doc")
//                                                    Text("复制描述")
//                                                }
//                                                .font(.subheadline)
//                                                .foregroundColor(.blue)
//                                                .padding(.vertical, 8)
//                                                .padding(.horizontal, 15)
//                                                .background(Color.blue.opacity(0.1))
//                                                .cornerRadius(20)
//                                            }
//                                            
//                                            Spacer()
//                                            
//                                            Button(action: {
//                                                // 推荐科室
//                                            }) {
//                                                HStack {
//                                                    Image(systemName: "cross.case")
//                                                    Text("推荐科室")
//                                                }
//                                                .font(.subheadline)
//                                                .foregroundColor(.blue)
//                                                .padding(.vertical, 8)
//                                                .padding(.horizontal, 15)
//                                                .background(Color.blue.opacity(0.1))
//                                                .cornerRadius(20)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                            .padding()
//                            .background(Color.white)
//                            .cornerRadius(16)
//                            .shadow(color: Color.black.opacity(0.05), radius: 5)
//                            .onAppear {
//                                isGeneratingDescription = true
//                                
//                                // 模拟AI分析过程
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                                    isGeneratingDescription = false
//                                    generatedDescription = generateAIDescription()
//                                }
//                            }
//                        }
//                    }
//                    .padding()
//                }
//                
//                Spacer()
//                
//                // 底部按钮区域
//                HStack {
//                    if currentStep > 0 {
//                        Button(action: {
//                            withAnimation {
//                                currentStep -= 1
//                            }
//                        }) {
//                            HStack {
//                                Image(systemName: "chevron.left")
//                                Text("上一步")
//                            }
//                            .foregroundColor(.blue)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.blue.opacity(0.1))
//                            .cornerRadius(10)
//                        }
//                    }
//                    
//                    if currentStep < 2 {
//                        Button(action: {
//                            withAnimation {
//                                if currentStep == 0 && symptoms.isEmpty {
//                                    // 没有症状，不能继续
//                                    return
//                                }
//                                currentStep += 1
//                            }
//                        }) {
//                            HStack {
//                                Text(currentStep == 0 ? "继续" : "生成分析")
//                                Image(systemName: "chevron.right")
//                            }
//                            .foregroundColor(.white)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(symptoms.isEmpty && currentStep == 0 ? Color.gray : Color.blue)
//                            
//                            .cornerRadius(10)
//                            .disabled(symptoms.isEmpty && currentStep == 0)
//                        }
//                    }
//                    
//                    if currentStep == 2 {
//                        Button(action: {
//                            presentationMode.wrappedValue.dismiss()
//                        }) {
//                            Text("完成并保存")
//                                .foregroundColor(.white)
//                                .padding()
//                                .frame(maxWidth: .infinity)
//                                .background(Color.blue)
//                                .cornerRadius(10)
//                        }
//                    }
//                }
//                .padding()
//                .background(Color.white)
//                .cornerRadius(16, corners: [.topLeft, .topRight])
//                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
//            }
//            .navigationTitle("AI症状描述助手")
//            .navigationBarItems(trailing: Button("关闭") {
//                presentationMode.wrappedValue.dismiss()
//            })
//        }
//        
//        // 生成AI描述
//        private func generateAIDescription() -> String {
//            var description = "患者"
//            
//            // 添加性别和年龄（假设数据）
//            description += "，男，35岁，"
//            
//            // 添加主要症状
//            if !symptoms.isEmpty {
//                description += "主诉"
//                for (index, symptom) in symptoms.enumerated() {
//                    if index == 0 {
//                        description += "\(symptom)"
//                    } else if index == symptoms.count - 1 {
//                        description += "和\(symptom)"
//                    } else {
//                        description += "、\(symptom)"
//                    }
//                }
//            }
//            
//            // 添加症状持续时间
//            if let durationAnswer = questions.first(where: { $0.id == 1 })?.answer {
//                description += "，症状持续\(durationAnswer)"
//            }
//            
//            // 添加症状加重时间
//            if let timingAnswer = questions.first(where: { $0.id == 2 })?.answer {
//                description += "，\(timingAnswer)症状加重"
//            }
//            
//            // 添加加重因素
//            if let factorAnswer = questions.first(where: { $0.id == 3 })?.answer {
//                if factorAnswer != "不确定" {
//                    description += "，\(factorAnswer)后症状明显"
//                }
//            }
//            
//            // 添加用户自己的描述
//            if !self.description.isEmpty {
//                description += "。患者表示："\(self.description)""
//            } else {
//                description += "。"
//            }
//            
//            // 添加推荐就医建议
//            description += "\n\n建议就医科室：" + recommendDepartment()
//            
//            return description
//        }
//        
//        // 根据症状推荐科室
//        private func recommendDepartment() -> String {
//            let symptomDepartments = [
//                "头痛": ["神经内科", "疼痛科"],
//                "发热": ["内科", "感染科"],
//                "咳嗽": ["呼吸科", "内科"],
//                "恶心": ["消化内科", "内科"],
//                "腹痛": ["消化内科", "普外科"],
//                "头晕": ["神经内科", "心内科"],
//                "乏力": ["内科", "内分泌科"],
//                "腹泻": ["消化内科", "感染科"],
//                "胸痛": ["心内科", "胸外科"]
//            ]
//            
//            var departments = Set<String>()
//            for symptom in symptoms {
//                if let depts = symptomDepartments[symptom] {
//                    departments.formUnion(depts)
//                }
//            }
//            
//            if departments.isEmpty {
//                return "全科医学科（建议先咨询全科医生）"
//            } else if departments.count == 1 {
//                return departments.first!
//            } else {
//                return departments.joined(separator: "或")
//            }
//        }
//        
//        // 生成相关症状建议
//        private func relatedSymptoms() -> [String] {
//            let relatedSymptomsMap = [
//                "头痛": ["头晕", "恶心", "视力模糊"],
//                "发热": ["咳嗽", "乏力", "喉咙痛"],
//                "咳嗽": ["胸痛", "呼吸困难", "喉咙痛"],
//                "恶心": ["呕吐", "腹痛", "腹泻"],
//                "腹痛": ["腹泻", "便秘", "恶心"],
//                "头晕": ["乏力", "视力模糊", "平衡障碍"],
//                "乏力": ["食欲不振", "体重下降", "失眠"],
//                "腹泻": ["腹痛", "恶心", "脱水"],
//                "胸痛": ["呼吸困难", "心悸", "出汗"]
//            ]
//            
//            var related = Set<String>()
//            for symptom in symptoms {
//                if let relatedList = relatedSymptomsMap[symptom] {
//                    related.formUnion(relatedList)
//                }
//            }
//            
//            // 移除已有症状
//            for symptom in symptoms {
//                related.remove(symptom)
//            }
//            
//            return Array(related).prefix(5).map { $0 }
//        }
//    }
//    
//    struct Question {
//        var id: Int
//        var text: String
//        var options: [String]
//        var answer: String?
//    }
//    
//    struct MedicalAssistantView_Previews: PreviewProvider {
//        static var previews: some View {
//            MedicalAssistantView()
//        }
//    }
//}

