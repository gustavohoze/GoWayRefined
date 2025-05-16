import SwiftUI
import Foundation

@main
struct GoWayRefinedApp: App {
    // Initialize managers
    private let siriManager = SiriManager.shared
    private let navigationManager = AppNavigationManager.shared
    
    // Shared NavigationViewModel for the app
    @StateObject private var navigationVM = NavigationViewModel()
    
    // Monitor app lifecycle
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            HomeView(navigationViewModel: navigationVM)
                .environmentObject(navigationVM)
                .onAppear {
                    // Configure Siri support
                    siriManager.configureSiriIntents()
                    
                    // Set the shared navigation view model in the navigation manager
                    navigationManager.setSharedNavigationViewModel(navigationVM)
                    
                    print("App initialized with Siri support and navigation manager")
                }
        }
        // In your GoWayRefinedApp.swift
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                print("App became active")
                
                // DEBUG: Check UserDefaults for any pending navigation
                if let typeString = UserDefaults.standard.string(forKey: "pendingVendorTypeNavigation") {
                    print("DEBUG: Found pendingVendorTypeNavigation in UserDefaults: \(typeString)")
                    
                    // Clear it immediately to prevent automatic navigation
                    UserDefaults.standard.removeObject(forKey: "pendingVendorTypeNavigation")
                }
                
                // Check for pending navigation requests in the navigation manager
                // Comment this out temporarily for debugging
                // navigationManager.checkPendingNavigationRequests()
            }
        }
    }
}
