import SwiftUI

struct SplashScreenView: View {
    @ObservedObject var navigationViewModel: NavigationViewModel
    @State private var isActive = false
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var textOpacity: Double = 0
    private let splashDuration: Double = 1.5 // Slightly longer for animations
    var onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Background color
            Color.white.ignoresSafeArea()
            
            // Content
            VStack(spacing: 20) {
                Spacer()
                
                // App logo/icon with animations
                Image(.gowayIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                
                // App name with fade in
                Text("GoWay")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.black)
                    .opacity(textOpacity)
                
                Spacer()
                
                // Subtle loading indicator that fades in

            }
            .padding()
        }
        .onAppear {
            // Animate logo appearance
            withAnimation(.easeOut(duration: 0.6)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            // Slightly delayed text fade-in
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                textOpacity = 1.0
            }
            
            // Prepare exit animation
            DispatchQueue.main.asyncAfter(deadline: .now() + splashDuration) {
                // First fade out
                withAnimation(.easeIn(duration: 0.4)) {
                    logoOpacity = 0.0
                    textOpacity = 0.0
                }
                
                // Then transition to home view
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isActive = true
                    navigationViewModel.goToRoot()
                    onComplete()
                }
            }
        }
    }
}
