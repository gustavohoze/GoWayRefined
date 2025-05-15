import SwiftUI
import AVFoundation

// MARK: - AR Onboarding Manager - Simple Version

// MARK: - Camera Permission Manager
class CameraPermissionManager: ObservableObject {
    @Published var cameraPermissionStatus: AVAuthorizationStatus = .notDetermined
    
    init() {
        checkCameraPermission()
    }
    
    func checkCameraPermission() {
        cameraPermissionStatus = AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.cameraPermissionStatus = granted ? .authorized : .denied
                completion(granted)
            }
        }
    }
}
class AROnboardingManager {
    static let shared = AROnboardingManager()
    
    private let userDefaults = UserDefaults.standard
    private let hasCompletedAROnboardingKey = "has_completed_ar_onboarding"
    
    private init() {}
    
    // Check if user has completed AR onboarding
    func hasCompletedOnboarding() -> Bool {
        return userDefaults.bool(forKey: hasCompletedAROnboardingKey)
    }
    
    // Mark AR onboarding as completed
    func markOnboardingCompleted() {
        userDefaults.set(true, forKey: hasCompletedAROnboardingKey)
        userDefaults.synchronize() // Force save immediately
    }
    
    // Reset onboarding status for testing
    func resetOnboardingStatus() {
        userDefaults.removeObject(forKey: hasCompletedAROnboardingKey)
        userDefaults.synchronize() // Force save immediately
    }
}

// MARK: - AR Button with Permission Handling and First-Time Check
struct ARButtonWithPermission: View {
    @StateObject private var permissionManager = CameraPermissionManager()
    @State private var showPermissionAlert = false
    @EnvironmentObject var navigationVM: NavigationViewModel
    
    var vendor: Vendor
    
    var body: some View {
        Button(action: {
            handleARButtonTap()
        }) {
            HStack {
                Text("Try in AR")
                Image(systemName: "cube.transparent")
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.green)
            .cornerRadius(20)
        }
        .alert(isPresented: $showPermissionAlert) {
            Alert(
                title: Text("Camera Access Required"),
                message: Text("AR features require camera access. Please allow camera access in Settings."),
                primaryButton: .default(Text("Open Settings"), action: openSettings),
                secondaryButton: .cancel()
            )
        }
    }
    
    private func handleARButtonTap() {
        switch permissionManager.cameraPermissionStatus {
        case .authorized:
            // Check if user has completed onboarding before
            if AROnboardingManager.shared.hasCompletedOnboarding() {
                // Already went through onboarding, go directly to AR
                navigationVM.navigate(to: .arNavigation(vendor: vendor))
            } else {
                // First time, show onboarding
                navigationVM.navigate(to: .arOnboarding(vendor: vendor))
            }
            
        case .notDetermined:
            // Request permission
            permissionManager.requestCameraPermission { granted in
                if granted {
                    // Check if user has completed onboarding before
                    if AROnboardingManager.shared.hasCompletedOnboarding() {
                        // Already went through onboarding, go directly to AR
                        navigationVM.navigate(to: .arNavigation(vendor: vendor))
                    } else {
                        // First time, show onboarding
                        navigationVM.navigate(to: .arOnboarding(vendor: vendor))
                    }
                }
            }
            
        case .denied, .restricted:
            // Show alert to direct user to settings
            showPermissionAlert = true
            
        @unknown default:
            // Handle future authorization status values
            showPermissionAlert = true
        }
    }
    
    private func openSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}

// MARK: - Extension to mark AR onboarding as completed
extension AROnboardingView {
    // Call this when the user completes the onboarding
    func markOnboardingAsCompleted() {
        AROnboardingManager.shared.markOnboardingCompleted()
    }
}

// MARK: - Get Started Button for Last Onboarding Page
struct GetStartedButton: View {
    var vendor: Vendor
    @EnvironmentObject var navigationVM: NavigationViewModel
    
    var body: some View {
        Button {
            // Navigate to AR Navigation
            navigationVM.navigate(to: .arNavigation(vendor: vendor))
        } label: {
            Text("Get Started")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)
                .frame(width: 200, height: 50)
                .background(Color.green)
                .cornerRadius(25)
        }
    }
}

// MARK: - Reset Onboarding Button (For Testing)
struct ResetAROnboardingButton: View {
    var body: some View {
        Button(action: {
            // Reset AR onboarding status for testing
            AROnboardingManager.shared.resetOnboardingStatus()
        }) {
            HStack {
                Image(systemName: "arrow.counterclockwise")
                Text("Reset AR Onboarding")
            }
            .foregroundColor(.red)
            .padding(8)
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
        }
    }
}
