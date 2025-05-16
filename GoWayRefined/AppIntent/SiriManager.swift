import Foundation
import AppIntents
import SwiftUI

// SiriManager to handle Siri integration
class SiriManager {
    static let shared = SiriManager()
    
    private init() {}
    
    func configureSiriIntents() {
        print("SiriManager: Configured Siri intents")
    }
}

// Using AppShortcutsProvider instead of AppIntentsProvider
//class AppSiriShortcutsProvider: AppShortcutsProvider {
//    static var appShortcuts: [AppShortcut] =
//        [
//            // Voice-optimized shortcuts with voice-friendly phrases
//            AppShortcut(
//                intent: SiriFindBuildingIntent(),
//                phrases: [
//                    "Where is [building] in \(.applicationName)",
//                    "Find [building] using \(.applicationName)",
//                    "I need directions to [building] in \(.applicationName)",
//                    "Take me to [building] in \(.applicationName)"
//                ],
//                shortTitle: "Voice Building Search",
//                systemImageName: "building.2.fill"
//            ),
//            AppShortcut(
//                intent: SiriFindVendorIntent(),
//                phrases: [
//                    "Where is [vendor] in \(.applicationName)",
//                    "Find [vendor] using \(.applicationName)",
//                    "I need directions to [vendor] in \(.applicationName)",
//                    "Take me to [vendor] in \(.applicationName)"
//                ],
//                shortTitle: "Voice Vendor Search",
//                systemImageName: "shop.fill"
//            ),
//            AppShortcut(
//                intent: SiriFindVendorByTypeIntent(),
//                phrases: [
//                    "Show me [vendor type] vendors in \(.applicationName)",
//                    "Where can I find [vendor type] in \(.applicationName)",
//                    "Browse [vendor type] in \(.applicationName)",
//                    "I'm looking for [vendor type] in \(.applicationName)"
//                ],
//                shortTitle: "Voice Category Browse",
//                systemImageName: "square.grid.2x2.fill"
//            )
//        ]
//    
//}

// Siri-optimized intent for finding buildings by voice
struct SiriFindBuildingIntent: AppIntent {
    static var title: LocalizedStringResource = "Find Building by Voice"
    
    // Add this to make the intent available to Siri directly
    static var openAppWhenRun: Bool = true
    
    static var description: IntentDescription = IntentDescription(
        "Find and navigate to a building using Siri",
        categoryName: "Navigation",
        searchKeywords: ["building", "find", "go to", "where is", "directions"]
    )
    
    @Parameter(title: "Building")
    var building: Building
    
    static var parameterSummary: some ParameterSummary {
        Summary("Find \(\.$building)")
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Navigate to the selected building
        AppNavigationManager.shared.navigateToBuilding(building)
        
        return .result(dialog: "I'll help you find \(building.name). Opening the app now.")
    }
}

// Siri-optimized intent for finding vendors by voice
struct SiriFindVendorIntent: AppIntent {
    static var title: LocalizedStringResource = "Find Vendor by Voice"
    
    static var openAppWhenRun: Bool = true
    
    static var description: IntentDescription = IntentDescription(
        "Find and navigate to a vendor using Siri",
        categoryName: "Navigation",
        searchKeywords: ["vendor", "store", "shop", "where is", "directions"]
    )
    
    @Parameter(title: "Vendor")
    var vendor: Vendor
    
    static var parameterSummary: some ParameterSummary {
        Summary("Find \(\.$vendor)")
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Navigate to the selected vendor
        AppNavigationManager.shared.navigateToVendor(vendor)
        
        return .result(dialog: "I'll help you find \(vendor.name). Opening the app now.")
    }
}

// Siri-optimized intent for finding vendors by type
struct SiriFindVendorByTypeIntent: AppIntent {
    static var title: LocalizedStringResource = "Browse Vendors by Type with Voice"
    
    static var openAppWhenRun: Bool = true
    
    static var description: IntentDescription = IntentDescription(
        "Browse vendors of a specific type using Siri",
        categoryName: "Navigation",
        searchKeywords: ["category", "type", "browse", "show me"]
    )
    
    @Parameter(title: "Vendor Type")
    var vendorType: VendorType
    
    static var parameterSummary: some ParameterSummary {
        Summary("Show \(\.$vendorType) vendors")
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Navigate to the specific vendor type
        AppNavigationManager.shared.navigateToVendorType(vendorType)
        
        return .result(dialog: "Here are the \(vendorType.description()) vendors. Opening the app now.")
    }
}
