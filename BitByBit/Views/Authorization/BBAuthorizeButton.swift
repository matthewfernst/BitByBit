//
//  BBAuthorizeButton.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/14/24.
//

import UIKit

/// Button view for authorization of Spotify and Apple Music
final class BBAuthorizeButton: UIButton {

    // MARK: - Init

    init(frame: CGRect, withLogoImageName logoImageName: String, serviceName: String) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configuration = createConfiguration(withLogoImageName: logoImageName, serivceName: serviceName)
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [weak self] (_: Self, _: UITraitCollection) in
            self?.configuration = self?.createConfiguration(withLogoImageName: logoImageName, serivceName: serviceName)
        }
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    
    /// Creates a configuration for the Authorization buttons for Spotify and Apple Music. Sets color, text, and the logo for the button.
    /// - Parameters:
    ///   - logoImageName: The name of the image depicting the logo to show
    ///   - serivceName: The service to added to the text "Authorize"
    /// - Returns: A UIButton.Configuration for the authorization button.
    private func createConfiguration(withLogoImageName logoImageName: String, serivceName: String) -> UIButton.Configuration{
        var config: UIButton.Configuration = .borderedProminent()
        config.baseBackgroundColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
        config.cornerStyle = .capsule
        
        // Setting up service name image
        let logoSize: CGFloat = 22
        if let logoImage = UIImage(named: logoImageName) {
            config.image = logoImage.scalePreservingAspectRatio(targetSize: CGSize(width: logoSize, height: logoSize))
            config.imagePadding = 4
            config.imagePlacement = .leading
        }
        
        config.attributedTitle = AttributedString("Authorize \(serivceName)", attributes: AttributeContainer([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium),
            NSAttributedString.Key.foregroundColor: traitCollection.userInterfaceStyle == .dark ? UIColor.black : .white
        ]))
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0)
        
        return config
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40),
            widthAnchor.constraint(equalToConstant: 250),
        ])
    }
}
