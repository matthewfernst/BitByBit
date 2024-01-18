//
//  BBMusicServiceView.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/17/24.
//

import UIKit

class BBMusicServiceView: UIView {
    
    // MARK: - Inner Views

    internal let trackStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    internal let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.image = .noAlbum
        return imageView
    }()
    
    internal let trackNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.text = "Not currently playing"
        return label
    }()
    
    internal let trackArtistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "--"
        return label
    }()
    
    internal let controlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
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
        backgroundColor = .secondarySystemBackground
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
    func addTargetsToButtons(with viewModel: BBMusicServiceViewModel) {
        shuffleButton.addTarget(viewModel, action: #selector(viewModel.didTapShuffle(_:)), for: .touchUpInside)
        
        backwardTrackButton.addTarget(viewModel, action: #selector(viewModel.didTapBackwardTrack(_:)), for: .touchUpInside)
        
        playPauseButton.addTarget(viewModel, action: #selector(viewModel.didTapPauseOrPlay(_:)), for: .touchUpInside)
        
        forwardTrackButton.addTarget(viewModel, action: #selector(viewModel.didTapForwardTrack(_:)), for: .touchUpInside)
        
        repeatButton.addTarget(viewModel, action: #selector(viewModel.didTapRepeat(_:)), for: .touchUpInside)
    }
    
    // MARK: - Private
    
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

    
    internal struct Constants {
        static let backwardForwardTrackImageSize = CGSize(width: 35, height: 35)
        static let playPauseTrackImageSize = CGSize(width: 90, height: 90)
        static let shuffleRepeatImageSize = CGSize(width: 30, height: 30)
    }
}
