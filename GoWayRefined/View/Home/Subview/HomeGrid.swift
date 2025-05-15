import SwiftUI

// HomeGrid View
struct HomeGrid: View {
    @StateObject var viewModel = HomeGridViewModel() // Initialize the ViewModel
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ] // 4 columns for a 4x2 grid layout
    
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 15) {
                ForEach(viewModel.items, id: \.self) { item in
                    NavigationLink(destination: viewModel.destinationView(for: item)) {
                        VStack {
                            Image(item) // Replace with your actual image names
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40) // Adjusted size for the icons
                                .padding()
                                .background(Color.white) // Optional background for each icon
                                .cornerRadius(10) // Rounded corners for the icon background
                                .shadow(radius: 4) // Shadow for depth effect
                                .padding(.bottom, 5)
                            
                            Text(item.capitalized) // Capitalize the item text
                                .font(.caption2)
                                .foregroundColor(.black) // Ensure text color is readable
                                .multilineTextAlignment(.center) // Center align text
                                .lineLimit(1) // Limit the text to one line
                                .frame(width:80)
                        }
                        .frame(maxWidth: .infinity) // Ensure each item takes full width
                    }
                }
            }
            .padding(10) // Padding around the grid
        }.padding(.vertical, 15)

    }
}

struct HomeGrid_Previews: PreviewProvider {
    static var previews: some View {
        HomeGrid()
    }
}
