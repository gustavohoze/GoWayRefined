import SwiftUI
import CoreLocation

struct HomeView: View {
    // Reference to the shared NavigationViewModel
    @ObservedObject var navigationViewModel: NavigationViewModel
    
    // HomeViewModel initialized with the shared NavigationViewModel
    @StateObject private var viewModel: HomeViewModel
    
    // Initialize with the shared NavigationViewModel
    init(navigationViewModel: NavigationViewModel) {
        self.navigationViewModel = navigationViewModel
        self._viewModel = StateObject(wrappedValue: HomeViewModel(navigationViewModel: navigationViewModel))
    }
    
    var body: some View {
        NavigationStack(path: $navigationViewModel.navPath) {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    ScrollView {
                        HomeHeader(navigationVM: navigationViewModel)
                        HomeGrid(navigationVM: navigationViewModel)
                        HomeRecommendation(navigationVM: navigationViewModel)
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
        .onAppear {
            viewModel.requestLocationPermission()
        }
    }
}

