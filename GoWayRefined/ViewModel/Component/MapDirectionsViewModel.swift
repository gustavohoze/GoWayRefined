//
//  MapDirectionsViewModel.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 14/05/25.
//

import MapKit
import SwiftUI

class MapDirectionsViewModel: ObservableObject {
    @Published var position: MapCameraPosition = .automatic
    @Published var route: MKRoute?
    @Published var isCalculatingRoute = false
    @Published var routeError: String?
    
    private let locationManager = LocationManager.shared
    private let destinationName: String
    private let destinationCoordinate: CLLocationCoordinate2D
    
    init(destinationName: String, destinationCoordinate: CLLocationCoordinate2D) {
        self.destinationName = destinationName
        self.destinationCoordinate = destinationCoordinate
    }
    
    // Format distance for display
    func formatDistance(meters: Double) -> String {
        if meters >= 1000 {
            return String(format: "%.2f km", meters / 1000)
        } else {
            return String(format: "%.0f m", meters)
        }
    }
    
    // Format time for display
    func formatTime(seconds: Double) -> String {
        let minutes = Int(seconds / 60)
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            return "\(hours) hr \(remainingMinutes) min"
        }
    }
    
    // Updates the map position and calculates route
    func updateMap() {
        guard let userLocation = locationManager.userLocation else { return }
        
        // Set the map position to show both the user and destination
        position = .rect(
            MKMapRect(
                origin: MKMapPoint(userLocation.coordinate),
                size: MKMapSize(width: 1000, height: 1000)
            ).union(
                MKMapRect(
                    origin: MKMapPoint(destinationCoordinate),
                    size: MKMapSize(width: 1000, height: 1000)
                )
            ).insetBy(dx: -1000, dy: -1000)
        )
        
        // Calculate route
        calculateRoute(from: userLocation.coordinate, to: destinationCoordinate)
    }
    
    // Calculate route from user to destination
    private func calculateRoute(from userCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D) {
        isCalculatingRoute = true
        routeError = nil
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userCoordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationCoordinate))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isCalculatingRoute = false
                
                if let error = error {
                    self.routeError = "Error calculating route: \(error.localizedDescription)"
                    return
                }
                
                guard let response = response, let route = response.routes.first else {
                    self.routeError = "No route found"
                    return
                }
                
                self.route = route
            }
        }
    }
    
    // Helper to access destination name
    func getDestinationName() -> String {
        return destinationName
    }
    
    // Helper to access destination coordinate
    func getDestinationCoordinate() -> CLLocationCoordinate2D {
        return destinationCoordinate
    }
}
