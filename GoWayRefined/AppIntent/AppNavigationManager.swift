import SwiftUI
import Combine

class AppNavigationManager: ObservableObject {
    static let shared = AppNavigationManager()
    
    // Single navigation state enum to track what's being navigated to
    enum NavigationState {
        case idle
        case navigatingToBuilding(Building)
        case navigatingToVendor(Vendor)
        case navigatingToVendorType(VendorType)
    }
    
    // Current navigation state
    @Published private(set) var currentState: NavigationState = .idle
    
    // Published properties as convenience accessors
    @Published var buildingToNavigateTo: Building?
    @Published var vendorToNavigateTo: Vendor?
    @Published var vendorTypeToNavigateTo: VendorType?
    
    // Reference to the shared NavigationViewModel
    private var navigationViewModel: NavigationViewModel?
    
    // Debounce timer to prevent rapid navigation changes
    private var navigationDebounceTimer: Timer?
    private var isProcessingNavigation = false
    
    private init() {}
    
    // Set the shared NavigationViewModel
    func setSharedNavigationViewModel(_ viewModel: NavigationViewModel) {
        self.navigationViewModel = viewModel
        print("NavigationManager: Received shared NavigationViewModel")
    }
    
    // Clear all navigation state
    func clearNavigationState() {
        print("NavigationManager: Clearing all navigation state")
        
        // Cancel any pending debounce timer
        navigationDebounceTimer?.invalidate()
        navigationDebounceTimer = nil
        
        // Clear UserDefaults
        UserDefaults.standard.removeObject(forKey: "pendingBuildingNavigation")
        UserDefaults.standard.removeObject(forKey: "pendingVendorNavigation")
        UserDefaults.standard.removeObject(forKey: "pendingVendorTypeNavigation")
        
        // Reset state
        DispatchQueue.main.async {
            self.currentState = .idle
            self.buildingToNavigateTo = nil
            self.vendorToNavigateTo = nil
            self.vendorTypeToNavigateTo = nil
            self.isProcessingNavigation = false
        }
    }
    
    // Check for pending navigation requests
    func checkPendingNavigationRequests() {
        // Only check if we're not already processing navigation
        guard !isProcessingNavigation else {
            print("NavigationManager: Already processing navigation, skipping check")
            return
        }
        
        // Check building navigation first
        if let buildingIDString = UserDefaults.standard.string(forKey: "pendingBuildingNavigation"),
           let buildingID = UUID(uuidString: buildingIDString) {
            
            // Clear from UserDefaults immediately
            UserDefaults.standard.removeObject(forKey: "pendingBuildingNavigation")
            
            // Find the building
            let allBuildings = BuildingDataModel.shared.getAllBuildings()
            if let building = allBuildings.first(where: { $0.id == buildingID }) {
                print("NavigationManager: Found pending building navigation: \(building.name)")
                navigateToBuilding(building)
                return
            }
        }
        
        // Check vendor navigation
        if let vendorIDString = UserDefaults.standard.string(forKey: "pendingVendorNavigation"),
           let vendorID = UUID(uuidString: vendorIDString) {
            
            // Clear from UserDefaults immediately
            UserDefaults.standard.removeObject(forKey: "pendingVendorNavigation")
            
            // Find the vendor
            let allVendors = BuildingDataModel.shared.getAllBuildings().flatMap { $0.vendors }
            if let vendor = allVendors.first(where: { $0.id == vendorID }) {
                print("NavigationManager: Found pending vendor navigation: \(vendor.name)")
                navigateToVendor(vendor)
                return
            }
        }
        
        // Check vendor type navigation
        if let typeString = UserDefaults.standard.string(forKey: "pendingVendorTypeNavigation"),
           let type = VendorType(rawValue: typeString) {
            
            // Clear from UserDefaults immediately
            UserDefaults.standard.removeObject(forKey: "pendingVendorTypeNavigation")
            
            print("NavigationManager: Found pending vendor type navigation: \(type.description())")
            navigateToVendorType(type)
        }
    }
    
    // MARK: - Navigation Methods
    
    func navigateToBuilding(_ building: Building) {
        // Prevent navigation if we're already processing or there's a pending timer
        guard !isProcessingNavigation && navigationDebounceTimer == nil else {
            print("NavigationManager: Already navigating, ignoring request")
            return
        }
        
        print("NavigationManager: Preparing to navigate to building: \(building.name)")
        
        // Store in UserDefaults as a backup
        UserDefaults.standard.set(building.id.uuidString, forKey: "pendingBuildingNavigation")
        
        // Set flag to indicate we're processing navigation
        isProcessingNavigation = true
        
        // Update state
        DispatchQueue.main.async {
            self.currentState = .navigatingToBuilding(building)
            
            // Clear other published properties
            self.vendorToNavigateTo = nil
            self.vendorTypeToNavigateTo = nil
            
            // Set the building property last to trigger observers
            self.buildingToNavigateTo = building
        }
        
        // Start a debounce timer to ensure we don't navigate too frequently
        navigationDebounceTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            self?.navigationDebounceTimer = nil
            self?.isProcessingNavigation = false
        }
    }
    
    func navigateToVendor(_ vendor: Vendor) {
        // Prevent navigation if we're already processing or there's a pending timer
        guard !isProcessingNavigation && navigationDebounceTimer == nil else {
            print("NavigationManager: Already navigating, ignoring request")
            return
        }
        
        print("NavigationManager: Preparing to navigate to vendor: \(vendor.name)")
        
        // Store in UserDefaults as a backup
        UserDefaults.standard.set(vendor.id.uuidString, forKey: "pendingVendorNavigation")
        
        // Set flag to indicate we're processing navigation
        isProcessingNavigation = true
        
        // Update state
        DispatchQueue.main.async {
            self.currentState = .navigatingToVendor(vendor)
            
            // Clear other published properties
            self.buildingToNavigateTo = nil
            self.vendorTypeToNavigateTo = nil
            
            // Set the vendor property last to trigger observers
            self.vendorToNavigateTo = vendor
        }
        
        // Start a debounce timer to ensure we don't navigate too frequently
        navigationDebounceTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            self?.navigationDebounceTimer = nil
            self?.isProcessingNavigation = false
        }
    }
    
    func navigateToVendorType(_ type: VendorType) {
        // Prevent navigation if we're already processing or there's a pending timer
        guard !isProcessingNavigation && navigationDebounceTimer == nil else {
            print("NavigationManager: Already navigating, ignoring request")
            return
        }
        
        print("NavigationManager: Preparing to navigate to vendor type: \(type.description())")
        
        // Store in UserDefaults as a backup
        UserDefaults.standard.set(type.rawValue, forKey: "pendingVendorTypeNavigation")
        
        // Set flag to indicate we're processing navigation
        isProcessingNavigation = true
        
        // Update state
        DispatchQueue.main.async {
            self.currentState = .navigatingToVendorType(type)
            
            // Clear other published properties
            self.buildingToNavigateTo = nil
            self.vendorToNavigateTo = nil
            
            // Set the vendor type property last to trigger observers
            self.vendorTypeToNavigateTo = type
        }
        
        // Start a debounce timer to ensure we don't navigate too frequently
        navigationDebounceTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            self?.navigationDebounceTimer = nil
            self?.isProcessingNavigation = false
        }
    }
    
    // Method to execute the actual navigation using NavigationViewModel
    func executeNavigation() {
        guard let navVM = navigationViewModel else {
            print("Error: NavigationViewModel not set")
            isProcessingNavigation = false
            return
        }
        
        // Execute the navigation based on current state
        switch currentState {
        case .idle:
            print("NavigationManager: No navigation to execute")
            
        case .navigatingToBuilding(let building):
            print("NavigationManager: Executing navigation to building: \(building.name)")
            
            // First reset navigation
            navVM.goToRoot()
            
            // Short delay to ensure the navigation stack is clear
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Navigate to building
                navVM.navigate(to: .buildingDetail(building: building))
                
                // Clear state after successful navigation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.buildingToNavigateTo = nil
                }
            }
            
        case .navigatingToVendor(let vendor):
            print("NavigationManager: Executing navigation to vendor: \(vendor.name)")
            
            // First reset navigation
            navVM.goToRoot()
            
            // Short delay to ensure the navigation stack is clear
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Navigate to vendor
                navVM.navigate(to: .vendorDetail(vendor: vendor, isRecommended: nil))
                
                // Clear state after successful navigation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.vendorToNavigateTo = nil
                }
            }
            
        case .navigatingToVendorType(let type):
            print("NavigationManager: Executing navigation to vendor type: \(type.description())")
            
            // First reset navigation
            navVM.goToRoot()
            
            // Short delay to ensure the navigation stack is clear
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // Navigate to appropriate destination based on vendor type
                switch type {
                case .food:
                    navVM.navigate(to: .food)
                case .entertainment:
                    navVM.navigate(to: .entertainment)
                case .busway:
                    navVM.navigate(to: .busway)
                case .parkingLot:
                    navVM.navigate(to: .parking)
                case .lifestyle:
                    navVM.navigate(to: .lifestyle)
                case .worship:
                    navVM.navigate(to: .praying)
                case .other:
                    navVM.navigate(to: .other)
                }
                
                // Clear state after successful navigation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.vendorTypeToNavigateTo = nil
                }
            }
        }
    }
}
