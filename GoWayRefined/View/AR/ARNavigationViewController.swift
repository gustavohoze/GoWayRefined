import UIKit
import ARKit
import SceneKit

class ARNavigationViewController: UIViewController {
    
    // MARK: - Properties
    var sceneView: ARSCNView!
    var statusLabel: UILabel!
    var headerView: UIView!
    var closeButton: UIButton!
    var titleLabel: UILabel!
    var infoButton: UIButton!
    var loadARButton: UIButton!
    var actionButtonsView: UIStackView!
    var saveButton: UIButton!
    var refreshButton: UIButton!
    
    // Destination name (customizable)
    var destinationTitle: String?
    
    
    var vendor: Vendor?
    
    // Dynamic worldMapURL based on vendor
    var worldMapURL: URL {
        do {
            let baseURL = try FileManager.default.url(for: .documentDirectory,
                                                      in: .userDomainMask,
                                                      appropriateFor: nil,
                                                      create: true)
            
            if let vendor = self.vendor {
                // Create a unique, sanitized filename for this vendor
                let sanitizedName = vendor.name.replacingOccurrences(of: " ", with: "_")
                    .replacingOccurrences(of: "/", with: "-")
                return baseURL.appendingPathComponent("AR_\(sanitizedName).arworldmap")
            } else {
                // Default name if no vendor
                return baseURL.appendingPathComponent("ARWorldMap.arworldmap")
            }
        } catch {
            fatalError("Error getting world map URL: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSceneView()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTrackingConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Configure the AR scene view
        sceneView = ARSCNView(frame: view.bounds)
        sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(sceneView)
        
        // Setup header view
//        setupHeaderView()
        
        // Setup action buttons
        setupActionButtons()
        
        // Setup load AR button
        setupLoadARButton()
        
        // Setup status label
        setupStatusLabel()
    }
    
//    private func setupHeaderView() {
//        // Create header view with green background
//        headerView = UIView()
//        headerView.backgroundColor = UIColor.white
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(headerView)
//        
//        // Close button
//        closeButton = UIButton(type: .system)
//        closeButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
//        closeButton.tintColor = .green
//        closeButton.setTitle("Close", for: .normal)
//        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
//        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
//        closeButton.translatesAutoresizingMaskIntoConstraints = false
//        headerView.addSubview(closeButton)
//        
//        // Title label
//        titleLabel = UILabel()
//        titleLabel.text = destinationTitle
//        titleLabel.textColor = .green
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
//        titleLabel.textAlignment = .center
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        headerView.addSubview(titleLabel)
//        
//        // Info button
//        infoButton = UIButton(type: .system)
//        infoButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
//        infoButton.tintColor = .green
//        infoButton.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
//        infoButton.translatesAutoresizingMaskIntoConstraints = false
//        headerView.addSubview(infoButton)
//        
//        // Add constraints
//        NSLayoutConstraint.activate([
//            headerView.topAnchor.constraint(equalTo: view.topAnchor),
//            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            headerView.heightAnchor.constraint(equalToConstant: 60),
//            
//            closeButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//            closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 10),
//            
//            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 10),
//            
//            infoButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
//            infoButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 10),
//            infoButton.widthAnchor.constraint(equalToConstant: 30),
//            infoButton.heightAnchor.constraint(equalToConstant: 30)
//        ])
//    }
    
    private func setupActionButtons() {
        // Create save button
        saveButton = createActionButton(iconName: "square.and.arrow.down", action: #selector(saveButtonTapped))
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Create refresh button
        refreshButton = createActionButton(iconName: "arrow.counterclockwise", action: #selector(refreshButtonTapped))
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        // We'll add the buttons directly to the bottom container later
    }
    
    private func createActionButton(iconName: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        button.layer.cornerRadius = 22.5
        button.tintColor = .systemGreen
        button.setImage(UIImage(systemName: iconName), for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        // Set fixed size for action buttons
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 45),
            button.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        return button
    }
    
    private func setupLoadARButton() {
        // Create a container view for the bottom buttons
        let bottomContainer = UIView()
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomContainer)
        
        // Create load AR button
        loadARButton = UIButton(type: .system)
        loadARButton.backgroundColor = UIColor.systemGreen
        loadARButton.setTitle("LOAD AR", for: .normal)
        loadARButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loadARButton.tintColor = .white
        loadARButton.layer.cornerRadius = 10
        loadARButton.addTarget(self, action: #selector(loadARButtonTapped), for: .touchUpInside)
        loadARButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Add all buttons to the container
        bottomContainer.addSubview(saveButton)
        bottomContainer.addSubview(loadARButton)
        bottomContainer.addSubview(refreshButton)
        
        // Set constraints for the container
        NSLayoutConstraint.activate([
            bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            bottomContainer.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Set constraints for the save button (left side)
        NSLayoutConstraint.activate([
            saveButton.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor),
            saveButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor)
        ])
        
        // Set constraints for the LOAD AR button (center)
        NSLayoutConstraint.activate([
            loadARButton.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor),
            loadARButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor),
            loadARButton.widthAnchor.constraint(equalToConstant: 200),
            loadARButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Set constraints for the refresh button (right side)
        NSLayoutConstraint.activate([
            refreshButton.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor),
            refreshButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor)
        ])
    }
    
    private func setupStatusLabel() {
        statusLabel = UILabel()
        statusLabel.textAlignment = .center
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        statusLabel.layer.cornerRadius = 8
        statusLabel.clipsToBounds = true
        statusLabel.numberOfLines = 0
        statusLabel.isHidden = true // Initially hidden
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.bottomAnchor.constraint(equalTo: loadARButton.topAnchor, constant: -20),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            statusLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }
    
    private func setupSceneView() {
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [.showFeaturePoints]
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Button Actions
    @objc private func closeButtonTapped() {
            dismiss(animated: true)
    }
    
    @objc private func infoButtonTapped() {
        // Create and present the AROnboardingView
        if #available(iOS 14.0, *) {
            // SwiftUI approach (preferred for iOS 14+)
            if let vendor = self.vendor {
                // Create the onboarding view with the vendor
                let onboardingView = AROnboardingView(vendor: vendor)
                
                // Create and present the hosting controller
                let hostingController = UIHostingController(rootView: onboardingView)
                hostingController.modalPresentationStyle = .fullScreen
                present(hostingController, animated: true)
            } else {
                // Handle case where vendor is nil
                let alert = UIAlertController(
                    title: "Error",
                    message: "Vendor information is missing",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        } else {
            // UIKit fallback approach for iOS 13 and earlier
            let alert = UIAlertController(
                title: "AR Navigation",
                message: "Move your device around to map the environment. Tap on a location to place a navigation marker. Use the save button to save the current map for future use.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    @objc private func saveButtonTapped() {
        showStatusMessage("Saving map...")
        saveWorldMap()
    }
    
    @objc private func refreshButtonTapped() {
        showStatusMessage("Refreshing...")
        resetTrackingConfiguration()
    }
    
    @objc private func loadARButtonTapped() {
        showStatusMessage("Loading saved map...")
        loadWorldMap()
    }
    
    // Show temporary status message
    private func showStatusMessage(_ message: String) {
        statusLabel.text = message
        statusLabel.isHidden = false
        
        // Hide after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.statusLabel.isHidden = true
        }
    }
    
    // MARK: - AR Interaction
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: sceneView)
        
        // Use raycast query for modern iOS versions
        if #available(iOS 13.0, *) {
            // Create a raycast query for feature points and estimated planes
            guard let query = sceneView.raycastQuery(
                from: location,
                allowing: .estimatedPlane,
                alignment: .any
            ) else {
                showStatusMessage("Couldn't create raycast query")
                return
            }
            
            // Perform the raycast with the query
            let results = sceneView.session.raycast(query)
            
            if let firstResult = results.first {
                // Create anchor at the hit position
                let anchor = ARAnchor(transform: firstResult.worldTransform)
                sceneView.session.add(anchor: anchor)
                showStatusMessage("Navigation marker placed")
            } else {
                showStatusMessage("Could not place marker - try another position")
            }
        } else {
            // Fallback for older iOS versions (deprecated but works on older iOS)
            guard let hitTestResult = sceneView.hitTest(
                location,
                types: [.featurePoint, .estimatedHorizontalPlane]
            ).first else {
                showStatusMessage("Could not place marker - try another position")
                return
            }
            
            // Create anchor at the hit test position
            let anchor = ARAnchor(transform: hitTestResult.worldTransform)
            sceneView.session.add(anchor: anchor)
            showStatusMessage("Navigation marker placed")
        }
    }
    
    // MARK: - AR Tracking Configuration
    func resetTrackingConfiguration(with worldMap: ARWorldMap? = nil) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        
        if let worldMap = worldMap {
            configuration.initialWorldMap = worldMap
            showStatusMessage("Previously saved map loaded")
        } else {
            showStatusMessage("Move around to map the environment")
        }
        
        sceneView.session.run(configuration, options: options)
    }
    
    // MARK: - World Map Saving/Loading
    func saveWorldMap() {
        sceneView.session.getCurrentWorldMap { [weak self] (worldMap, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showStatusMessage("Error getting world map: \(error.localizedDescription)")
                return
            }
            
            guard let worldMap = worldMap else {
                self.showStatusMessage("Unknown error in getting world map")
                return
            }
            
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
                try data.write(to: self.worldMapURL, options: [.atomic])
                self.showStatusMessage("World map saved successfully")
            } catch {
                self.showStatusMessage("Error saving world map: \(error.localizedDescription)")
            }
        }
    }
    
    func loadWorldMap() {
        do {
            let data = try Data(contentsOf: worldMapURL)
            guard let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) else {
                showStatusMessage("Could not unarchive world map from data")
                return
            }
            resetTrackingConfiguration(with: worldMap)
        } catch {
            showStatusMessage("Error loading world map: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 3D Objects
    func loadCapuchinoModel() -> SCNNode? {
        // Try to load the Capuchino model
        guard let url = Bundle.main.url(forResource: "Capuchino", withExtension: "scn", subdirectory: "Assets.scnassets/capuchino") else {
            showStatusMessage("Could not find Capuchino model in assets")
            return nil
        }
        
        // Try SCNReferenceNode first (preferred for external models)
        if let referenceNode = SCNReferenceNode(url: url) {
            referenceNode.load()
            
            // Apply scaling to the Capuchino model
            referenceNode.scale = SCNVector3(0.001, 0.001, 0.001)
            
            return referenceNode
        }
        
        // Fall back to SCNSceneSource if reference node fails
        if let sceneSource = SCNSceneSource(url: url, options: nil),
           let scene = sceneSource.scene(options: nil) {
            let modelNode = scene.rootNode.clone()
            
            // Apply scaling to the Capuchino model
            modelNode.scale = SCNVector3(0.001, 0.001, 0.001)
            
            return modelNode
        }
        
        showStatusMessage("Failed to load Capuchino model")
        return nil
    }
    
    func orientNodeToCamera(_ node: SCNNode) {
        guard let frame = sceneView.session.currentFrame else { return }
        
        // Get camera transform
        let cameraTransform = frame.camera.transform
        
        // Calculate the direction vector pointing from the camera
        let forwardDirection = SCNVector3(
            -cameraTransform.columns.2.x,
             -cameraTransform.columns.2.y,
             -cameraTransform.columns.2.z
        )
        
        // Make the node look at the forward direction
        node.look(at: forwardDirection)
    }
}

// MARK: - ARSCNViewDelegate
extension ARNavigationViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Skip plane anchors
        guard !(anchor is ARPlaneAnchor) else { return }
        
        // Load the Capuchino model
        guard let capuchinoNode = loadCapuchinoModel() else {
            showStatusMessage("Failed to create navigation marker")
            return
        }
        
        // Orient the Capuchino model toward the camera
        orientNodeToCamera(capuchinoNode)
        
        // Add the Capuchino to the anchor node
        DispatchQueue.main.async { [weak self] in
            self?.showStatusMessage("Navigation marker placed")
            node.addChildNode(capuchinoNode)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        showStatusMessage("AR Session failed: \(error.localizedDescription)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        showStatusMessage("AR Session interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        showStatusMessage("AR Session resumed")
        resetTrackingConfiguration()
    }
}

// MARK: - SwiftUI Integration Helper
#if canImport(SwiftUI)
import SwiftUI

struct ARNavigationViewControllerRepresentable: UIViewControllerRepresentable {
    var vendor: Vendor
    
    func makeUIViewController(context: Context) -> ARNavigationViewController {
        let viewController = ARNavigationViewController()
        viewController.destinationTitle = vendor.name
        viewController.vendor = vendor
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ARNavigationViewController, context: Context) {
        // Update the view controller if needed
    }
}

struct ARNavigationView: View {
    var vendor: Vendor
    @EnvironmentObject var navigationVM: NavigationViewModel
    
    var body: some View {
        ZStack {
            ARNavigationViewControllerRepresentable(vendor: vendor)
            
            VStack {
                HStack {
                    // Back button to step navigation view
                    Button {
                        // Navigate to StepNavigationView
                        navigationVM.replaceCurrentView(with: .stepNavigation(vendor: vendor, steps: vendor.stepList ?? []))
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Close")
                        }
                    }
                    .foregroundColor(.green)
                    
                    Spacer()
                    
                    Text(vendor.name.capitalized)
                        .fontWeight(.bold)
                        .padding(.trailing, 20)
                        .foregroundStyle(.green)
                    
                    Spacer()
                    
                    // Info button to AR onboarding
                    Button {
                        // Navigate to AR onboarding
                        navigationVM.navigate(to: .arOnboarding(vendor: vendor))
                    } label: {
                        Image(systemName: "info.circle")
                            .imageScale(.large)
                    }
                    .foregroundColor(.green)
                }
                .padding()
                .background(.white)
                .frame(height: 150)
                
                Spacer()
            }
        }
        .background(.white)
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
}
#endif

#Preview {
    ARNavigationView(vendor: Vendor(id: UUID(), name: "Test", image: "busway", type: .food))
}
