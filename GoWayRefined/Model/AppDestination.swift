import Foundation

enum AppDestination: Hashable {
    // Main destinations
    case search
    
    // Grid destinations
    case busway
    case entertainment
    case food
    case office
    case parking
    case lifestyle
    case praying
    case other
    
    // Detail destinations
    case vendorDetail(vendor: Vendor, isRecommended: Bool?)
    
    // AR destinations
    case arNavigation(vendor: Vendor)
    case arOnboarding(vendor: Vendor)
    case stepNavigation(vendor: Vendor, steps: [Step])
    case buildingDetail(building: Building)
    
    // MARK: - Hashable Conformance
    func hash(into hasher: inout Hasher) {
        switch self {
        case .search:
            hasher.combine(0)
        case .busway:
            hasher.combine(1)
        case .entertainment:
            hasher.combine(2)
        case .food:
            hasher.combine(3)
        case .office:
            hasher.combine(4)
        case .parking:
            hasher.combine(5)
        case .lifestyle:
            hasher.combine(6)
        case .praying:
            hasher.combine(7)
        case .other:
            hasher.combine(8)
        case .vendorDetail(let vendor, let isRecommended):
            hasher.combine(9)
            hasher.combine(vendor.id)
            hasher.combine(isRecommended)
        case .arNavigation(let vendor):
            hasher.combine(10)
            hasher.combine(vendor.id)
        case .arOnboarding(let vendor):
            hasher.combine(11)
            hasher.combine(vendor.id)
        case .stepNavigation(let vendor, _):
            hasher.combine(12)
            hasher.combine(vendor.id)
            // Not hashing steps array as it could be complex
        case .buildingDetail(let building):
            hasher.combine(13) // Use a unique identifier
            hasher.combine(building.id)
        }
    }
    
    // MARK: - Equatable Conformance
    static func == (lhs: AppDestination, rhs: AppDestination) -> Bool {
        switch (lhs, rhs) {
        case (.search, .search),
            (.busway, .busway),
            (.entertainment, .entertainment),
            (.food, .food),
            (.office, .office),
            (.parking, .parking),
            (.lifestyle, .lifestyle),
            (.praying, .praying),
            (.other, .other):
            return true
            
        case (.vendorDetail(let lhsVendor, let lhsIsRecommended),
            .vendorDetail(let rhsVendor, let rhsIsRecommended)):
            return lhsVendor.id == rhsVendor.id && lhsIsRecommended == rhsIsRecommended
            
        case (.arNavigation(let lhsVendor), .arNavigation(let rhsVendor)):
            return lhsVendor.id == rhsVendor.id
            
        case (.arOnboarding(let lhsVendor), .arOnboarding(let rhsVendor)):
            return lhsVendor.id == rhsVendor.id
            
        case (.stepNavigation(let lhsVendor, _), .stepNavigation(let rhsVendor, _)):
            // Only comparing vendor IDs, not step arrays
            return lhsVendor.id == rhsVendor.id
        case (.buildingDetail(let lhsBuilding), .buildingDetail(let rhsBuilding)):
            return lhsBuilding.id == rhsBuilding.id
        default:
            return false
        }
    }
}

extension AppDestination: Codable {

    enum CodingKeys: String, CodingKey {
        case type, vendorId, buildingId, isRecommended
    }
    
    enum DestinationType: String, Codable {
        case search, busway, entertainment, food, office, parking, lifestyle, praying, other
        case vendorDetail, arNavigation, arOnboarding, stepNavigation, buildingDetail
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .search:
            try container.encode(DestinationType.search, forKey: .type)
        case .busway:
            try container.encode(DestinationType.busway, forKey: .type)
        case .entertainment:
            try container.encode(DestinationType.entertainment, forKey: .type)
        case .food:
            try container.encode(DestinationType.food, forKey: .type)
        case .office:
            try container.encode(DestinationType.office, forKey: .type)
        case .parking:
            try container.encode(DestinationType.parking, forKey: .type)
        case .lifestyle:
            try container.encode(DestinationType.lifestyle, forKey: .type)
        case .praying:
            try container.encode(DestinationType.praying, forKey: .type)
        case .other:
            try container.encode(DestinationType.other, forKey: .type)
        case .vendorDetail(let vendor, let isRecommended):
            try container.encode(DestinationType.vendorDetail, forKey: .type)
            try container.encode(vendor.id, forKey: .vendorId)
            try container.encode(isRecommended, forKey: .isRecommended)
        case .arNavigation(let vendor):
            try container.encode(DestinationType.arNavigation, forKey: .type)
            try container.encode(vendor.id, forKey: .vendorId)
        case .arOnboarding(let vendor):
            try container.encode(DestinationType.arOnboarding, forKey: .type)
            try container.encode(vendor.id, forKey: .vendorId)
        case .stepNavigation(let vendor, _):
            try container.encode(DestinationType.stepNavigation, forKey: .type)
            try container.encode(vendor.id, forKey: .vendorId)
        case .buildingDetail(let building):
            try container.encode(DestinationType.buildingDetail, forKey: .type)
            try container.encode(building.id, forKey: .buildingId)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(DestinationType.self, forKey: .type)
        
        switch type {
        case .search:
            self = .search
        case .busway:
            self = .busway
        case .entertainment:
            self = .entertainment
        case .food:
            self = .food
        case .office:
            self = .office
        case .parking:
            self = .parking
        case .lifestyle:
            self = .lifestyle
        case .praying:
            self = .praying
        case .other:
            self = .other
        case .vendorDetail:
            let vendorId = try container.decode(UUID.self, forKey: .vendorId)
            let isRecommended = try container.decodeIfPresent(Bool.self, forKey: .isRecommended)
            
            // Lookup vendor from your data source
            guard let vendor = AppDestination.findVendor(byId: vendorId) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Could not find vendor with ID \(vendorId)"
                ))
            }
            
            self = .vendorDetail(vendor: vendor, isRecommended: isRecommended)
        case .arNavigation:
            let vendorId = try container.decode(UUID.self, forKey: .vendorId)
            guard let vendor = AppDestination.findVendor(byId: vendorId) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Could not find vendor with ID \(vendorId)"
                ))
            }
            self = .arNavigation(vendor: vendor)
        case .arOnboarding:
            let vendorId = try container.decode(UUID.self, forKey: .vendorId)
            guard let vendor = AppDestination.findVendor(byId: vendorId) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Could not find vendor with ID \(vendorId)"
                ))
            }
            self = .arOnboarding(vendor: vendor)
        case .stepNavigation:
            let vendorId = try container.decode(UUID.self, forKey: .vendorId)
            guard let vendor = AppDestination.findVendor(byId: vendorId) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Could not find vendor with ID \(vendorId)"
                ))
            }
            // Steps would need to be loaded from your data store
            self = .stepNavigation(vendor: vendor, steps: vendor.stepList ?? [])
        case .buildingDetail:
            let buildingId = try container.decode(UUID.self, forKey: .buildingId)
            guard let building = AppDestination.findBuilding(byId: buildingId) else {
                throw DecodingError.dataCorrupted(DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Could not find building with ID \(buildingId)"
                ))
            }
            self = .buildingDetail(building: building)
        }
    }
    
    // Helper functions to find entities by ID
    private static func findVendor(byId id: UUID) -> Vendor? {
        // In a real app, this would query your data store
        return getAllVendors().first { $0.id == id }
    }
    
    private static func findBuilding(byId id: UUID) -> Building? {
        // In a real app, this would query your data store
        return BuildingDataModel.shared.getAllBuildings().first { $0.id == id }
    }
    
    private static func getAllVendors() -> [Vendor] {
        // Collect all vendors from all buildings
        return BuildingDataModel.shared.getAllBuildings().flatMap { $0.vendors }
    }
}
