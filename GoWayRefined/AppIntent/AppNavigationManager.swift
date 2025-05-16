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
    // In checkPendingVendorTypeNavigation method
    private func checkPendingVendorTypeNavigation() {
        if let typeString = UserDefaults.standard.string(forKey: "pendingVendorTypeNavigation"),
           let type = VendorType(rawValue: typeString) {
            
            // Clear from UserDefaults immediately
            UserDefaults.standard.removeObject(forKey: "pendingVendorTypeNavigation")
            
            print("DEBUG: Found vendor type in UserDefaults: \(typeString), raw value: \(type.rawValue)")
            
            // Temporarily disable automatic navigation
            // navigateToVendorType(type)
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
            isProcessingNavigation = false
            
        case .navigatingToBuilding(let building):
            print("NavigationManager: Executing navigation to building: \(building.name)")
            
            // Use a direct reset and navigate approach
            DispatchQueue.main.async {
                // Create a completely fresh navigation path
                navVM.navPath = NavigationPath()
                
                // Navigate after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    print("NavigationManager: Adding building destination after reset")
                    
                    // Explicitly create the destination to avoid any type issues
                    let destination: AppDestination = .buildingDetail(building: building)
                    navVM.navigate(to: destination)
                    
                    // Clear state after successful navigation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.buildingToNavigateTo = nil
                        self.currentState = .idle
                        self.isProcessingNavigation = false
                        print("NavigationManager: Navigation to building complete")
                    }
                }
            }
            
        case .navigatingToVendor(let vendor):
            print("NavigationManager: Executing navigation to vendor: \(vendor.name)")
            
            // Use a direct reset and navigate approach
            DispatchQueue.main.async {
                // Create a completely fresh navigation path
                navVM.navPath = NavigationPath()
                
                // Navigate after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    print("NavigationManager: Adding vendor destination after reset")
                    
                    // Explicitly create the destination to avoid any type issues
                    let destination: AppDestination = .vendorDetail(vendor: vendor, isRecommended: nil)
                    navVM.navigate(to: destination)
                    
                    // Clear state after successful navigation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.vendorToNavigateTo = nil
                        self.currentState = .idle
                        self.isProcessingNavigation = false
                        print("NavigationManager: Navigation to vendor complete")
                    }
                }
            }
            
        case .navigatingToVendorType(let type):
            print("NavigationManager: Executing navigation to vendor type: \(type.description())")
            
            // Use a direct reset and navigate approach
            DispatchQueue.main.async {
                // Create a completely fresh navigation path
                navVM.navPath = NavigationPath()
                
                // Navigate after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    print("NavigationManager: Adding vendor type destination after reset")
                    
                    // Create the appropriate destination
                    let destination: AppDestination
                    switch type {
                    case .food:
                        destination = .food
                    case .entertainment:
                        destination = .entertainment
                    case .busway:
                        destination = .busway
                    case .parkingLot:
                        destination = .parking
                    case .lifestyle:
                        destination = .lifestyle
                    case .worship:
                        destination = .praying
                    case .other:
                        destination = .other
                    }
                    
                    navVM.navigate(to: destination)
                    
                    // Clear state after successful navigation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.vendorTypeToNavigateTo = nil
                        self.currentState = .idle
                        self.isProcessingNavigation = false
                        print("NavigationManager: Navigation to vendor type complete")
                    }
                }
            }
        }
    }
}
