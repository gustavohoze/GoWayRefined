import SwiftUI
import Combine

// ViewModel for Vendors
class VendorViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published private var vendors: [String: [Vendor]] = [:]
    @Published private(set) var currentVendorType: VendorType
    
    // Singleton instance
    static var shared = VendorViewModel()
    
    // Private initializer
    private init() {
        // Default to food type initially, but this doesn't matter much as it will be updated
        self.currentVendorType = .other
        self.vendors = BuildingDataModel.shared.getVendors(forType: .other)
    }
    
    // Methods for setting specific vendor types
    func switchToFoodVendors() {
        setVendorType(.food)
    }
    
    func switchToBuswayVendors() {
        setVendorType(.busway)
    }
    
    func switchToEntertainmentVendors() {
        setVendorType(.entertainment)
    }
    
    func switchToLifestyleVendors() {
        setVendorType(.lifestyle)
    }
    
    func switchToOtherVendors() {
        setVendorType(.other)
    }
    
    func switchToParkingVendors() {
        setVendorType(.parkingLot)
    }
    
    func switchToPrayingVendors() {
        setVendorType(.worship)
    }
    
    
    // Internal method to set vendor type and refresh data
    private func setVendorType(_ vendorType: VendorType) {
        if self.currentVendorType != vendorType {
            self.currentVendorType = vendorType
            refreshVendors()
        }
    }
    
    // Refresh vendors based on current type
    private func refreshVendors() {
        self.vendors = BuildingDataModel.shared.getVendors(forType: currentVendorType)
        // Ensure UI updates by sending an objectWillChange notification
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    // Filtered vendors based on the search text
    var filteredVendors: [Vendor] {
        let allVendors = vendors.values.flatMap { $0 }
        
        if searchText.isEmpty {
            return allVendors
        } else {
            return allVendors.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    // Helper function to find the building name for a vendor
    func getBuildingName(for vendor: Vendor) -> String {
        for (buildingName, vendorList) in vendors {
            if vendorList.contains(where: { $0.id == vendor.id }) {
                return buildingName
            }
        }
        return "Unknown Building"
    }
    
    // Check if data is available
    var hasVendors: Bool {
        return !filteredVendors.isEmpty
    }
}
