//
//  Building.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 09/05/25.
//

import Foundation

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
