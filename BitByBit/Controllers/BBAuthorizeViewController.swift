//
//  class BBAuthorizeViewController.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/14/24.
//

import UIKit

/// First view controller to authorize Spotify or Apple Music API
final class BBAuthorizeViewController: UIViewController {
    
    private let authorizationView = BBAuthorizationView()
    
    let spotifyViewModel = BBSpotifyViewViewModel()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorizationView.registerAppleMusicHandler { [weak self] accessToken in
            // Move to AppleMusic VC
            DispatchQueue.main.async {
                self?.moveToTabBar(withMusicServiceVC: BBAppleMusicViewController())
            }
        }
        
        view.addSubview(authorizationView)
        NSLayoutConstraint.activate([
            authorizationView.topAnchor.constraint(equalTo: view.topAnchor),
            authorizationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authorizationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            authorizationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Public

    public func moveToSpotifyVC() {
        // Move to Spotify VC
        moveToTabBar(withMusicServiceVC: BBSpotifyViewController(viewModel: spotifyViewModel))
    }
    
    // MARK: - Private

    private func moveToTabBar(withMusicServiceVC musicServiceVC: UIViewController) {
        let tabBar = BBTabBarController(musicServiceVC: musicServiceVC)
        tabBar.modalTransitionStyle = .flipHorizontal
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }
}
