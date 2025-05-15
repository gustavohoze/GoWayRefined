import SwiftUI

struct SearchHeader: View {
    @Environment(\.presentationMode) var presentationMode
    @FocusState var isTextFieldFocused: Bool
    @Binding var searchText: String
    @EnvironmentObject var navigationVM: NavigationViewModel // Add NavigationViewModel
    
    var building: Building?
    var vendor: Vendor?
    var isRecomended: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Image(.searchBackground)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                
                HStack(alignment: .center, spacing: 20) {
                   
                    backButton
                        .padding(.leading, 20)
                    
                    // Modified TextField with explicit placeholder styling
                    ZStack(alignment: .leading) {
                        if searchText.isEmpty {
                            Text("Search...")
                                .foregroundColor(.gray)
                                .padding(.leading, 10)
                        }
                        
                        TextField("", text: $searchText)
                            .focused($isTextFieldFocused)
                            .padding(10)
                            .foregroundColor(.black)
                            .accentColor(.blue)
                    }
                    .background(.white)
                    .cornerRadius(7.5)
                    .padding(.trailing, 30)
                }
                .padding(.top, 50)
            }
        }
        .background(.white)
        .ignoresSafeArea()
        .onAppear {
            // Clear the search text whenever the view appears
            searchText = ""
        }
    }
    
    @ViewBuilder
    private var backButton: some View {
        if building != nil {
            // Go back instead of adding a new destination
            Button {
                // Go back one level in the navigation stack
                navigationVM.goBack()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.7))
            }
        } else if vendor != nil {
            if isRecomended {
                Button {
                    // Return to home by clearing navigation path
                    navigationVM.goToRoot()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.white.opacity(0.5))
                }
            } else {
                Button {
                    // Go back one level
                    navigationVM.goBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
        } else {
            Button {
                // Return to home by clearing navigation path
                navigationVM.goToRoot()
            } label: {
                Image(systemName: "xmark")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }
    // Helper function to determine the appropriate navigation destination
    private func navigateToAppropriateView(for vendor: Vendor) {
        switch vendor.type {
        case .food:
            navigationVM.navigate(to: .food)
        case .entertainment:
            navigationVM.navigate(to: .entertainment)
        case .busway:
            navigationVM.navigate(to: .busway)
        case .parkingLot:
            navigationVM.navigate(to: .parking)
        case .lifestyle:
            navigationVM.navigate(to: .lifestyle)
        case .worship:
            navigationVM.navigate(to: .praying)
        case .other:
            navigationVM.navigate(to: .other)
        }
    }
}

struct SearchHeader_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            // Create a mock NavigationViewModel for preview
            let navVM = NavigationViewModel()
            
            // Light mode preview
            SearchHeader(searchText: .constant(""))
                .environmentObject(navVM)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            // Dark mode preview
            SearchHeader(searchText: .constant(""))
                .environmentObject(navVM)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
