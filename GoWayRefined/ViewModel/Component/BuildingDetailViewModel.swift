import SwiftUI
import Combine
import CoreLocation

class BuildingDetailViewModel: ObservableObject {
    // Private backing property for searchText
    private var _searchText: String = ""
    
    // Published properties
    @Published var selectedVendorType: VendorType? = nil
    @Published var filteredVendors: [Vendor] = []
    private var locationManager = LocationManager.shared
    
    // Custom getter and setter for searchText
    var searchText: String {
        get { _searchText }
        set {
            _searchText = newValue
            filterVendors() // Immediately filter when text changes
        }
    }
    
    let vendorTypes: [VendorType] = [.food, .entertainment, .busway, .parkingLot, .lifestyle, .worship, .other]
    var building: Building
    
    init(building: Building) {
        self.building = building
        self.filteredVendors = building.vendors
    }
    
    // Method to filter vendors based on selected type and search text
    func filterVendors() {
        filteredVendors = building.vendors.filter { vendor in
            (selectedVendorType == nil || vendor.type == selectedVendorType) &&
            (searchText.isEmpty || vendor.name.lowercased().contains(searchText.lowercased()))
        }
    }
    
    // Helper function to get the correct items based on vendor type
    func getVendorItems(_ vendor: Vendor) -> [String]? {
        switch vendor.type {
        case .food:
            return vendor.foodList?.map { $0.name }
        case .entertainment:
            return vendor.movieList?.map { $0.name }
        case .busway:
            return vendor.routeList?.map { $0.name }
        case .parkingLot:
            return vendor.tarifList?.map { $0.vehicleType }
        case .lifestyle:
            return vendor.clothList?.map { $0.name }
        case .worship:
            return vendor.scheduleList?.map { $0.hour }
        case .other:
            return nil
        }
    }
    func distanceFromUser() -> String {
        guard let userLocation = locationManager.userLocation else {
            return "Distance unknown"
        }
        
        let buildingLocation = CLLocation(
            latitude: building.latitude,
            longitude: building.longitude
        )
        
        let distanceInMeters = userLocation.distance(from: buildingLocation)
        
        // Convert to kilometers if distance is large
        if distanceInMeters >= 1000 {
            let distanceInKm = distanceInMeters / 1000
            return String(format: "%.2f km away", distanceInKm)
        } else {
            return String(format: "%.0f m away", distanceInMeters)
        }
    }
    
    // Method to change the selected vendor type and refresh the filter
    func selectVendorType(_ type: VendorType?) {
        selectedVendorType = type
        filterVendors()
    }
}
