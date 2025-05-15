import SwiftUI


// MARK: - Main View
struct VendorDetailView: View {
    var vendor: Vendor
    var isRecomended: Bool = false
    @ObservedObject var viewModel = VendorViewModel.shared
    @Environment(\.presentationMode) var presentationMode
    
    // Function to check if image exists, fallback to SF Symbol if not
    func getImage(for imageName: String) -> AnyView {
        if let _ = UIImage(named: imageName) {
            return AnyView(
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            )
        } else {
            // Fallback to SF Symbol if the image is not found
            return AnyView(
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            )
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Fixed header at the top
            SearchHeader(searchText: $viewModel.searchText, vendor: vendor, isRecomended: isRecomended)
            
            // Scrollable content
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    // Vendor image and name
                    VendorHeaderView(vendor: vendor)
                    
                    // Conditional sections
                    if let routeList = vendor.routeList, !routeList.isEmpty {
                        RoutesSection(routeList: routeList, getImage: getImage)
                    }
                    
                    if let foodList = vendor.foodList, !foodList.isEmpty {
                        MenuSection(foodList: foodList, getImage: getImage)
                    }
                    
                    if let movieList = vendor.movieList, !movieList.isEmpty {
                        MoviesSection(movieList: movieList, getImage: getImage)
                    }
                    
                    if let clothList = vendor.clothList, !clothList.isEmpty {
                        ClothingSection(clothList: clothList, getImage: getImage)
                    }
                    
                    if let tarifList = vendor.tarifList, !tarifList.isEmpty {
                        TarifSection(tarifList: tarifList)
                    }
                    
                    if let scheduleList = vendor.scheduleList, !scheduleList.isEmpty {
                        ScheduleSection(scheduleList: scheduleList)
                    }
                    
                    if let stepList = vendor.stepList, !stepList.isEmpty {
                        StepsSection(vendor: vendor, stepList: stepList)
                    }
                }
                .padding(.horizontal)
            }.scrollIndicators(.visible)
        }.foregroundStyle(.black)
        .background(.white)
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden()
    }
}

// Vendor Header View



#Preview(){
    VendorDetailView(vendor: Vendor(name: "Vendor 1", image: "busway", type: .food, foodList: [Food(name: "Food 1", image: "busway", price: 10.0, description: "Lorem ipsum dolor sit amet")]), isRecomended: true)
}
