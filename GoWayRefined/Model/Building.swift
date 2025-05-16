//
//  Building.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 09/05/25.
//

import Foundation
import AppIntents

struct Building: Identifiable, Equatable{
    let id: UUID = UUID()
    let name: String
    let image: String
    let latitude: Double
    let longitude: Double
    let vendors: [Vendor]
    let rating: Double
    static func == (lhs: Building, rhs: Building) -> Bool {
        return lhs.name == rhs.name && lhs.latitude == rhs.latitude
    }
}

extension Building: AppEntity {
    public static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Building")
    }
    
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)",
            subtitle: "Rating: \(String(format: "%.1f", rating))",
            image: .init(named: image)
        )
    }
    
    public static var defaultQuery = BuildingQuery()
}

struct BuildingQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [Building] {
        return identifiers.compactMap { id in
            return BuildingDataModel.shared.getAllBuildings().first { $0.id == id }
        }
    }
    
    func suggestedEntities() async throws -> [Building] {
        // Return all buildings
        return BuildingDataModel.shared.getAllBuildings()
    }
}
