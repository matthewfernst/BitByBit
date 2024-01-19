//
//  BBAppleMusicView.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/17/24.
//

import UIKit
import MediaPlayer

/// View showing Apple Music's current playing track / media ctrols
final class BBAppleMusicView: BBMusicServiceView {
    
    // MARK: - Public
    
    /// Configures the view with a view model. Specifically, for track names, album artwork, and controls of buttons. Also, sets the delegate to self for the view model.
    /// - Parameter viewModel: The viewModel to configure with
    public func configure(with viewModel: BBAppleMusicViewViewModel) {
        viewModel.delegate = self
        addTargetsToButtons(with: viewModel)
        viewModel.initialUpdateState()
    }
}

// MARK: - BBAppleMusicViewViewModelDelegate

extension BBAppleMusicView: BBAppleMusicViewViewModelDelegate {
    func bbAppleMusicViewViewModel(_ viewModel: BBAppleMusicViewViewModel, didGetNewAlbum image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.albumImageView.image = image
        }
    }
    
    func bbAppleMusicViewViewModel(_ viewModel: BBAppleMusicViewViewModel, didChangePlayState isPaused: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.playPauseButton.setImage(
                UIImage(systemName: isPaused ? "play.circle.fill" : "pause.circle.fill")?.scalePreservingAspectRatio(targetSize: Constants.playPauseTrackImageSize),
                for: .normal
            )
        }
    }
    
    func bbAppleMusicViewViewModel(_ viewModel: BBAppleMusicViewViewModel, didChangeTrack track: BBAppleMusicTrack) {
        DispatchQueue.main.async { [weak self] in
            self?.trackNameLabel.text = track.name
            self?.trackArtistLabel.text = track.artistName
        }
    }
    
    func bbAppleMusicViewViewModel(_ viewModel: BBAppleMusicViewViewModel, didChangeShuffleState isShuffling: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.shuffleButton.tintColor = isShuffling ? .systemPink : .label
        }
    }
    
    func bbAppleMusicViewViewModel(_ viewModel: BBAppleMusicViewViewModel, didChangeRepeatState repeatMode: MPMusicRepeatMode) {
        let imageName = repeatMode == .one ? "repeat.1" : "repeat"
        DispatchQueue.main.async { [weak self] in
            self?.repeatButton.setImage(
                UIImage(systemName: imageName)?.scalePreservingAspectRatio(targetSize: Constants.shuffleRepeatImageSize),
                for: .normal
            )
            self?.repeatButton.tintColor = repeatMode == .none ? .label : .systemPink
        }
    }
}
