//
//  StepsSection.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 14/05/25.
//
import SwiftUI

struct StepsSection: View {
    let vendor: Vendor
    let stepList: [Step]
    
    var body: some View {
        HStack {
            Text("Steps:")
                .font(.title2)
                .foregroundStyle(.black)
                .padding(.top)
            
            Spacer()
            
            NavigationLink(
                destination: StepNavigationView(steps: stepList, vendor: vendor),
                label: {
                    Text("View Directions")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            )
            .padding(.top)
        }
        .frame(maxWidth: .infinity)
    }
}
