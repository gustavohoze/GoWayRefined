import SwiftUI

struct ParkingView: View {
    @ObservedObject var viewModel = VendorViewModel.shared
    @EnvironmentObject var navigationVM: NavigationViewModel // Add this
    
    var body: some View {
        // Remove the NavigationStack as it's now part of HomeView
        ZStack {
            Color.white
            VStack {
                SearchHeader(searchText: $viewModel.searchText)
                if viewModel.hasVendors {
                    ScrollView {
                        VStack {
                            ForEach(viewModel.filteredVendors, id: \.id) { vendor in
                                let buildingName = viewModel.getBuildingName(for: vendor)
                                
                     
                                Button(action: {
                                    navigationVM.navigate(to: .vendorDetail(vendor: vendor, isRecommended: false))
                                }) {
                                    VendorCard(
                                        vendorName: vendor.name,
                                        vendorType: vendor.type.description(),
                                        buildingName: buildingName,
                                        vendorImage: vendor.image,
                                        rating: vendor.rating,
                                        items: vendor.tarifList?.map { $0.vehicleType }
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
                } else {
                    Text("No busway vendors found")
                    Spacer()
                }
            }
            .ignoresSafeArea().navigationBarBackButtonHidden()
        }
        .onAppear {
            // Switch to busway vendors when view appears
            viewModel.switchToParkingVendors()
        }
    }
}
