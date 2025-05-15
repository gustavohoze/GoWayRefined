import Foundation

enum VendorType {
    case food, entertainment, busway, parkingLot, lifestyle, worship, other
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
