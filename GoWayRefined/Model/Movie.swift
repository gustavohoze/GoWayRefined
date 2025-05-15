import Foundation

enum MovieLabel {
    case _2D, _18Plus
}

struct Movie {
    var name: String
    var image: String
    var price: Double
    var label: MovieLabel
}
