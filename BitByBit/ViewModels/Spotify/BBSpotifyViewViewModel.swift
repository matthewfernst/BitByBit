//
//  BBAuthorizeButtonViewModel.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/14/24.
//

import Foundation

protocol BBSpotifyViewViewModelDelegate: AnyObject {
    func bbSpotifyViewViewModel(_ viewModel: BBSpotifyViewViewModel, didChangeAlbumImage image: UIImage)
    
    func bbSpotifyViewViewModel(_ viewModel: BBSpotifyViewViewModel, didChangeTrack track: SPTAppRemoteTrack)
    
    func bbSpotifyViewViewModel(_ viewModel: BBSpotifyViewViewModel, didChangePlayState isPaused: Bool)
    
    func bbSpotifyViewViewModel(_ viewModel: BBSpotifyViewViewModel, didChangeShuffleState isShuffling: Bool)
    
    func bbSpotifyViewViewModel(_ viewModel: BBSpotifyViewViewModel, didChangeRepeatState repeatMode: SPTAppRemotePlaybackOptionsRepeatMode)
}


/// Spotify authorize view model. Handles logic for subscribing to Spotify
final class BBSpotifyViewViewModel: NSObject, BBMusicServiceViewModel {
    
    public weak var delegate: BBSpotifyViewViewModelDelegate?
    
    private var lastPlayerState: SPTAppRemotePlayerState?
    
    /// Public for ease of access
    let appRemote: SPTAppRemote
    
    public var updateSpotifyAlbumImageView: ((UIImage) -> Void)?
    
    var accessToken = UserDefaults.standard.string(forKey: Constants.Spotify.accessTokenKey) {
        didSet {
            let defaults = UserDefaults.standard
            defaults.set(accessToken, forKey: Constants.Spotify.accessTokenKey)
        }
    }
    
    var responseCode: String? {
        didSet {
            fetchAccessToken { (dictionary, error) in
                if let error = error {
                    print("Fetching token request error \(error)")
                    return
                }
                let accessToken = dictionary!["access_token"] as! String
                DispatchQueue.main.async { [weak self] in
                    self?.appRemote.connectionParameters.accessToken = accessToken
                    self?.appRemote.connect()
                }
            }
        }
    }
    
    // MARK: - Init
    
    override init() {
        let configuration = SPTConfiguration(clientID: Constants.Spotify.clientID, redirectURL: Constants.Spotify.redirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating
        // otherwise another app switch will be required
        configuration.playURI = ""
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        
        self.appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = self.accessToken
        
        super.init()
        appRemote.delegate = self
    }
    
    
    // MARK: - Public / BBMusicServiceViewModel
    
    @objc
    public func didTapShuffle(_ button: UIButton) {
        guard let lastPlayerState = lastPlayerState else { return }
        appRemote.playerAPI?.setShuffle(!lastPlayerState.playbackOptions.isShuffling)
    }
    
    @objc
    public func didTapBackwardTrack(_ button: UIButton) {
        appRemote.playerAPI?.skip(toPrevious: nil)
    }
    
    @objc 
    public func didTapPauseOrPlay(_ button: UIButton) {
        if let lastPlayerState = lastPlayerState, lastPlayerState.isPaused {
            appRemote.playerAPI?.resume(nil)
        } else {
            appRemote.playerAPI?.pause(nil)
        }
    }
    
    @objc
    public func didTapForwardTrack(_ button: UIButton) {
        appRemote.playerAPI?.skip(toNext: nil)
    }
    
    @objc
    public func didTapRepeat(_ button: UIButton) {
        guard let lastPlayerState = lastPlayerState else { return }
        switch lastPlayerState.playbackOptions.repeatMode {
        case .off:
            appRemote.playerAPI?.setRepeatMode(.context)
        case .context:
            appRemote.playerAPI?.setRepeatMode(.track)
        case .track:
            appRemote.playerAPI?.setRepeatMode(.off)
        @unknown default:
            appRemote.playerAPI?.setRepeatMode(.off)
        }
    }
    
    public func initialUpdateState() {
        guard let lastPlayerState = lastPlayerState else { return }
        update(playerState: lastPlayerState)
    }
    
    // MARK: - Private
    
    private func update(playerState: SPTAppRemotePlayerState) {
        if lastPlayerState?.track.uri != playerState.track.uri {
            fetchArtwork(for: playerState.track)
        }
        lastPlayerState = playerState

        delegate?.bbSpotifyViewViewModel(self, didChangeTrack: playerState.track)
        delegate?.bbSpotifyViewViewModel(self, didChangePlayState: playerState.isPaused)
        delegate?.bbSpotifyViewViewModel(self, didChangeShuffleState: playerState.playbackOptions.isShuffling)
        delegate?.bbSpotifyViewViewModel(self, didChangeRepeatState: playerState.playbackOptions.repeatMode)
    }
    
    private func fetchAccessToken(completion: @escaping ([String: Any]?, Error?) -> Void) {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let spotifyAuthKey = "Basic \((Constants.Spotify.clientID + ":" + Constants.Spotify.secretKey).data(using: .utf8)!.base64EncodedString())"
        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
                                       "Content-Type": "application/x-www-form-urlencoded"]
        
        var requestBodyComponents = URLComponents()
        let scopeAsString = Constants.Spotify.stringScopes.joined(separator: " ")
        
        requestBodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.Spotify.clientID),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: responseCode!),
            URLQueryItem(name: "redirect_uri", value: Constants.Spotify.redirectURI.absoluteString),
            URLQueryItem(name: "code_verifier", value: ""), // not currently used
            URLQueryItem(name: "scope", value: scopeAsString),
        ]
        
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                              // is there data
                  let response = response as? HTTPURLResponse,  // is there HTTP response
                  (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                  error == nil else {                           // was there no error, otherwise ...
                print("Error fetching token \(error?.localizedDescription ?? "")")
                return completion(nil, error)
            }
            let responseObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            print("Access Token Dictionary=", responseObject ?? "")
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    private func fetchArtwork(for track: SPTAppRemoteTrack) {
        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
            guard let strongSelf = self else { return }
            
            if let error = error {
                print("Error fetching track image: " + error.localizedDescription)
            } else if let image = image as? UIImage {
                strongSelf.delegate?.bbSpotifyViewViewModel(strongSelf, didChangeAlbumImage: image)
            }
        })
    }
    
    private func fetchPlayerState() {
        appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
            if let error = error {
                print("Error getting player state:" + error.localizedDescription)
            } else if let playerState = playerState as? SPTAppRemotePlayerState {
                self?.update(playerState: playerState)
            }
        })
    }
}


extension BBSpotifyViewViewModel: SPTAppRemoteDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        //            updateViewBasedOnConnected()
        appRemote.playerAPI?.delegate = self
        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
            if let error = error {
                print("Error subscribing to player state:" + error.localizedDescription)
            }
        })
        fetchPlayerState()
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        //            updateViewBasedOnConnected()
        lastPlayerState = nil
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        //            updateViewBasedOnConnected()
        lastPlayerState = nil
    }
}

extension BBSpotifyViewViewModel: SPTAppRemotePlayerStateDelegate {
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
        debugPrint("Spotify Track name: %@", playerState.track.name)
        update(playerState: playerState)
    }
}
