//
//  BBMusicServiceView.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/17/24.
//

import UIKit

/// Top level class for laying out album artwork, track name, and media controls
class BBMusicServiceView: UIView {
    
    // MARK: - Inner Views
    
    /// Stack view to hold the tracks name and artist
    internal let trackStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    /// Image view depicting the album artwork of the current song
    internal let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.image = .noAlbum
        
        imageView.layer.shadowColor = UIColor.label.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = CGSize(width: -4, height: 4)
        imageView.layer.shadowRadius = 8
        
        return imageView
    }()
    
    /// The currently playing track name
    internal let trackNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Not currently playing"
        return label
    }()
    
    /// The currently playing track's artist
    internal let trackArtistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "--"
        return label
    }()
    
    /// Stack view to hold the media controls: shuffle, repeat, play/pause, skip
    internal let controlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    /// Button to toggle shuffling
    internal let shuffleButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.setImage(
            UIImage(systemName: "shuffle")?.scalePreservingAspectRatio(targetSize: Constants.shuffleRepeatImageSize),
            for: .normal
        )
        button.tintColor = .label
        return button
    }()
    
    /// Button to skip back a song
    internal let backwardTrackButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.setImage(
            UIImage(systemName: "backward.end.fill")?.scalePreservingAspectRatio(targetSize: Constants.backwardForwardTrackImageSize),
            for: .normal
        )
        button.tintColor = .label
        return button
    }()
    
    /// Button to play/pause the currently playing song
    internal let playPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.setImage(
            UIImage(systemName: "play.circle.fill")?.scalePreservingAspectRatio(targetSize: Constants.playPauseTrackImageSize),
            for: .normal
        )
        button.tintColor = .label
        return button
    }()
    
    /// Button to skip forward a song
    internal let forwardTrackButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.setImage(
            UIImage(systemName: "forward.end.fill")?.scalePreservingAspectRatio(targetSize: Constants.backwardForwardTrackImageSize),
            for: .normal
        )
        button.tintColor = .label
        return button
    }()
    
    /// Button to switch through repeat modes: off, one, all
    internal let repeatButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        button.setImage(
            UIImage(systemName: "repeat")?.scalePreservingAspectRatio(targetSize: Constants.shuffleRepeatImageSize),
            for: .normal
        )
        button.tintColor = .label
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        
        trackStackView.addArrangedSubview(trackNameLabel)
        trackStackView.addArrangedSubview(trackArtistLabel)
        
        controlsStackView.addArrangedSubview(shuffleButton)
        controlsStackView.addArrangedSubview(backwardTrackButton)
        controlsStackView.addArrangedSubview(playPauseButton)
        controlsStackView.addArrangedSubview(forwardTrackButton)
        controlsStackView.addArrangedSubview(repeatButton)
        
        addSubviews(albumImageView, trackStackView, controlsStackView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public
    
    /// Add's target to the control buttons. The actions are called to the default BBMusicServiceViewModel protocol matching the same name.
    /// - Parameter viewModel: The view model to tie to the buttons target
    func addTargetsToButtons(with viewModel: BBMusicServiceViewModel) {
        shuffleButton.addTarget(viewModel, action: #selector(viewModel.didTapShuffle(_:)), for: .touchUpInside)
        
        backwardTrackButton.addTarget(viewModel, action: #selector(viewModel.didTapBackwardTrack(_:)), for: .touchUpInside)
        
        playPauseButton.addTarget(viewModel, action: #selector(viewModel.didTapPauseOrPlay(_:)), for: .touchUpInside)
        
        forwardTrackButton.addTarget(viewModel, action: #selector(viewModel.didTapForwardTrack(_:)), for: .touchUpInside)
        
        repeatButton.addTarget(viewModel, action: #selector(viewModel.didTapRepeat(_:)), for: .touchUpInside)
    }
    
    // MARK: - Private
    
    /// Adds constraints to the views
    private func addConstraints() {
        NSLayoutConstraint.activate([
            albumImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            albumImageView.bottomAnchor.constraint(equalTo: trackStackView.topAnchor, constant: -40),
            
            trackStackView.leftAnchor.constraint(equalTo: albumImageView.leftAnchor),
            trackStackView.rightAnchor.constraint(equalTo: rightAnchor),
            trackStackView.bottomAnchor.constraint(equalTo: controlsStackView.topAnchor, constant: -100),
            
            controlsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -100),
            controlsStackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            controlsStackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    /// Constants for button sizes
    internal struct Constants {
        static let backwardForwardTrackImageSize = CGSize(width: 35, height: 35)
        static let playPauseTrackImageSize = CGSize(width: 90, height: 90)
        static let shuffleRepeatImageSize = CGSize(width: 30, height: 30)
    }
}
