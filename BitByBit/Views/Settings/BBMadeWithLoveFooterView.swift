//
//  BBMadeWithLoveFooterView.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/18/24.
//

import UIKit

final class BBMadeWithLoveFooterView: UITableViewHeaderFooterView {
    static let footerIdenitifer = "BBMadeWithLoveFooterView"
    
    private let madeWithLoveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let appVersionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Init
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(madeWithLoveLabel, appVersionLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        appVersionLabel.text = nil
        madeWithLoveLabel.text = nil
    }
    
    // MARK: - Public
    
    public func configure(withAppVersion appVersion: String) {
        appVersionLabel.text = "App Version - \(appVersion)"
        madeWithLoveLabel.text = "Made with ❤️+☕️ in San Diego, CA and Seattle, WA"
    }

    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            madeWithLoveLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            madeWithLoveLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            appVersionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20),
            appVersionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}
