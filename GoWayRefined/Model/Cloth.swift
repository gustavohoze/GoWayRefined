import Foundation

enum ClothLabel {
    case girl, boy
}

struct Cloth {
    var name: String
    var image: String
    var price: Double
    var label: ClothLabel
}
