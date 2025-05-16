import SwiftUI
struct VendorCard: View {
    @StateObject var viewModel: VendorCardViewModel
    
    init(vendorName: String, vendorType: String, buildingName: String, vendorImage: String, rating: Double, items: [String]?) {
        _viewModel = StateObject(wrappedValue: VendorCardViewModel(vendorName: vendorName, vendorType: vendorType, buildingName: buildingName, vendorImage: vendorImage, items: items, rating: rating))
    }
    
    var body: some View {
        HStack {
            // Vendor logo (image)
            Image(viewModel.vendorImage)
                .resizable()
                .frame(maxWidth: 75, maxHeight: 75)
                .scaledToFit()
                .padding(.horizontal, 10)
            
            VStack(alignment: .leading, spacing: 3) {
                // Vendor name and type
                Text(viewModel.vendorName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                // Abbreviate the building name to "GOP 1", "GOP 2", etc.
                HStack(alignment: .center, spacing: 0){
                    Text(viewModel.abbreviatedBuildingName())
                        .font(.footnote)
                        .foregroundStyle(.gray)
                    Text(" | ").font(.footnote).foregroundStyle(.gray)
                    Text(String(viewModel.rating) + " ★").font(.footnote)
                        .foregroundStyle(.yellow)
                        
                }
                
                
                // Conditionally display the list of items if it's available
                if let items = viewModel.items, !items.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(items, id: \.self) { item in
                                Text(item)
                                    .frame(maxHeight: 20)
                                    .padding(5)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(5)
                                    .font(.caption)
                            }
                        }
                        .padding(.top, 5)
                    }
                    .scrollIndicators(ScrollIndicatorVisibility.hidden)
                }
                Spacer()
            }
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 10, maxHeight: 20)
                .padding(.horizontal, 15)
        }
        .frame(minWidth: 200, maxHeight: 100)
        .padding(.vertical, 10)
        .padding(.horizontal, 5)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.horizontal, 10)
    }
}


struct VendorCard_Preview: PreviewProvider {
    static var previews: some View {
        // Preview with items
        VendorCard(vendorName: "BreadLife", vendorType: "ROTI, KUE", buildingName: "Green Office Park 1", vendorImage: "busway",rating: 5.0, items: ["ROTI COKLAT", "ROTI KUKUS", "KUE COKLAT"])
            .previewLayout(.sizeThatFits)
            .padding()
        
        // Preview without items (optional list)
        VendorCard(vendorName: "BreadLife", vendorType: "ROTI, KUE", buildingName: "Green Office Park 2", vendorImage: "gop_9",rating: 5.0,  items: nil)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
