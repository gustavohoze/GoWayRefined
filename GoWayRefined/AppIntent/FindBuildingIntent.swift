

// Update the intent to use this notification system
import Foundation
import AppIntents

struct FindBuildingIntent: AppIntent {
    static var title: LocalizedStringResource = "Find Building"
    static var description: IntentDescription = IntentDescription(
        "Navigate to a specific building",
        categoryName: "Navigation",
        searchKeywords: ["building", "find", "navigate", "location"]
    )
    
    static var openAppWhenRun: Bool = true
    
    @Parameter(title: "Building")
    var building: Building
    
    static var parameterSummary: some ParameterSummary {
        Summary("Find \(\.$building)")
    }
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Use the navigation manager to trigger navigation
        AppNavigationManager.shared.navigateToBuilding(building)
        
        return .result(dialog: "Opening \(building.name)...")
    }
}
