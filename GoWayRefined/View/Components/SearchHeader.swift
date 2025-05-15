import SwiftUI

struct SearchHeader: View {
//    @Namespace private var namespace
    @Environment(\.presentationMode) var presentationMode
    @FocusState var isTextFieldFocused: Bool
    @Binding var searchText: String
    var building : Building?
    var vendor : Vendor?
    var isRecomended : Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                Image(.searchBackground)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                
                HStack(alignment: .center, spacing: 20) {
                    // Close button "X" to dismiss the search view
                    navigationButton
//                        .transition(.asymmetric(
//                        insertion: .move(edge: .trailing),
//                        removal: .move(edge: .leading)
//                    ))
//                    .matchedGeometryEffect(id: "transition", in: namespace)

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
        .navigationBarBackButtonHidden()
        .ignoresSafeArea()
        .onAppear {
            // Clear the search text whenever the view appears
            searchText = ""
        }
    }
    @ViewBuilder
    private var navigationButton: some View {
        if building != nil {
            // Navigate to BuildingDetail if building is provided
            NavigationLink(destination: OfficeView()) {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.7))
            }
        }else if let vendor = vendor {
            if isRecomended {
                NavigationLink(destination: {
                    HomeView().navigationBarBackButtonHidden()
                }) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.white.opacity(0.5))
                }
            }else{
                NavigationLink(destination: detailView(for: vendor)) {
                    Image(systemName: "chevron.left") // Changed to back arrow
                        .font(.title)
                        .foregroundColor(.white.opacity(0.7))
            }
           
            }
        } else {
           
                NavigationLink(destination: {
                    HomeView().navigationBarBackButtonHidden()
                }) {
                    Image(systemName: "xmark")
                        .font(.title)
                        .foregroundColor(.white.opacity(0.5))
                }
            
            
        }
    }
    func detailView(for vendor: Vendor) ->  AnyView {
        switch vendor.type {
        case .food:
            return AnyView(FoodView())
        case .entertainment:
            return AnyView(EntertainmentView())
        case .busway:
            return AnyView(BuswayView())
        case .parkingLot:
            return AnyView(ParkingView())
        case .lifestyle:
            return AnyView(LifestyleView())
        case .worship:
            return AnyView(PrayingView())
        case .other:
            return AnyView(OtherView())
        }
    }
}


struct SearchHeader_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            // Light mode preview
            SearchHeader(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            // Dark mode preview
            SearchHeader(searchText: .constant(""))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}
