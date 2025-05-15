import SwiftUI
import CoreLocation

struct HomeView: View {
    // Add LocationManager to your HomeView
    @StateObject private var locationManager = LocationManager.shared
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    ScrollView {
                        HomeHeader()
                        HomeGrid()
                        HomeRecommendation()
                        HomeRating()
                        Spacer()
                    }
                    .ignoresSafeArea()
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            requestLocationPermission()
        }
    }
    
    // Function to explicitly request location permission
    private func requestLocationPermission() {
        // Check current status first
        let status = locationManager.authorizationStatus
        
        if status == .notDetermined {
            // This will trigger the permission popup
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
