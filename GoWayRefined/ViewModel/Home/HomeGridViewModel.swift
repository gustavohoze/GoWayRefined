import SwiftUI

// ViewModel for HomeGrid
class HomeGridViewModel: ObservableObject {
    @Published var items = [
        "busway", "entertainment", "food", "office",
        "parking", "lifestyle", "praying", "other"
    ]
    
    // Function to return the appropriate destination view for each item
    func destinationView(for item: String) -> AnyView {
        switch item {
        case "busway":
            return AnyView(BuswayView())
        case "entertainment":
            return AnyView(EntertainmentView())
        case "food":
            return AnyView(FoodView())
        case "office":
            return AnyView(OfficeView())
        case "parking":
            return AnyView(ParkingView())
        case "lifestyle":
            return AnyView(LifestyleView())
        case "praying":
            return AnyView(PrayingView())
        case "other":
            return AnyView(OtherView())
        default:
            return AnyView(Text("Unknown"))
        }
    }
}
