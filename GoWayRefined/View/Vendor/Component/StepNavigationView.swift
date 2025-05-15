// MARK: - StepNavigationViewModel
import SwiftUI

// MARK: - StepNavigationView
struct StepNavigationView: View {
    @StateObject private var viewModel: StepNavigationViewModel
    
    init(steps: [Step], vendor: Vendor) {
        self._viewModel = StateObject(wrappedValue:
            StepNavigationViewModel(steps: steps, vendor: vendor)
        )
    }
    
    var body: some View {
        if viewModel.showInitialView {
            // Initial view matching the provided image
            initialView()
        } else if viewModel.isOnFinalStep() {
            // Final destination/arrival view
            finalView()
        } else {
            // Step navigation view (now starts from the second step)
            navigationView(vendor: viewModel.vendor)
        }
    }
    
    // MARK: - View Components
    
    private func initialView() -> some View {
        VStack(spacing: 0) {
            // Close button
            HStack {
                closeButton(vendor: viewModel.vendor)
                Spacer()
            }
            
            Spacer()
            
            // Bus image placeholder
            Image(viewModel.vendor.image) // Using existing image as placeholder
                .resizable()
                .scaledToFit()
                .frame(height: 500)
                .padding(.bottom, 30)
            
            // Navigation start text
            Text("START NAVIGATING FROM HERE")
                .font(.headline)
                .foregroundStyle(.black)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            Spacer()
            
            // Start button
            Button(action: {
                viewModel.startNavigation()
            }) {
                Text("Start")
                    .foregroundColor(.white)
                    .fontWeight(.medium)
                    .frame(width: 200, height: 50)
                    .background(Color.green)
                    .cornerRadius(25)
            }
            .padding(.bottom, 50)
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
    
    private func finalView() -> some View {
        VStack(spacing: 0) {
            // Close button
            HStack {
                closeButton(vendor: viewModel.vendor)
                Spacer()
            }
            
            Spacer()
            
            // Arrival text
            Text("YOU HAVE ARRIVED!")
                .font(.title)
                .foregroundStyle(.black)
                .fontWeight(.bold)
                .padding(.vertical, 30)
            
            // Destination image placeholder
            Image(viewModel.getCurrentStepImage())
                .resizable()
                .scaledToFit()
                .frame(height: 280)
                .cornerRadius(20)
                .padding(.bottom, 40)
            
            // Destination title
            Text(viewModel.getVendorName())
                .font(.title)
                .foregroundStyle(.black)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            // Location subtitle
            Text("GOP 9")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.bottom, 60)
            
            Spacer()
            
            // Navigation buttons
            HStack(spacing: 120) {
                // Back button
                Button(action: {
                    viewModel.goToPreviousStep()
                }) {
                    navigationButton(systemName: "chevron.left")
                }
                
                // Disabled next button
                navigationButton(systemName: "chevron.right", opacity: 0.4)
            }
            .padding(.bottom, 30)
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
    
    private func navigationView(vendor: Vendor) -> some View {
        VStack(spacing: 0) {
            // Close button
            HStack {
                closeButton(vendor: viewModel.vendor)
                Spacer()
            }
            
            // Bus image with AR button overlay
            ZStack {
                // Using step-specific image
                Image(viewModel.getCurrentStepImage())
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                
                // AR button overlay
                VStack {
                    Spacer().frame(height: 220)
                    
                    ARButtonWithPermission(vendor: vendor)
                    .padding(.bottom, 20)
                }
            }
            
            // Destination title
            Text(viewModel.getVendorName())
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.top, 20)
                .padding(.bottom, 30)
            
            // Step indicators with connections
            stepsIndicatorView()
            
            Spacer()
            
            // Navigation buttons
            HStack(spacing: 120) {
                Button(action: {
                    viewModel.goToPreviousStep()
                }) {
                    navigationButton(systemName: "chevron.left")
                }
                
                Button(action: {
                    viewModel.goToNextStep()
                }) {
                    navigationButton(systemName: "chevron.right")
                }
            }
            .padding(.bottom, 30)
        }
        .background(Color.white)
        .navigationBarHidden(true)
    }
    
    // MARK: - Helper View Components
    
    private func closeButton(vendor : Vendor, isRecommended: Bool = false) -> some View {
        NavigationLink(destination: {
            VendorDetailView(vendor: vendor)
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Close")
            }
            .foregroundColor(.green)
        }
        .padding()
    }
    
    private func navigationButton(systemName: String, opacity: Double = 1.0) -> some View {
        Image(systemName: systemName)
            .font(.title)
            .foregroundColor(.white)
            .frame(width: 80, height: 80)
            .background(Circle().fill(Color.green))
            .opacity(opacity)
    }
    
    private func stepsIndicatorView() -> some View {
        ZStack {
            // Steps container with fixed width and centered
            ScrollView(.vertical, showsIndicators: false) {
                // Container with fixed width and centered
                HStack {
                    Spacer()
                    
                    ZStack(alignment: .leading) {
                        // Single vertical line through all circles
                        if viewModel.getVisibleStepIndices().count > 1 {
                            Rectangle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 2)
                                .frame(height: 100)
                                .offset(x: 10, y: 5) // Align with circles
                        }
                        
                        // Step indicators
                        VStack(alignment: .leading, spacing: 25) {
                            ForEach(viewModel.getVisibleStepIndices(), id: \.self) { index in
                                StepRow(
                                    text: viewModel.getStepText(index),
                                    isSelected: index == viewModel.currentStepIndex,
                                    stepNumber: index
                                )
                            }
                        }
                        .padding(.vertical, 20)
                    }
                    .frame(width: 300, height: 200) // Fixed width for the step container
                    
                    Spacer()
                }
            }
            .frame(height: 200)
            
            // Top gradient overlay
            VStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.white.opacity(0)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 80)
                
                Spacer()
            }
            .frame(height: 200)
            
            // Bottom gradient overlay
            VStack {
                Spacer()
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.white.opacity(0), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 80)
            }
            .frame(height: 200)
        }
    }
}


