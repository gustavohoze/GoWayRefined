//
//  RootView.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 18/05/25.
//


import SwiftUI

struct RootView: View {
    @StateObject private var navigationViewModel = NavigationViewModel()
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreenView(navigationViewModel: navigationViewModel) {
                    // This closure will be called when splash screen is done
                    withAnimation {
                        showSplash = false
                    }
                }
            } else {
                HomeView(navigationViewModel: navigationViewModel)
            }
        }
    }
}