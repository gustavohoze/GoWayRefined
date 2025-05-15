//
//  MoviesSection.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 14/05/25.
//
import SwiftUI

struct MoviesSection: View {
    let movieList: [Movie]
    let getImage: (String) -> AnyView
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Movies:")
                .font(.title2)
                .padding(.top)
                .frame(maxWidth: .infinity)
            
            ForEach(movieList, id: \.name) { movie in
                HStack {
                    getImage(movie.image)
                    
                    VStack(alignment: .leading) {
                        Text(movie.name)
                            .foregroundStyle(.black)
                            .font(.headline)
                        Text("Label: \(movie.label == ._2D ? "2D" : "18+")")
                            .foregroundStyle(.black)
                            .font(.subheadline)
                        Text("$\(movie.price, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
                .padding(.vertical, 5)
            }
        }
    }
}
