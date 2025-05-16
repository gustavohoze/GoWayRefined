import SwiftUI

class NavigationViewModel: ObservableObject {
    @Published var navPath = NavigationPath()
    
    // Add this to ensure HomeView is always the root
    private var isInitialNavigation = true
    
    // Navigate to a destination
    func navigate(to destination: AppDestination) {
        // If this is coming from a shortcut or external source,
        // make sure we're starting fresh
        if isInitialNavigation {
            // Start with a clean path
            navPath = NavigationPath()
            isInitialNavigation = false
        }
        
        // Now navigate to the destination
        navPath.append(destination)
    }
    
    // Specialized navigation for shortcuts and Siri
    func navigateFromExternalSource(to destination: AppDestination) {
        print("NavigationViewModel: Navigating from external source to \(destination)")
        
        // Always reset path when coming from an external source
        navPath = NavigationPath()
        
        // Small delay to ensure UI is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.navPath.append(destination)
        }
    }
    
    // Add this to NavigationViewModel
    func replaceCurrentView(with destination: AppDestination) {
        if !navPath.isEmpty {
            navPath.removeLast() // Remove current view
            navPath.append(destination) // Add new destination
        } else {
            navigate(to: destination) // Just navigate if stack is empty
        }
    }
    
    // Go back one level
    func goBack() {
        if !navPath.isEmpty {
            navPath.removeLast()
        }
    }
    
    // Go back multiple levels
    func goBack(levels: Int) {
        guard levels > 0 else { return }
        
        let levelsToRemove = min(levels, navPath.count)
        for _ in 0..<levelsToRemove {
            navPath.removeLast()
        }
    }
    
    // Go back to root (HomeView)
    func goToRoot() {
        navPath = NavigationPath()
        isInitialNavigation = true
    }
    
    // Go back until a specific destination is at the top
    func popToDestination<T: Hashable>(_ destination: T) {
        while !navPath.isEmpty {
            // We need to peek at the last item, but NavigationPath doesn't support this directly
            // So we'll remove items until we find the destination
            let count = navPath.count
            navPath.removeLast()
            
            if navPath.count < count - 1 {
                // We've found our destination, stop removing items
                break
            }
        }
    }
    
    // Call this when app becomes active
    func resetForAppActivation() {
        goToRoot()
    }
}

extension NavigationViewModel: @unchecked Sendable {
    static var shared: NavigationViewModel?
}
