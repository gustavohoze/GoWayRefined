import SwiftUI

struct HomeRating: View {
    @State private var vendorCards: [(building: Building, vendor: Vendor)] = []
    @State private var ratedItems: Set<String> = []
    
    init() {
        // Initialize with limited number of vendor cards
        let buildings = BuildingDataModel.shared.getRandomBuildingsWithVendors(count: 5)
        var cards: [(Building, Vendor)] = []
        
        // Get one random vendor from each building
        for building in buildings {
            if let randomVendor = building.vendors.randomElement() {
                cards.append((building, randomVendor))
            }
        }
        
        _vendorCards = State(initialValue: cards)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Rate Your Experience")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .padding()
            
            // Show empty state when all cards have been rated
            if vendorCards.isEmpty || vendorCards.count == ratedItems.count {
                VStack {
                    Spacer()
                    Text("You haven't gone anywhere yet")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .padding()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(Array(vendorCards.enumerated()), id: \.offset) { index, card in
                            let itemId = "\(card.building.id)-\(card.vendor.id)"
                            
                            if !ratedItems.contains(itemId) {
                                RatingCard(
                                    vendorName: card.vendor.name,
                                    buildingName: card.building.name,
                                    vendorImage: card.vendor.image,
                                    onRated: { rating in
                                        ratedItems.insert(itemId)
                                        print("Rated \(card.vendor.name) in \(card.building.name) with \(rating) stars")
                                    }
                                )
                                .id(itemId)
                            }
                        }
                    }
                    .padding(5)
                }
            }
        }
        .onAppear {
            // Optionally refresh cards when view appears
            if vendorCards.isEmpty {
                refreshCards()
            }
        }
    }
    
    private func refreshCards() {
        let buildings = BuildingDataModel.shared.getRandomBuildingsWithVendors(count: 5)
        var cards: [(Building, Vendor)] = []
        
        for building in buildings {
            if let randomVendor = building.vendors.randomElement() {
                cards.append((building, randomVendor))
            }
        }
        
        vendorCards = cards
        ratedItems.removeAll() // Clear rated items when refreshing
    }
}
