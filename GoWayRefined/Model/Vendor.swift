import Foundation
import AppIntents

// Make VendorType compatible with AppIntents
enum VendorType: String, Hashable, CaseIterable, AppEnum {
    case food, entertainment, busway, parkingLot, lifestyle, worship, other
    
    // Required by AppEnum
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Vendor Type")
    }
    
    // Required by CaseDisplayRepresentable
    static var caseDisplayRepresentations: [VendorType : DisplayRepresentation] {
        [
            .food: DisplayRepresentation(title: "Food", image: .init(systemName: "fork.knife")),
            .entertainment: DisplayRepresentation(title: "Entertainment", image: .init(systemName: "film")),
            .busway: DisplayRepresentation(title: "Busway", image: .init(systemName: "bus")),
            .parkingLot: DisplayRepresentation(title: "Parking Lot", image: .init(systemName: "car")),
            .lifestyle: DisplayRepresentation(title: "Lifestyle", image: .init(systemName: "bag")),
            .worship: DisplayRepresentation(title: "Worship", image: .init(systemName: "hands.sparkles")),
            .other: DisplayRepresentation(title: "Other", image: .init(systemName: "ellipsis.circle"))
        ]
    }
    
    // Your existing description method
    func description() -> String {
        switch self {
        case .food: return "Food"
        case .entertainment: return "Entertainment"
        case .busway: return "Busway"
        case .parkingLot: return "Parking Lot"
        case .lifestyle: return "Lifestyle"
        case .worship: return "Worship"
        case .other: return "Other"
        }
    }
}

struct Vendor : Equatable, Identifiable, Hashable{
    var id: UUID = UUID()
    var name: String
    var image: String
    var type: VendorType
    var rating: Double = (Double(Int.random(in: 1...25)) / 5.0)
    var foodList: [Food]?
    var movieList: [Movie]?
    var routeList: [Route]?
    var tarifList: [Tarif]?
    var clothList: [Cloth]?
    var scheduleList: [Schedule]?
    var stepList: [Step]?
    static func == (lhs: Vendor, rhs: Vendor) -> Bool {
        return lhs.name == rhs.name && lhs.type == rhs.type
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
    }
}

extension Vendor: AppEntity {
    public static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Vendor")
    }
    
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)",
            subtitle: LocalizedStringResource(stringLiteral: type.description()),
            image: .init(named: image)
        )
    }
    
    public static var defaultQuery = VendorQuery()
}

struct VendorQuery: EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [Vendor] {
        return identifiers.compactMap { id in
            return BuildingDataModel.shared.getAllBuildings().flatMap { $0.vendors }.first { $0.id == id }
        }
    }
    
    func suggestedEntities() async throws -> [Vendor] {
        // Return popular vendors (first 5 from all buildings)
        return Array(BuildingDataModel.shared.getAllBuildings().flatMap { $0.vendors }.prefix(5))
    }
}
