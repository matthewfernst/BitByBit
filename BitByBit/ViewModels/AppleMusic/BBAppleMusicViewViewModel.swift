//
//  BBAppleMusicViewViewModel.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/17/24.
//

import MusicKit
import MediaPlayer

protocol BBAppleMusicViewViewModelDelegate: AnyObject {
    func bbAppleMusicViewViewModel(_ viewModel: BBAppleMusicViewViewModel, didGetNewAlbum image: UIImage)
    
    func bbAppleMusicViewViewModel(_ viewModel: BBAppleMusicViewViewModel, didChangePlayState isPaused: Bool)
    
    func bbAppleMusicViewViewModel(_ viewModel: BBAppleMusicViewViewModel, didChangeTrack track: BBAppleMusicTrack)
    
    func bbAppleMusicViewViewModel(_ viewModel: BBAppleMusicViewViewModel, didChangeShuffleState isShuffling: Bool)
    
    func bbAppleMusicViewViewModel(_ viewModel: BBAppleMusicViewViewModel, didChangeRepeatState repeatMode: MPMusicRepeatMode)
}

final class BBAppleMusicViewViewModel: BBMusicServiceViewModel {
        
    public weak var delegate: BBAppleMusicViewViewModelDelegate?
    
    private let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    // MARK: - Init
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlaybackStateChange), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: musicPlayer)
        
        musicPlayer.beginGeneratingPlaybackNotifications()
    }
    
    deinit {
        musicPlayer.endGeneratingPlaybackNotifications()
    }
    
    // MARK: - Public
    
    
    @objc
    func didTapShuffle(_ button: UIButton) {
        musicPlayer.shuffleMode = musicPlayer.shuffleMode == .off ? .songs : .off
    }
    
    @objc
    func didTapBackwardTrack(_ button: UIButton) {
        musicPlayer.skipToPreviousItem()
    }
    
    @objc
    func didTapPauseOrPlay(_ button: UIButton) {
        musicPlayer.playbackState == .playing ? musicPlayer.pause() : musicPlayer.play()
    }
    
    @objc
    func didTapForwardTrack(_ button: UIButton) {
        musicPlayer.skipToNextItem()
    }
    
    @objc
    func didTapRepeat(_ button: UIButton) {
        switch musicPlayer.repeatMode {
        case .default, .one:
            musicPlayer.repeatMode = .none
        case .none:
            musicPlayer.repeatMode = .all
        case .all:
            musicPlayer.repeatMode = .one
        @unknown default:
            musicPlayer.repeatMode = .none
        }
    }
    
    // MARK: - Public
    
    public func initialUpdateState() {
        handlePlaybackStateChange()
    }
    
    // MARK: - Private
    
    @objc
    private func handlePlaybackStateChange() {
        let playbackState = musicPlayer.playbackState
        guard let nowPlayingItem = musicPlayer.nowPlayingItem,
        let trackName = nowPlayingItem.title,
        let artist = nowPlayingItem.artist else {
            print("Unable to get Artist and Track")
            return
        }
        
        if let albumArtwork = nowPlayingItem.artwork?.image(at: CGSize(width: 100, height: 100)) {
            delegate?.bbAppleMusicViewViewModel(self, didGetNewAlbum: albumArtwork)
        }
        
        delegate?.bbAppleMusicViewViewModel(self, didChangeTrack: BBAppleMusicTrack(name: trackName, artistName: artist))
        delegate?.bbAppleMusicViewViewModel(self, didChangeShuffleState: musicPlayer.shuffleMode != .off)
        delegate?.bbAppleMusicViewViewModel(self, didChangeRepeatState: musicPlayer.repeatMode)
        
        
        switch playbackState {
        case .stopped:
            print("Music is stopped")
            delegate?.bbAppleMusicViewViewModel(self, didChangePlayState: true)
        case .playing:
            print("Music is playing")
            delegate?.bbAppleMusicViewViewModel(self, didChangePlayState: false)
        case .paused:
            print("Music is paused")
            delegate?.bbAppleMusicViewViewModel(self, didChangePlayState: true)
        case .interrupted:
            print("Music is interrupted")
            delegate?.bbAppleMusicViewViewModel(self, didChangePlayState: true)
        case .seekingForward:
            print("Music is seeking forward")
        case .seekingBackward:
            print("Music is seeking backward")
            
        @unknown default:
            print("shittt")
            break
        }
    }
}
