//
//  BBSettingsTableViewCell.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/17/24.
//

import UIKit

/// Settings Table View Cell for showing a single setting
final class BBSettingsTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "BBSettingsTableViewCell"
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let iconContainerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        iconContainerView.addSubview(iconImageView)
        contentView.addSubviews(iconContainerView, titleLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        iconImageView.image = nil
        iconContainerView.backgroundColor = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.frame.size.height - 12
        iconContainerView.frame = CGRect(x: 10, y: 6, width: size, height: size)
        
        let imageSize: CGFloat = size/1.5
        iconImageView.frame = CGRect(x: (size - imageSize)/2, y: (size - imageSize)/2, width: imageSize, height: imageSize)
        
        titleLabel.frame = CGRect(
            x: 20 + iconContainerView.frame.size.width,
            y: 0,
            width: contentView.frame.size.width - 20 - iconContainerView.frame.size.width,
            height: contentView.frame.size.height
        )
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: BBSettingsTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        iconImageView.image = viewModel.iconImage
        iconContainerView.backgroundColor = viewModel.iconContainerColor
    }
}
