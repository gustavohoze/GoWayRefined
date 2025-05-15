//
//  FilterButton.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 12/05/25.
//
import SwiftUI

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Text(title)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .foregroundColor(isSelected ? Color.white : Color.green)
            .background(isSelected ? Color.green.opacity(1) : Color.clear)
            .cornerRadius(10)
            .font(.body)
            .onTapGesture(perform: action)
    }
}
