import SwiftUI
import CoreLocation

struct HomeView: View {
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var navigationVM = NavigationViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationVM.navPath) {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    ScrollView {
                        HomeHeader(navigationVM: navigationVM)
                        HomeGrid(navigationVM: navigationVM)
                        HomeRecommendation(navigationVM: navigationVM)
                        HomeRating()
                        Spacer()
                    }
                    .ignoresSafeArea()
                }
            }
            .navigationDestination(for: AppDestination.self) { destination in
                switch destination {
                
                case .search:
                    SearchView()
                case .busway:
                    BuswayView()
                case .entertainment:
                    EntertainmentView()
                case .food:
                    FoodView()
                case .office:
                    OfficeView()
                case .parking:
                    ParkingView()
                case .lifestyle:
                    LifestyleView()
                case .praying:
                    PrayingView()
                case .other:
                    OtherView()
                    
                    // Vendor detail with optional isRecommended flag
                case .vendorDetail(let vendor, let isRecommended):
                    if let isRecommended = isRecommended {
                        VendorDetailView(vendor: vendor, isRecomended: isRecommended)
                    } else {
                        VendorDetailView(vendor: vendor)
                    }
                case .arNavigation(let vendor):
                    ARNavigationView(vendor: vendor)
                    
                case .arOnboarding(let vendor):
                    AROnboardingView(vendor: vendor)
                    
                case .stepNavigation(let vendor, let steps):
                    StepNavigationView(steps: steps, vendor: vendor)
                case .buildingDetail(let building):
                    BuildingDetailView(building: building)

                }
            }
        }
        .environmentObject(navigationVM)
        .onAppear {
            requestLocationPermission()
        }
    }
    
    // Function to explicitly request location permission
    private func requestLocationPermission() {
        // Check current status first
        let status = locationManager.authorizationStatus
        
        if status == .notDetermined {
            // This will trigger the permission popup
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
