//
//  VideoBackgroundViewModel.swift
//  w1867464-CW-WeatherAPP
//
//  Created by Sithum Raveesha on 2024-12-15.
//

import SwiftUI
import AVKit

struct VideoBackgroundView: UIViewControllerRepresentable {
    var videoName: String
    var videoType: String
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        guard let path = Bundle.main.path(forResource: videoName, ofType: videoType) else {
            fatalError("Video not found")
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.frame = UIScreen.main.bounds
        player.isMuted = true
        player.play()
        player.actionAtItemEnd = .none
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        let videoView = UIView(frame: UIScreen.main.bounds)
        videoView.layer.addSublayer(playerLayer)
        viewController.view = videoView
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
