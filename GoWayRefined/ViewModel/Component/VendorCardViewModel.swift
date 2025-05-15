import SwiftUI

// ViewModel for VendorCard
class VendorCardViewModel: ObservableObject {
    @Published var vendorName: String
    @Published var vendorType: String
    @Published var vendorImage: String
    @Published var buildingName: String
    @Published var items: [String]?
    @Published var rating: Double
    
    init(vendorName: String, vendorType: String, buildingName: String, vendorImage: String, items: [String]?, rating: Double) {
        self.vendorName = vendorName
        self.vendorType = vendorType
        self.vendorImage = vendorImage
        self.buildingName = buildingName
        self.rating = rating
        self.items = items
    }
    
    // Helper function to abbreviate building names (e.g., Green Office Park 1 -> GOP 1)
    func abbreviatedBuildingName() -> String {
        if buildingName.lowercased().contains("green office park") {
            if let number = buildingName.split(separator: " ").last {
                return "GOP \(number)"
            }
        }
        return buildingName
    }
}
