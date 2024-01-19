//
//  BBSettingsTableViewCellViewModel.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/17/24.
//

import UIKit
import SafariServices

final class BBSettingsTableViewCellViewModel {
    
    let option: BBSettingsOption
    
    // MARK: - Init

    init(option: BBSettingsOption) {
        self.option = option
    }
    
    // MARK: - Public
    
    public var title: String {
        option.displayTitle
    }

    public var iconImage: UIImage? {
        option.iconImage
    }
    
    public var iconContainerColor: UIColor {
        option.iconContainerColor
    }
}
