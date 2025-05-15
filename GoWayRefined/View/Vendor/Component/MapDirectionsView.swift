// MARK: - MapDirectionsViewModel
import SwiftUI
import MapKit

// MARK: - MapDirectionsView
struct MapDirectionsView: View {
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var viewModel: MapDirectionsViewModel
    
    init(destinationName: String, destinationCoordinate: CLLocationCoordinate2D) {
        self._viewModel = StateObject(wrappedValue: MapDirectionsViewModel(
            destinationName: destinationName,
            destinationCoordinate: destinationCoordinate
        ))
    }
    
    var body: some View {
        ZStack {
            // New MapKit implementation for iOS 17+
            Map(position: $viewModel.position) {
                // User location
                if let userLocation = locationManager.userLocation?.coordinate {
                    Marker("My Location", coordinate: userLocation)
                        .tint(.blue)
                }
                
                // Destination marker
                Marker(viewModel.getDestinationName(), coordinate: viewModel.getDestinationCoordinate())
                    .tint(.green)
                
                // Route polyline
                if let route = viewModel.route {
                    MapPolyline(route.polyline)
                        .stroke(.green, lineWidth: 5)
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
            }
            .ignoresSafeArea(edges: .bottom)
            
            // Loading indicator
            if viewModel.isCalculatingRoute {
                VStack {
                    ProgressView("Calculating route...")
                        .padding()
                        .foregroundStyle(.black.opacity(0.8))
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                }
            }
            
            // Error message
            if let error = viewModel.routeError {
                VStack {
                    Text(error)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(10)
                        .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            
            // Route information
            if let route = viewModel.route, !viewModel.isCalculatingRoute {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Distance: \(viewModel.formatDistance(meters: route.distance))")
                                .font(.headline)
                            Text("Time: \(viewModel.formatTime(seconds: route.expectedTravelTime))")
                                .font(.subheadline)
                        }
                        Spacer()
                    }
                    .padding()
                    .foregroundStyle(.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
        }
        .onAppear {
            viewModel.updateMap()
        }
//        .onChange(of: locationManager.userLocation) { _, _ in
//            viewModel.updateMap()
//        }
    }
}
