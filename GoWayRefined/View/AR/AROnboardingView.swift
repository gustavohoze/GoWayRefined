import SwiftUI
import AVKit

// MARK: - Onboarding Content Model
struct OnboardingContent: Identifiable {
    let id = UUID()
    let title: String
    let highlightedText: String
    let description: String
    let videoName: String
}

// MARK: - Onboarding Data
let arOnboardingPages: [OnboardingContent] = [
    OnboardingContent(
        title: "Bring the Map to",
        highlightedText: "Life",
        description: "To guide you through, we'll use your camera to recognize your surroundings and show directions in AR.",
        videoName: "AROnboarding1"
    ),
    OnboardingContent(
        title: "Look Around",
        highlightedText: "Clearly",
        description: "Make sure you're in a well-lit area and avoid pointing too close, a few steps back gives better results indoors.",
        videoName: "AROnboarding2"
    ),
    OnboardingContent(
        title: "Scan the Marker",
        highlightedText: "Nearby",
        description: "Point your camera at the yellow dot or wall sign to start. It helps the app understand where you are inside the building.",
        videoName: "AROnboarding3"
    ),
    OnboardingContent(
        title: "Start Navigating with",
        highlightedText: "AR",
        description: "Once scanned, directions will appear on your screen — just follow the floating arrows and labels to reach your room or destination.",
        videoName: "AROnboarding4"
    )
]

struct AROnboardingView: View {
    @EnvironmentObject var navigationVM: NavigationViewModel
    @State private var currentPageIndex = 0
    var vendor: Vendor
    
    @State private var players: [AVPlayer] = arOnboardingPages.map { content in
        // Create a player for each page, using a placeholder URL if the video doesn't exist
        let videoURL = Bundle.main.url(forResource: content.videoName, withExtension: "mp4") ?? URL(string: "about:blank")!
        return AVPlayer(url: videoURL)
    }
    
    private var isLastPage: Bool {
        return currentPageIndex == arOnboardingPages.count - 1
    }
    
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with Back and Skip buttons
            HStack {
                Button(action: {
                    if currentPageIndex > 0 {
                        currentPageIndex -= 1
                    } else {
                        // Go back to previous screen
                        navigationVM.goBack()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.green)
                }
                
                Spacer()
                
                if !isLastPage {
                    Button {
                        // Replace current onboarding view with AR Navigation
                        navigationVM.replaceCurrentView(with: .arNavigation(vendor: vendor))
                    } label: {
                        Text("SKIP")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 10)
            
            Spacer()
            
            // Phone frame with video
            ZStack {
                // Phone frame
                Image(.iPhone12Pro)
                    .font(.system(size: 280))
                    .foregroundColor(.black)
                
                // Video player for current page
                AspectFillVideoPlayer(player: players[currentPageIndex])
                    .frame(width: 180, height: 400)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .frame(height: 500)
            
            Spacer()
            
            // Bottom section with text and button
            VStack(spacing: 16) {
                // Title with highlighted text in green
                let content = arOnboardingPages[currentPageIndex]
                
                HStack(spacing: 8) {
                    Text(content.title)
                        .foregroundStyle(.black)
                        .font(.system(size: 24, weight: .bold))
                    
                    Text(content.highlightedText)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.green)
                }
                
                // Subtitle
                Text(content.description)
                    .font(.system(size: 13))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: 300)
                
                // Indicator dots
                HStack(spacing: 8) {
                    ForEach(0..<arOnboardingPages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPageIndex ? Color.green : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 24)
                
                // Action button
                if isLastPage {
                    // Update GetStartedButton to use navigationVM or replace with a Button
                    Button {
                        // Navigate to AR Navigation directly
                        navigationVM.navigate(to: .arNavigation(vendor: vendor))
                    } label: {
                        Text("Get Started")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .cornerRadius(25)
                    }
                    .padding(.bottom, 40)
                } else {
                    Button(action: {
                        // Go to next page
                        currentPageIndex += 1
                    }) {
                        Text("Got It!")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .cornerRadius(25)
                    }
                    .padding(.bottom, 40)
                }
            }
            .padding(.horizontal, 20)
        }
        .navigationBarBackButtonHidden()
        .onChange(of: currentPageIndex) { oldValue, newValue in
            // Pause the old video and play the new one
            if oldValue != newValue {
                players[oldValue].pause()
                players[newValue].seek(to: .zero)
                players[newValue].play()
            }
        }
        .onAppear {
            // Start playing the first video and set up looping
            startVideoPlayback()
        }
        .onDisappear {
            // Pause all videos
            for player in players {
                player.pause()
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func startVideoPlayback() {
        // Play the current video
        let player = players[currentPageIndex]
        player.play()
        
        // Set up notification to loop the video
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
    }
}




// MARK: - Preview
struct AROnboardingPreview: PreviewProvider {
    static var previews: some View {
        AROnboardingView(vendor: Vendor(id: UUID(), name: "BATHROOM", image: "busway", type: .food))
    }
}
