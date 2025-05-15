import SwiftUI

struct StepsSection: View {
    let vendor: Vendor
    let stepList: [Step]
    @EnvironmentObject var navigationVM: NavigationViewModel
    
    var body: some View {
        HStack {
            Text("Steps:")
                .font(.title2)
                .foregroundStyle(.black)
                .padding(.top)
            
            Spacer()
            
            Button {
                // Navigate to step navigation view using our central NavigationViewModel
                navigationVM.navigate(to: .stepNavigation(vendor: vendor, steps: stepList))
            } label: {
                Text("View Directions")
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity)
    }
}

