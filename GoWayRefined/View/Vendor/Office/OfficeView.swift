import SwiftUI
import CoreLocation
import Combine

struct OfficeView: View {
    var buildings: [Building] = BuildingDataModel.shared.getAllBuildings()
    @State var searchText: String = ""
    
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
        NavigationStack {
            ZStack{
                Color.white
                
                VStack {
                    SearchHeader(searchText: $searchText)
                    
                    if !filteredBuildings.isEmpty {
                        ScrollView {
                            VStack {
                                ForEach(filteredBuildings, id: \.id) { building in
                                    NavigationLink(destination: BuildingDetailView(building: building)) {
                                        BuildingCard(
                                            buildingName: building.name,
                                            buildingImage: building.image,
                                            latitude: building.latitude,
                                            longitude: building.longitude,
                                            rating: building.rating,
                                            items: building.vendors
                                            // No need to pass userLocation here anymore
                                        )
                                    }
                                    .padding(.bottom, 10)
                                }
                            }
                            .navigationBarBackButtonHidden()
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
                }.ignoresSafeArea()
            }
        }
        // No need for onAppear anymore - the StateObject will handle location updates
    }
}

#Preview {
    OfficeView()
}
