//
//  SearchViewModel.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 14/05/25.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var buildingResults: [Building] = []
    @Published var vendorResults: [(vendor: Vendor, buildingName: String)] = []
    
    // Sample data - replace with your actual data source
    private let allBuildings: [Building] = BuildingDataModel.shared.getAllBuildings()
    
    var totalResultsCount: Int {
        return buildingResults.count + vendorResults.count
    }
    
    // Updated search function in SearchViewModel
    // In SearchViewModel
    // In SearchViewModel
    func search(query: String) {
        guard !query.isEmpty else {
            buildingResults = []
            vendorResults = []
            return
        }
        
        let lowercasedQuery = query.lowercased()
        
        // Filter buildings
        buildingResults = allBuildings.filter { building in
            building.name.lowercased().contains(lowercasedQuery)
        }
        
        // Reset and recreate the vendor results
        vendorResults = []
        
        // Search through all buildings and their vendors
        for building in allBuildings {
            for vendor in building.vendors {
                // Debug each vendor we're checking
                print("Checking vendor: \(vendor.name), Type: \(vendor.type)")
                
                let vendorName = vendor.name.lowercased()
                let vendorTypeString = getVendorTypeString(vendor.type).lowercased()
                
                let matchesName = vendorName.contains(lowercasedQuery)
                let matchesType = vendorTypeString.contains(lowercasedQuery)
                
                // Print exactly what matched
                if matchesName {
                    print("  ✓ Matched name: \(vendorName) contains \(lowercasedQuery)")
                }
                if matchesType {
                    print("  ✓ Matched type: \(vendorTypeString) contains \(lowercasedQuery)")
                }
                
                if matchesName || matchesType {
                    // Add this vendor to our results
                    vendorResults.append((vendor: vendor, buildingName: building.name))
                    print("  → Added to results")
                }
            }
        }
    }
    
    // Function to get building name for a vendor
    func getBuildingName(for vendor: Vendor) -> String {
        // Find the building name in our vendor results
        if let vendorResult = vendorResults.first(where: { $0.vendor.name == vendor.name }) {
            return vendorResult.buildingName
        }
        return "Unknown Building"
    }
    
    // Helper function to convert VendorType to display string
    // In SearchView
    private func getVendorTypeString(_ type: VendorType) -> String {
        print("Converting vendor type: \(type)")  // Debug print
        switch type {
        case .food: return "Food"
        case .entertainment: return "Entertainment"
        case .busway: return "Busway"
        case .parkingLot: return "Parking Lot"
        case .lifestyle: return "Lifestyle"
        case .worship: return "Worship"
        case .other: return "Other"
        }
    }
    
    // In SearchView
    func getVendorItems(_ vendor: Vendor) -> [String]? {
        print("Getting items for vendor: \(vendor.name), type: \(vendor.type)")  // Debug print
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
}
