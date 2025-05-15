//
//  ClothingSection.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 14/05/25.
//
import SwiftUI

struct ClothingSection: View {
    let clothList: [Cloth]
    let getImage: (String) -> AnyView
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Clothing:")
                .font(.title2)
                .padding(.top)
                .frame(maxWidth: .infinity)
            
            ForEach(clothList, id: \.name) { cloth in
                HStack {
                    getImage(cloth.image)
                    
                    VStack(alignment: .leading) {
                        Text(cloth.name)
                            .font(.headline)
                        Text("$\(cloth.price, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.green)
                        Text(cloth.label == .girl ? "For Girls" : "For Boys")
                            .font(.subheadline)
                            .italic()
                    }
                }
                .padding(.vertical, 5)
            }
        }
    }
}
