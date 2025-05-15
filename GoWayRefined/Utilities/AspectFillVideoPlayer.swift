//
//  AspectFillVideoPlayer.swift
//  GoWayRefined
//
//  Created by Gustavo Hoze Ercolesea on 14/05/25.
//

import SwiftUI
import AVKit

struct AspectFillVideoPlayer: UIViewControllerRepresentable {
    var player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.videoGravity = .resizeAspectFill // Fill the available space
        controller.showsPlaybackControls = false // Hide controls if desired
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update player if needed
        uiViewController.player = player
    }
}
