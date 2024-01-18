//
//  BBSpotifyAuthorizeButtonViewModel.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/14/24.
//

import Foundation

protocol BBSpotifyAuthorizeButtonViewModelDelegate: AnyObject {
    func didInitiateSessionManager(withAccessToken accessToken: String)
}

final class BBSpotifyAuthorizeButtonViewModel: NSObject {
    
    public weak var delegate: BBSpotifyAuthorizeButtonViewModelDelegate?
    
    private lazy var sessionManager: SPTSessionManager? = {
        let configuration = SPTConfiguration(clientID: Constants.Spotify.clientID, redirectURL: Constants.Spotify.redirectURI)
        configuration.playURI = ""
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        
        return SPTSessionManager(configuration: configuration, delegate: self)
    }()
    
    // MARK: - Init

    override init() {
        super.init()
    }
    
    // MARK: - Public

    public func initiateSessionManager() {
        print("In session manager!")
        guard let sessionManager = sessionManager else { return }
        print("After guard")
        sessionManager.initiateSession(with: Constants.Spotify.scopes, options: .clientOnly)
        print("after initiateSession(with: option:)")
    }
    
}

extension BBSpotifyAuthorizeButtonViewModel: SPTSessionManagerDelegate {
    func sessionManager(manager: SPTSessionManager, shouldRequestAccessTokenWith code: String) -> Bool {
        print("shouldRequestAccessTokenWith")
        return true
    }
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        fatalError("Token wasn't able to be retrived :(")
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print("DID RENEW")
        delegate?.didInitiateSessionManager(withAccessToken: session.description)
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        DispatchQueue.main.async { [weak self] in
            print("didInitiate!")
            print("HERE!: \(session.accessToken)")
            self?.delegate?.didInitiateSessionManager(withAccessToken: session.accessToken)
        }
    }
}
