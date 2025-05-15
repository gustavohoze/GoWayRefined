import SwiftUI
import CoreLocation

struct BuildingDetailView: View {
    @ObservedObject var viewModel: BuildingDetailViewModel
    @State private var showingMapModal = false
    @State private var searchText = "" // Local state for search text
    
    init(building: Building) {
        viewModel = BuildingDetailViewModel(building: building)
    }
    
    var body: some View {
        ZStack {
            // ScrollView containing the content
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    Spacer().frame(height: 120)
                    
                    // Building Image
                    Image(viewModel.building.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .padding(.top)
                    
                    // Building Information
                    Text(viewModel.building.name).font(.title).multilineTextAlignment(.center)
                    
                    // Display distance and show map button
                    HStack {
                        Text(viewModel.distanceFromUser())
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        Text(" | ")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        
                        // Show in map button
                        Text("Show in map")
                            .font(.footnote)
                            .foregroundColor(.green)
                            .onTapGesture {
                                showingMapModal = true
                            }
                    }
                    
                    // Scrollable Segmented Control for vendor type selection
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            // "All" button
                            FilterButton(
                                title: "All",
                                isSelected: viewModel.selectedVendorType == nil,
                                action: { viewModel.selectVendorType(nil) }
                            )
                            
                            // Vendor type buttons
                            ForEach(viewModel.vendorTypes, id: \.self) { type in
                                FilterButton(
                                    title: type.description(),
                                    isSelected: viewModel.selectedVendorType == type,
                                    action: { viewModel.selectVendorType(type) }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }.padding(.bottom, 15)
                    
                    // Display vendors
                    if !viewModel.filteredVendors.isEmpty {
                        ForEach(viewModel.filteredVendors, id: \.name) { vendor in
                            NavigationLink(destination: VendorDetailView(vendor: vendor)) {
                                VendorCard(
                                    vendorName: vendor.name,
                                    vendorType: vendor.type.description(),
                                    buildingName: viewModel.building.name,
                                    vendorImage: vendor.image,
                                    rating: vendor.rating,
                                    items: viewModel.getVendorItems(vendor)
                                )
                            }
                            .foregroundColor(.black)
                        }
                    } else {
                        Text("No vendors match your search.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.top)
                    }
                    
                    Spacer()
                }
                .padding(.bottom, 5)
            }
            .foregroundStyle(.black)
            .background(.white)
            .navigationBarBackButtonHidden()
            
            // Sticky SearchHeader at the top
            VStack {
                SearchHeader(searchText: $searchText, building: viewModel.building)
                    .zIndex(1) // Make sure the header stays on top of other content
                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
        .ignoresSafeArea(edges: .top) // Avoids content being hidden under the header
        .onChange(of: searchText) { _, newValue in
            viewModel.searchText = newValue
        }
        .sheet(isPresented: $showingMapModal) {
            NavigationView {
                MapDirectionsView(
                    destinationName: viewModel.building.name,
                    destinationCoordinate: CLLocationCoordinate2D(
                        latitude: viewModel.building.latitude,
                        longitude: viewModel.building.longitude
                    )
                )
                .navigationTitle("Directions")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Close") {
                            showingMapModal = false
                        }
                    }
                }
            }
        }
    }
}

struct BuildingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BuildingDetailView(building: Building(name: "GOP 1", image: "office", latitude: 10.0, longitude: 10.0, vendors: [], rating: 5.0))
            .previewLayout(.sizeThatFits)
    }
}
