import SwiftUI

struct SearchView: View {
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = SearchViewModel()
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            SearchHeader(searchText: $searchText)
                .onChange(of: searchText) { _, newValue in
                    viewModel.search(query: newValue)
                }
            
            if searchText.isEmpty {
                // Show suggestions or recently viewed when no search
                EmptySearchView()
            } else {
                // Show search results
                ScrollView {
                    VStack(spacing: 15) {
                        // Results count
                        HStack {
                            Text("\(viewModel.totalResultsCount) results found")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // Buildings section
                        if !viewModel.buildingResults.isEmpty {
                            ResultsSection(
                                title: "Buildings",
                                count: viewModel.buildingResults.count
                            ) {
                                ForEach(viewModel.buildingResults, id: \.name) { building in
                                    NavigationLink(destination: BuildingDetailView(building: building)) {
                                        BuildingCard(
                                            buildingName: building.name,
                                            buildingImage: building.image,
                                            latitude: building.latitude,
                                            longitude: building.longitude,
                                            rating: building.rating,
                                            items: building.vendors.isEmpty ? nil : Array(building.vendors.prefix(5))
                                        )
                                    }
                                    .foregroundColor(.black)
                                    .padding(.bottom, 5)
                                }
                            }
                        }
                        
                        // Vendors section
                        // In SearchView
                        if !viewModel.vendorResults.isEmpty {
                            ResultsSection(
                                title: "Vendors",
                                count: viewModel.vendorResults.count
                            ) {
                                ForEach(viewModel.vendorResults, id: \.vendor.id) { vendorResult in
                                    let vendor = vendorResult.vendor
                                    let buildingName = vendorResult.buildingName
                                    
                                    NavigationLink(destination: VendorDetailView(vendor: vendor)) {
                                        VendorCard(
                                            vendorName: vendor.name,
                                            vendorType: vendor.type.description(),
                                            buildingName: buildingName,
                                            vendorImage: vendor.image,
                                            rating: vendor.rating,
                                            items: viewModel.getVendorItems(vendor)
                                        )
                                    }
                                    .foregroundColor(.black)
                                    .padding(.bottom, 5)
                                }
                            }
                        }
                        
                        // No results message
                        if viewModel.totalResultsCount == 0 && !searchText.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray)
                                
                                Text("No results found for '\(searchText)'")
                                    .font(.headline)
                                
                                Text("Try a different search term or browse categories")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 50)
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
        .background(.white).ignoresSafeArea()
        .foregroundStyle(.black)
        .onAppear {
            isTextFieldFocused = true
        }.ignoresSafeArea()
            .navigationBarBackButtonHidden()
    }
    

    
    // Helper function to get items for vendor
    private func getVendorItems(_ vendor: Vendor) -> [String]? {
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
}
// View Model for the Search View


// Section header for search results
struct ResultsSection<Content: View>: View {
    let title: String
    let count: Int
    let content: Content
    
    init(title: String, count: Int, @ViewBuilder content: () -> Content) {
        self.title = title
        self.count = count
        self.content = content()
    }
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                
                Text("(\(count))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.horizontal)
            
            content
        }
        .padding(.top, 10)
    }
}

// View for empty search state
struct EmptySearchView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "building.2")
                .font(.system(size: 70))
                .foregroundColor(.gray)
            
            Text("Search for buildings or vendors")
                .font(.title2)
                .fontWeight(.medium)
            
            Text("Try searching for names, types, or features")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchView()
        }
    }
}
