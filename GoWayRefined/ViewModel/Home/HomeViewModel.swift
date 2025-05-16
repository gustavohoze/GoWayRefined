import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    // Dependencies
    private let locationManager = LocationManager.shared
    private let navigationManager = AppNavigationManager.shared
    
    // Reference to the NavigationViewModel
    let navigationViewModel: NavigationViewModel
    
    // Cancellables for managing subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // Initialize with an existing NavigationViewModel
    init(navigationViewModel: NavigationViewModel) {
        self.navigationViewModel = navigationViewModel
        setupNavigationObservers()
    }
    
    // Request location permissions
    func requestLocationPermission() {
        let status = locationManager.authorizationStatus
        
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Setup observers for navigation changes
    private func setupNavigationObservers() {
        // Observe changes to building navigation
        navigationManager.$buildingToNavigateTo
            .compactMap { $0 } // Only proceed if not nil
            .receive(on: DispatchQueue.main)
            .sink { [weak self] building in
                guard let self = self else { return }
                
                print("HomeViewModel: Detected building navigation: \(building.name)")
                
                // Completely reset navigation by creating a new path
                self.navigationViewModel.navPath = NavigationPath()
                
                // Small delay to ensure UI is ready
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    // Navigate to the building
                    self.navigationViewModel.navigate(to: .buildingDetail(building: building))
                    
                    // Reset navigation manager after navigation is complete
                    self.navigationManager.buildingToNavigateTo = nil
                }
            }
            .store(in: &cancellables)
        
        // Observe changes to vendor navigation
        navigationManager.$vendorToNavigateTo
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] vendor in
                guard let self = self else { return }
                
                print("HomeViewModel: Detected vendor navigation: \(vendor.name)")
                
                // Completely reset navigation by creating a new path
                self.navigationViewModel.navPath = NavigationPath()
                
                // Small delay to ensure UI is ready
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    // Navigate to the vendor
                    self.navigationViewModel.navigate(to: .vendorDetail(vendor: vendor, isRecommended: nil))
                    
                    // Reset navigation manager after navigation is complete
                    self.navigationManager.vendorToNavigateTo = nil
                }
            }
            .store(in: &cancellables)
        
        // Observe changes to vendor type navigation
        navigationManager.$vendorTypeToNavigateTo
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                guard let self = self else { return }
                
                print("HomeViewModel: Detected vendor type navigation: \(type.description())")
                
                // Completely reset navigation by creating a new path
                self.navigationViewModel.navPath = NavigationPath()
                
                // Small delay to ensure UI is ready
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    // Navigate to the appropriate view based on vendor type
                    switch type {
                    case .food:
                        self.navigationViewModel.navigate(to: .food)
                    case .entertainment:
                        self.navigationViewModel.navigate(to: .entertainment)
                    case .busway:
                        self.navigationViewModel.navigate(to: .busway)
                    case .parkingLot:
                        self.navigationViewModel.navigate(to: .parking)
                    case .lifestyle:
                        self.navigationViewModel.navigate(to: .lifestyle)
                    case .worship:
                        self.navigationViewModel.navigate(to: .praying)
                    case .other:
                        self.navigationViewModel.navigate(to: .other)
                    }
                    
                    // Reset navigation manager after navigation is complete
                    self.navigationManager.vendorTypeToNavigateTo = nil
                }
            }
            .store(in: &cancellables)
    }
}
