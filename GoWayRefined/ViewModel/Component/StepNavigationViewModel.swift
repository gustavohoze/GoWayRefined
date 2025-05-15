//
//  StepNavigationViewModel.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 14/05/25.
//

import SwiftUI

class StepNavigationViewModel: ObservableObject {
    // Data properties
    private let steps: [Step]
    let vendor: Vendor
    
    // Published properties for UI state
    @Published var currentStepIndex = 0
    @Published var showInitialView = true
    
    // Initialize with required data
    init(steps: [Step], vendor: Vendor) {
        self.steps = steps
        self.vendor = vendor
    }
    
    // MARK: - Navigation Actions
    
    func startNavigation() {
        currentStepIndex = 1
        showInitialView = false
    }
    
    func goToPreviousStep() {
        if currentStepIndex == 1 {
            showInitialView = true
        } else if currentStepIndex > 1 {
            currentStepIndex -= 1
        }
    }
    
    func goToNextStep() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
        }
    }
    
    // MARK: - Helper Methods
    
    func isOnFinalStep() -> Bool {
        return currentStepIndex == steps.count - 1
    }
    
    func getCurrentStepImage() -> String {
        if currentStepIndex < steps.count {
            return steps[currentStepIndex].image
        } else {
            return "busway" // Fallback image
        }
    }
    
    func getStepText(_ index: Int) -> String {
        if index < steps.count {
            return steps[index].description
        } else {
            return "Step \(index + 1)"
        }
    }
    
    func getVisibleStepIndices() -> [Int] {
        // If there are 3 or fewer steps, show all of them
        if steps.count <= 3 {
            return Array(0..<steps.count)
        }
        
        // Otherwise, show a sliding window of 3 steps
        if currentStepIndex == 0 || currentStepIndex == 1 {
            return [0, 1, 2]
        } else if currentStepIndex == steps.count - 1 {
            return [steps.count - 3, steps.count - 2, steps.count - 1]
        } else {
            return [currentStepIndex - 1, currentStepIndex, currentStepIndex + 1]
        }
    }
    
    func getVendorName() -> String {
        return vendor.name
    }
    
    func getStepsCount() -> Int {
        return steps.count
    }
}
