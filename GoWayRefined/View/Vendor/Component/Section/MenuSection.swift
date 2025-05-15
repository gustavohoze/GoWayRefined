//
//  MenuSection.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 14/05/25.
//
import SwiftUI

struct MenuSection: View {
    let foodList: [Food]
    let getImage: (String) -> AnyView
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Menu:")
                .font(.title2)
                .padding(.top)
                .frame(maxWidth: .infinity)
            
            ForEach(foodList, id: \.name) { food in
                HStack {
                    getImage(food.image)
                    
                    VStack(alignment: .leading) {
                        Text(food.name)
                            .font(.headline)
                        Text(food.description)
                            .font(.subheadline)
                            .lineLimit(2)
                            .truncationMode(.tail)
                        Text("$\(food.price, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
                .padding(.vertical, 5)
            }
        }
    }
}
