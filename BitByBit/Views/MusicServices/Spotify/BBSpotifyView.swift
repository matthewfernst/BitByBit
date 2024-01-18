//
//  BBSpotifyView.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/16/24.
//

import UIKit

/// View to display Spotify album, current playing track, etc.
final class BBSpotifyView: BBMusicServiceView {
    
    // MARK: - Public
    
    public func configure(with viewModel: BBSpotifyViewViewModel) {
        viewModel.delegate = self
        viewModel.initialUpdateState()
        addTargetsToButtons(with: viewModel)
    }
}

// MARK: - BBSpotifyViewViewModelDelegate

extension BBSpotifyView: BBSpotifyViewViewModelDelegate {
    func bbSpotifyViewViewModel(_ viewModel: BBSpotifyViewViewModel, didChangeAlbumImage image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.albumImageView.image = image
        }
    }
    
    func bbSpotifyViewViewModel(_ viewModel: BBSpotifyViewViewModel, didChangeTrack track: SPTAppRemoteTrack) {
        DispatchQueue.main.async { [weak self] in
            self?.trackNameLabel.text = track.name
            self?.trackArtistLabel.text = track.artist.name
        }
    }
    
    func bbSpotifyViewViewModel(_ viewModel: BBSpotifyViewViewModel, didChangePlayState isPaused: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.playPauseButton.setImage(
                UIImage(systemName: isPaused ? "play.circle.fill" : "pause.circle.fill")?.scalePreservingAspectRatio(targetSize: Constants.playPauseTrackImageSize),
                for: .normal
            )
        }
    }
    
    func bbSpotifyViewViewModel(_ viewModel: BBSpotifyViewViewModel, didChangeShuffleState isShuffling: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.shuffleButton.tintColor = isShuffling ? .systemGreen : .label
        }
    }
    
    
    func bbSpotifyViewViewModel(_ viewModel: BBSpotifyViewViewModel, didChangeRepeatState repeatMode: SPTAppRemotePlaybackOptionsRepeatMode) {
        let imageName = repeatMode == .track ? "repeat.1" : "repeat"
        DispatchQueue.main.async { [weak self] in
            self?.repeatButton.setImage(
                UIImage(systemName: imageName)?.scalePreservingAspectRatio(targetSize: Constants.shuffleRepeatImageSize),
                for: .normal
            )
            self?.repeatButton.tintColor = repeatMode == .off ? .label : .systemGreen
        }
    }
}
