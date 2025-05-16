import SwiftUI

struct RecommendationCard: View {
    let vendorName: String
    let buildingName: String
    let vendorImage: String
    let items: [String]?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // Vendor logo (image) - matching RatingCard style
                Image(vendorImage)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .scaledToFit()
                    .padding(.leading, 10)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(vendorName)
                        .font(.caption)
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                    
                    Text(buildingName)
                        .font(.caption2)
                    
                        .foregroundColor(.gray)
                    
                    // Show items if available
                    if let items = items, !items.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(items, id: \.self) { item in
                                    Text(item)
                                        .foregroundStyle(.black)
                                        .frame(maxHeight: 20)
                                        .padding(5)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(5)
                                        .font(.caption2)
                                }
                            }
                            .padding(.top, 5)
                        }.frame(maxWidth: 100)
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    }
                }
                
                Spacer()
                
                // Chevron for navigation
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.trailing, 10)
            }
        }
        .frame(width: 200, height: 55)
        .padding(.vertical, 10)
        .padding(.horizontal, 5)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 3)
        .padding(.horizontal, 10)
    }
}

#Preview {
    RecommendationCard(vendorName: "GOP1", buildingName: "GOP2", vendorImage: "busway", items: ["GOP1", "GOP2"])
}
