//import Foundation
//import AppIntents
//
//// Siri-optimized intent for finding buildings by voice
//struct SiriFindBuildingIntent: AppIntent {
//    static var title: LocalizedStringResource = "Find Building by Voice"
//    
//    // Set this to open the app automatically
//    static var openAppWhenRun: Bool = true
//    
//    static var description: IntentDescription = IntentDescription(
//        "Find and navigate to a building using Siri",
//        categoryName: "Voice Navigation",
//        searchKeywords: ["building", "find", "go to", "where is", "directions"]
//    )
//    
//    @Parameter(title: "Building",
//               requestValueDialog: "Which building are you looking for?")
//    var building: Building
//    
//    static var parameterSummary: some ParameterSummary {
//        Summary("Find \(\.$building)")
//    }
//    
//    @MainActor
//    func perform() async throws -> some IntentResult & ProvidesDialog {
//        // Store the building ID in UserDefaults for reliable navigation
//        UserDefaults.standard.set(building.id.uuidString, forKey: "pendingBuildingNavigation")
//        
//        // Also try to navigate directly if possible
//        DispatchQueue.main.async {
//            AppNavigationManager.shared.navigateToBuilding(building)
//        }
//        
//        // Return dialog for Siri to speak
//        return .result(dialog: "I'll help you find \(building.name). Opening the app now.")
//    }
//}
//
//// Siri-optimized intent for finding vendors by voice
//struct SiriFindVendorIntent: AppIntent {
//    static var title: LocalizedStringResource = "Find Vendor by Voice"
//    
//    static var openAppWhenRun: Bool = true
//    
//    static var description: IntentDescription = IntentDescription(
//        "Find and navigate to a vendor using Siri",
//        categoryName: "Voice Navigation",
//        searchKeywords: ["vendor", "store", "shop", "where is", "directions"]
//    )
//    
//    @Parameter(title: "Vendor",
//               requestValueDialog: "Which vendor are you looking for?")
//    var vendor: Vendor
//    
//    static var parameterSummary: some ParameterSummary {
//        Summary("Find \(\.$vendor)")
//    }
//    
//    @MainActor
//    func perform() async throws -> some IntentResult & ProvidesDialog {
//        // Store the vendor ID in UserDefaults for reliable navigation
//        UserDefaults.standard.set(vendor.id.uuidString, forKey: "pendingVendorNavigation")
//        
//        // Also try to navigate directly if possible
//        DispatchQueue.main.async {
//            AppNavigationManager.shared.navigateToVendor(vendor)
//        }
//        
//        return .result(dialog: "I'll help you find \(vendor.name). Opening the app now.")
//    }
//}
//
//// Siri-optimized intent for finding vendors by type
//struct SiriFindVendorByTypeIntent: AppIntent {
//    static var title: LocalizedStringResource = "Browse Vendors by Type with Voice"
//    
//    static var openAppWhenRun: Bool = true
//    
//    static var description: IntentDescription = IntentDescription(
//        "Browse vendors of a specific type using Siri",
//        categoryName: "Voice Navigation",
//        searchKeywords: ["category", "type", "browse", "show me"]
//    )
//    
//    @Parameter(title: "Vendor Type",
//               requestValueDialog: "What type of vendor are you looking for?")
//    var vendorType: VendorType
//    
//    static var parameterSummary: some ParameterSummary {
//        Summary("Show \(\.$vendorType) vendors")
//    }
//    
//    @MainActor
//    func perform() async throws -> some IntentResult & ProvidesDialog {
//        // Store the vendor type in UserDefaults for reliable navigation
//        UserDefaults.standard.set(vendorType.rawValue, forKey: "pendingVendorTypeNavigation")
//        
//        // Also try to navigate directly if possible
//        DispatchQueue.main.async {
//            AppNavigationManager.shared.navigateToVendorType(vendorType)
//        }
//        
//        return .result(dialog: "Here are the \(vendorType.description()) vendors. Opening the app now.")
//    }
//}
