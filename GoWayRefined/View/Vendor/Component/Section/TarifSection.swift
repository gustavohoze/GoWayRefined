//
//  TarifSection.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 14/05/25.
//
import SwiftUI


struct TarifSection: View {
    let tarifList: [Tarif]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Tarif:")
                .font(.title2)
                .padding(.top)
                .frame(maxWidth: .infinity)
            
            ForEach(tarifList, id: \.vehicleType) { tarif in
                VStack(alignment: .leading) {
                    Text(tarif.vehicleType)
                        .font(.headline)
                    Text("First Hour: $\(tarif.firstHourRate, specifier: "%.2f")")
                        .font(.subheadline)
                    Text("Hourly: $\(tarif.hourlyRate, specifier: "%.2f")")
                        .font(.subheadline)
                }
                .padding(.vertical, 5)
            }
        }
    }
}
