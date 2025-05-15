import SwiftUI

struct OtherView: View {
    @ObservedObject var viewModel = VendorViewModel.shared
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.white
                
                VStack {
                    SearchHeader(searchText: $viewModel.searchText)
                    
                    if viewModel.hasVendors {
                        ScrollView {
                            VStack {
                                ForEach(viewModel.filteredVendors, id: \.id) { vendor in
                                    let buildingName = viewModel.getBuildingName(for: vendor)
                                    
                                    NavigationLink(destination: VendorDetailView(vendor: vendor)) {
                                        VendorCard(
                                            vendorName: vendor.name,
                                            vendorType: vendor.type.description(),
                                            buildingName: buildingName,
                                            vendorImage: vendor.image,
                                            rating: vendor.rating,
                                            items: vendor.routeList?.map { $0.name }
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
                    } else {
                        Text("No food vendors found")
                        Spacer()
                    }
                }.ignoresSafeArea()
            }
            .onAppear {
                // Switch to food vendors when view appears
                viewModel.switchToOtherVendors()
            }
        }
    }
}
