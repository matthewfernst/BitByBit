//
//  BBSpotifyViewController.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/14/24.
//

import UIKit

/// View controller containing Spotify and it's endpoints
class BBSpotifyViewController: UIViewController {
    
    private let viewModel: BBSpotifyViewViewModel
    
    private let spotifyView = BBSpotifyView()
    
    // MARK: - Init

    init(viewModel: BBSpotifyViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        navigationController?.navigationBar.prefersLargeTitles = true
        spotifyView.configure(with: viewModel)
        view.addSubview(spotifyView)
        addConstraints()
    }
    
    
    // MARK: - Private

    private func addConstraints() {
        NSLayoutConstraint.activate([
            spotifyView.topAnchor.constraint(equalTo: view.topAnchor),
            spotifyView.leftAnchor.constraint(equalTo: view.leftAnchor),
            spotifyView.rightAnchor.constraint(equalTo: view.rightAnchor),
            spotifyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
