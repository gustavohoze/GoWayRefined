//
//  RoutesSection.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 14/05/25.
//
import SwiftUI


struct RoutesSection: View {
    let routeList: [Route]
    let getImage: (String) -> AnyView
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Routes:")
                .font(.title2)
                .padding(.top)
                .frame(maxWidth: .infinity)
            
            ForEach(routeList, id: \.name) { route in
                HStack {
                    getImage(route.image)
                    
                    VStack(alignment: .leading) {
                        Text(route.name)
                            .font(.headline)
                        Text("Day: \(route.dayName)")
                            .font(.subheadline)
                    }
                }
                .padding(.vertical, 5)
            }
        }
    }
}
