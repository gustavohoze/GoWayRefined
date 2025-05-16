//import Foundation
//import AppIntents
//
//@AssistantIntent(schema: .system.search)
//struct OpenBuildingIntent: ShowInAppSearchResultsIntent {
//    static var title: LocalizedStringResource = "Open Building"
//    
//    // Define search scopes
//    static let searchScopes: [StringSearchScope] = [.general]
//    
//    // Search criteria parameter
//    @Parameter(title: "Search Criteria")
//    var criteria: StringSearchCriteria
//    
//    @Parameter(title: "Building", description: "The building to open")
//    var target: Building
//    
//    init() {
//        self.target = BuildingDataModel.shared.getAllBuildings().first!
//    }
//    
//    // Add an initializer for the criteria
//    
//    func perform() async throws -> some IntentResult {
//        // You can use the criteria to filter buildings
//        let buildings = BuildingDataModel.shared.getAllBuildings()
//        let filteredBuildings = buildings.filter { building in
//            // Implement your search logic here
//            // For example: return building.name.contains(criteria.text)
//            return true // This will show all buildings, modify as needed
//        }
//        
//        // If we have a specific target, navigate to it
//        if let b = filteredBuildings.first(where: {$0.id == target.id}) {
//            AppNavigationManager.shared.navigateToBuilding(b)
//        } else if let first = filteredBuildings.first {
//            // Or navigate to the first result
//            AppNavigationManager.shared.navigateToBuilding(first)
//        }
//        
//        return .result()
//    }
//}
