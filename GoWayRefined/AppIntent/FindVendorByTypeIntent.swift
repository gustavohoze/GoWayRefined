import Foundation
import AppIntents

struct FindVendorByTypeIntent: AppIntent {
    static var title: LocalizedStringResource = "Find Vendor by Type"
    static var description: IntentDescription = IntentDescription(
        "Find vendors of a specific type",
        categoryName: "Navigation",
        searchKeywords: ["vendor type", "category", "find", "browse"]
    )
    
    static var openAppWhenRun: Bool = true
    
    @Parameter(title: "Vendor Type")
    var vendorType: VendorType
    
    static var parameterSummary: some ParameterSummary {
        Summary("Show \(\.$vendorType) vendors")
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Use the navigation manager to navigate to the vendor type
        AppNavigationManager.shared.navigateToVendorType(vendorType)
        
        return .result(dialog: "Opening \(vendorType.description()) vendors...")
    }
}
