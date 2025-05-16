import Foundation
import AppIntents

struct FindVendorIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Find Vendor"
    static var description: IntentDescription = IntentDescription(
        "Navigate to a specific vendor",
        categoryName: "Navigation",
        searchKeywords: ["vendor", "store", "find", "navigate", "restaurant", "shop"]
    )
    
    static var openAppWhenRun: Bool = true
    
    @Parameter(title: "Vendor")
    var vendor: Vendor
    
    static var parameterSummary: some ParameterSummary {
        Summary("Find \(\.$vendor)")
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Navigate to the selected vendor
        AppNavigationManager.shared.navigateToVendor(vendor)
        return .result(dialog: "Opening \(vendor.name)...")
    }
}
