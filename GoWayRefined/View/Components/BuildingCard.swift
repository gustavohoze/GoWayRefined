import SwiftUI
import CoreLocation

struct BuildingCard: View {
    // Reference the shared LocationManager instance
    @ObservedObject private var locationManager = LocationManager.shared
    
    var buildingName: String
    var buildingImage: String
    var latitude: Double
    var longitude: Double
    var rating: Double
    var items: [Vendor]?
    
    // Function to calculate distance
    func calculateDistance() -> String {
        guard let userLocation = locationManager.userLocation else {
            return "Unknown distance"
        }
        
        let buildingLocation = CLLocation(latitude: latitude, longitude: longitude)
        let distance = userLocation.distance(from: buildingLocation) // distance in meters
        let distanceInKm = distance / 1000 // convert to kilometers
        
        return String(format: "%.2f km", distanceInKm)
    }
    
    var body: some View {
        HStack {
            // building logo (image)
            Image(buildingImage)
                .resizable()
                .frame(width: 75, height: 75)
                .scaledToFill()
                .padding(.horizontal, 10)
            
            VStack(alignment: .leading, spacing: 5) {
                // building name and type
                Text(buildingName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                // Show distance from user location
                HStack{
                    Text("Distance: \(calculateDistance())")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text(" | ").font(.footnote)
                        .foregroundColor(.gray)
                    Text(String(rating) + " ★").font(.footnote).foregroundStyle(.yellow)
                    Spacer()
                }
               
                
                // Conditionally display the list of items if available
                if let items = items, !items.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(items, id: \.self) { item in
                                Text(item.name)
                                    .multilineTextAlignment(.leading)
                                    .frame(height: 20)
                                    .padding(5)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(5)
                                    .font(.caption)
                            }
                        }
                        .padding(.top, 5)
                    }
                    .scrollIndicators(.hidden)
                }
                Spacer()
            }
            
            Spacer()
            
            // Chevron icon
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 20)
                .padding(.horizontal, 15)
        }
        .frame(height: 100)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal, 10)
    }
}
