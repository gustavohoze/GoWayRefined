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
    
    // State to control splash screen visibility with transition
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                HomeView(navigationViewModel: navigationVM)
                    .environmentObject(navigationVM)
                    .opacity(showSplash ? 0 : 1) // Fade in home view
                
                if showSplash {
                    SplashScreenView(navigationViewModel: navigationVM) {
                        // This closure will be called when splash screen completes
                        withAnimation(.easeIn(duration: 0.5)) {
                            showSplash = false
                        }
                    }
                    .transition(.opacity) // Fade out splash screen
                }
            }
            .onAppear {
                // Configure Siri support
                siriManager.configureSiriIntents()
                
                // Set the shared navigation view model in the navigation manager
                navigationManager.setSharedNavigationViewModel(navigationVM)
                
                print("App initialized with Siri support and navigation manager")
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                print("App became active")
                
                // Re-enable navigation check, but with our improved filtering in place
                navigationManager.checkPendingVendorTypeNavigation()
            } else {
                navigationManager.clearNavigationState()
            }
        }
    }
}
