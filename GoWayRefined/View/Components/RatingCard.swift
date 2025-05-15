import SwiftUI

struct RatingCard: View {
    @State private var rating: Int = 0
    @State private var showStars: Bool = true
    @State private var showCard: Bool = true
    
    let vendorName: String
    let buildingName: String
    let vendorImage: String
    let onRated: (Int) -> Void  // Now passes the rating value
    
    var body: some View {
        if showCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    // Vendor logo (image)
                    Image(vendorImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .padding(.leading, 10)
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(vendorName)
                            .font(.caption)
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                        
                        Text(buildingName)
                            .font(.caption2)
                            .foregroundColor(.gray)
                        
                        // Only show stars if `showStars` is true
                        if showStars {
                            HStack {
                                ForEach(1..<6) { star in
                                    Button(action: {
                                        rating = star
                                        hideStarsAndCard()
                                    }) {
                                        Image(systemName: star <= rating ? "star.fill" : "star")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(star <= rating ? .yellow : .gray)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.top, 5)
                        }
                    }
                    Spacer()
                }
            }
            .frame(width: 200, height: 55)
            .padding(.vertical, 10)
            .padding(.horizontal, 5)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 3)
            .padding(.horizontal, 10)
            .transition(.asymmetric(
                insertion: .opacity.combined(with: .scale),
                removal: .opacity.combined(with: .scale(scale: 0.8))
            ))
        }
    }
    
    private func hideStarsAndCard() {
        
        // Then proceed with animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showStars = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showCard = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    onRated(rating)
                }
            }
        }
    }
}
