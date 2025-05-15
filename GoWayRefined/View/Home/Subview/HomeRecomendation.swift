import SwiftUI

// Updated HomeRecommendation to use the new cards
struct HomeRecommendation: View {
    // Use @State to ensure the random buildings are only generated once
    @State private var randomBuildings: [Building] = []
    var navigationVM: NavigationViewModel
    
    // Initialize the random buildings in onAppear instead of during initialization
    func initializeRandomBuildings() {
        // Only initialize if the array is empty
        if randomBuildings.isEmpty {
            randomBuildings = BuildingDataModel.shared.getRandomBuildingsWithVendors(count: 5)
        }
    }
    
    func getVendorItems(_ vendor: Vendor) -> [String]? {
        switch vendor.type {
        case .food:
            return vendor.foodList?.map { $0.name }
        case .entertainment:
            return vendor.movieList?.map { $0.name }
        case .busway:
            return vendor.routeList?.map { $0.name }
        case .parkingLot:
            return vendor.tarifList?.map { $0.vehicleType }
        case .lifestyle:
            return vendor.clothList?.map { $0.name }
        case .worship:
            return vendor.scheduleList?.map { $0.hour }
        case .other:
            return nil
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Places you might like")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(randomBuildings) { building in
                        if let randomVendor = building.vendors.randomElement() {
                    
                            Button(action: {
                                navigationVM.navigate(to: .vendorDetail(vendor: randomVendor, isRecommended: true))
                            }) {
                                RecommendationCard(
                                    vendorName: randomVendor.name,
                                    buildingName: building.name,
                                    vendorImage: randomVendor.image,
                                    items: getVendorItems(randomVendor)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            
                .padding(5)
            }
        }
        .onAppear {
            initializeRandomBuildings()
        }
    }
}

#Preview {
    HomeRecommendation(navigationVM: NavigationViewModel())
}
