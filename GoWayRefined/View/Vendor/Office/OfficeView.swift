import SwiftUI
import CoreLocation
import Combine

struct OfficeView: View {
    var buildings: [Building] = BuildingDataModel.shared.getAllBuildings()
    @State var searchText: String = ""
    @EnvironmentObject var navigationVM: NavigationViewModel
    
    // Use StateObject to maintain the LocationManager instance throughout the view lifecycle
    @StateObject private var locationManager = LocationManager.shared
    
    var filteredBuildings: [Building] {
        if searchText.isEmpty {
            return buildings
        } else {
            return buildings.filter { building in
                building.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        // Remove the NavigationStack as it's now part of HomeView
        ZStack {
            Color.white
            
            VStack {
                SearchHeader(searchText: $searchText)
                
                if !filteredBuildings.isEmpty {
                    ScrollView {
                        VStack {
                            ForEach(filteredBuildings, id: \.id) { building in
                                // Replace NavigationLink with Button
                                Button {
                                    // Navigate to building detail
                                    navigationVM.navigate(to: .buildingDetail(building: building))
                                } label: {
                                    BuildingCard(
                                        buildingName: building.name,
                                        buildingImage: building.image,
                                        latitude: building.latitude,
                                        longitude: building.longitude,
                                        rating: building.rating,
                                        items: building.vendors
                                    )
                                }
                                .padding(.bottom, 10)
                            }
                        }
                        .padding(.top, 10)
                    }
                    .foregroundStyle(.black)
                    .frame(height: 700)
                    .padding(.horizontal, 10)
                }
                else {
                    Text("No buildings found")
                        .foregroundStyle(.black)
                    Spacer()
                }
            }
            .ignoresSafeArea()
        }.navigationBarBackButtonHidden().background(.white)
    }
}

#Preview {
    // Create a mock NavigationViewModel for preview
    let navVM = NavigationViewModel()
    
    return OfficeView()
        .environmentObject(navVM)
}
