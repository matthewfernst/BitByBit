//
//  BBAuthorizationButtonStackView.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/14/24.
//

import UIKit

protocol BBAuthorizationButtonStackViewDelegate: AnyObject {
    func bbAuthorizationButtonStackView(_ stackView: BBAuthorizationButtonStackView, didTapAuthorizeSpotify accessToken: String)
    func bbAuthorizationButtonStackView(_ stackView: BBAuthorizationButtonStackView, didTapAuthorizeAppleMusic accessToken: String)
}

/// Stack view of authorizations buttons
final class BBAuthorizationButtonStackView: UIStackView {
    
    public weak var delegate: BBAuthorizationButtonStackViewDelegate?
    
    private let authorizeSpotifyButton = BBAuthorizeButton(frame: .zero, withLogoImageName: "spotifyLogo", serviceName: "Spotify")
    private let spotifyAuthorizeButtonViewModel = BBSpotifyAuthorizeButtonViewModel()
    
    private let authorizeAppleMusicButton = BBAuthorizeButton(frame: .zero, withLogoImageName: "appleMusicLogo", serviceName: "Apple Music")
    private let appleMusicAuthorizeButtonViewModel = BBAppleMusicAuthorizeButtonViewModel()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpStackView()
        
        spotifyAuthorizeButtonViewModel.delegate = self
        authorizeSpotifyButton.addTarget(self, action: #selector(didTapAuthorizeSpotify), for: .touchUpInside)
        
        appleMusicAuthorizeButtonViewModel.delegate = self
        authorizeAppleMusicButton.addTarget(self, action: #selector(didTapAuthorizeAppleMusic), for: .touchUpInside)
        
        addArrangedSubview(authorizeSpotifyButton)
        addArrangedSubview(authorizeAppleMusicButton)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    
    @objc
    private func didTapAuthorizeSpotify() {
        spotifyAuthorizeButtonViewModel.initiateSessionManager()
    }
    
    @objc
    private func didTapAuthorizeAppleMusic() {
        appleMusicAuthorizeButtonViewModel.authorizeAppleMusic()
    }
    
    private func setUpStackView() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        alignment = .center
        distribution = .fillEqually
        spacing = 10
    }
}

extension BBAuthorizationButtonStackView: BBSpotifyAuthorizeButtonViewModelDelegate {
    func didInitiateSessionManager(withAccessToken accessToken: String) {
        delegate?.bbAuthorizationButtonStackView(self, didTapAuthorizeSpotify: accessToken)
    }
}

extension BBAuthorizationButtonStackView: BBAppleMusicAuthorizeButtonViewModelDelegate {
    func bbAppleMusicAuthorizeButtonViewModel(_ viewModel: BBAppleMusicAuthorizeButtonViewModel, didSuccessfullyAuthorize success: Bool) {
        delegate?.bbAuthorizationButtonStackView(self, didTapAuthorizeAppleMusic: "")
    }
}
