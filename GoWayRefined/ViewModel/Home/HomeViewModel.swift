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
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                // Execute the navigation
                self.navigationManager.executeNavigation()
            }
            .store(in: &cancellables)
        
        // Observe changes to vendor navigation
        navigationManager.$vendorToNavigateTo
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                // Execute the navigation
                self.navigationManager.executeNavigation()
            }
            .store(in: &cancellables)
        
        // Observe changes to vendor type navigation
        navigationManager.$vendorTypeToNavigateTo
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                // Execute the navigation
                self.navigationManager.executeNavigation()
            }
            .store(in: &cancellables)
    }
}
