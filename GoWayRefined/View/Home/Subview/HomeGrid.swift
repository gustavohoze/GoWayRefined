import SwiftUI

// HomeGrid View
struct HomeGrid: View {
    @StateObject var viewModel = HomeGridViewModel() // Initialize the ViewModel
    var navigationVM: NavigationViewModel
    
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
               
                    Button(action: {
                        navigateToGridDestination(item)
                    }) {
                        VStack {
                            Image(item)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                                .padding(.bottom, 5)
                            
                            Text(item.capitalized)
                                .font(.caption2)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                                .lineLimit(1)
                                .frame(width: 80)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(10) // Padding around the grid
        }.padding(.vertical, 15)

    }
    func navigateToGridDestination(_ item: String) {
        let destination: AppDestination
        
        switch item {
        case "busway":
            destination = .busway
        case "entertainment":
            destination = .entertainment
        case "food":
            destination = .food
        case "office":
            destination = .office
        case "parking":
            destination = .parking
        case "lifestyle":
            destination = .lifestyle
        case "praying":
            destination = .praying
        case "other":
            destination = .other
        default:
            return
        }
        
        navigationVM.navigate(to: destination)
    }
    
}

struct HomeGrid_Previews: PreviewProvider {
    static var previews: some View {
        HomeGrid(navigationVM: NavigationViewModel())
    }
}
