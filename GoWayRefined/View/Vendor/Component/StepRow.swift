//
//  StepRow.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 14/05/25.
//
import SwiftUI

struct StepRow: View {
    let text: String
    let isSelected: Bool
    let stepNumber: Int
    
    var body: some View {
        // Use HStack to wrap circle and text with proper alignment
        HStack(alignment: .center, spacing: 15) {
            // Circle indicator
            Circle()
                .fill(isSelected ? Color.green : Color.gray)
                .frame(width: 20, height: 20)
            
            // Step text with conditional truncation
            Text(text)
                .foregroundColor(isSelected ? .black : Color.gray)
                .fontWeight(isSelected ? .medium : .regular)
                .lineLimit(isSelected ? nil : 1) // Only truncate if not selected
                .truncationMode(.tail)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: isSelected) // Only expand vertically if selected
            Spacer()
        }
        .frame(width: 280) // Fixed width for each step row
    }
}
