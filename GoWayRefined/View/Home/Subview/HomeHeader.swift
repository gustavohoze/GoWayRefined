//
//  SwiftUIView.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 09/05/25.
//

import SwiftUI

struct HomeHeader: View {
    var navigationVM: NavigationViewModel
    var body: some View {
        ZStack {
            Image(.homeBackground) // Background image
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                Text("Good \(getGreeting())")
                    .font(.title)
                    .bold()
                Text("Ready to Explore GOP?")
                    .font(.title2)
                Button(action: {
                    navigationVM.navigate(to: .search)
                }) {
                    Image(.searchButton)
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 5)
                }
                
            }
            .padding(20)
            .padding(.top, 35)
            .foregroundColor(.white)
        }
      

    }
    
    private func getGreeting() -> String {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        if currentHour >= 5 && currentHour < 12 {
            return "Morning,"
        } else if currentHour >= 12 && currentHour < 18 {
            return "Afternoon,"
        } else {
            return "Evening,"
        }
    }
    

}
