//
//  BBAuthorizationView.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/14/24.
//

import UIKit

/// Full authorization view with buttons, title, and background image.
class BBAuthorizationView: UIView {
    
    private let authorizationButtonStackView = BBAuthorizationButtonStackView()
        
    private var appleMusicHandler: ((String) -> Void)?
    
    // MARK: - Init
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 36, weight: .semibold)
        
        label.textAlignment = .center
        label.text = "Bit by Bit"
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: .authorizeBackground)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        authorizationButtonStackView.delegate = self
        
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(backgroundImageView, titleLabel, authorizationButtonStackView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public

    public func registerAppleMusicHandler(_ block: @escaping (String) -> Void) {
        self.appleMusicHandler = block
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundImageView.heightAnchor.constraint(equalToConstant: 350),
            backgroundImageView.widthAnchor.constraint(equalToConstant: 350),
            
            titleLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            authorizationButtonStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            authorizationButtonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            authorizationButtonStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ])
    }
}

extension BBAuthorizationView: BBAuthorizationButtonStackViewDelegate {
    func bbAuthorizationButtonStackView(_ stackView: BBAuthorizationButtonStackView, didTapAuthorizeSpotify accessToken: String) {
        print("Not getting here??")
    }
    
    func bbAuthorizationButtonStackView(_ stackView: BBAuthorizationButtonStackView, didTapAuthorizeAppleMusic accessToken: String) {
        appleMusicHandler?(accessToken)
    }
}
