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
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .active {
                // App has become active
                print("App became active")
                
                // Check for pending navigation requests in the navigation manager
                navigationManager.checkPendingNavigationRequests()
            } else if newPhase == .background {
                // App went to background
                print("App went to background")
            }
        }
    }
}
