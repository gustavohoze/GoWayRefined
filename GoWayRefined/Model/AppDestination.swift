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
