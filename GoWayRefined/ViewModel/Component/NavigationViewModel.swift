import SwiftUI

class NavigationViewModel: ObservableObject {
    @Published var navPath = NavigationPath()
    
    // Navigate to a destination
    func navigate(to destination: AppDestination) {
        navPath.append(destination)
    }
    // Add this to NavigationViewModel
    func replaceCurrentView(with destination: AppDestination) {
        if !navPath.isEmpty {
            navPath.removeLast(2) // Remove current view
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
    
    // Go back to root
    func goToRoot() {
        navPath = NavigationPath()
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
}
