//
//  VendorHeaderView.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 14/05/25.
//

import SwiftUI


struct VendorHeaderView: View {
    let vendor: Vendor
    
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            Image(vendor.image)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .frame(maxWidth: .infinity)
            
            Text("Vendor: \(vendor.name)")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .padding()
                .frame(maxWidth: .infinity)
        }
    }
}
