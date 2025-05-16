//
//  SplashScreenView.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 16/05/25.
//


import SwiftUI

struct SplashScreenView: View {
    @ObservedObject var navigationViewModel: NavigationViewModel
    @State private var isActive = false
    private let splashDuration: Double = 1.0 // Splash screen duration in seconds
    
    var body: some View {
        ZStack {
            // Background color
            Color.white.ignoresSafeArea()
            
            // Content
            VStack(spacing: 20) {
                Spacer()
                
                // App logo/icon
                Image(.gowayIcon) // Replace with your app logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                
                // App name
                Text("GoWay")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                
                Spacer()
                
                // Activity indicator

            }
            .padding()
        }
        .onAppear {
            // Automatically dismiss after the specified duration
            DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {
                withAnimation {
                    self.isActive = true
                    navigationViewModel.goToRoot()
                }
            }
        }
    }
    
    // Function to navigate to home screen

}

// Extension for UserDefaults to handle splash screen state
extension UserDefaults {
    private enum Keys {
        static let hasSeenSplashScreen = "hasSeenSplashScreen"
    }
    
    var hasSeenSplashScreen: Bool {
        get {
            return bool(forKey: Keys.hasSeenSplashScreen)
        }
        set {
            set(newValue, forKey: Keys.hasSeenSplashScreen)
        }
    }
}

// Preview
struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView(navigationViewModel: NavigationViewModel())
    }
}
