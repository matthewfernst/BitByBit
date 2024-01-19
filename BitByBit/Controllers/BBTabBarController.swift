//
//  BBTabBarController.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/16/24.
//

import UIKit

final class BBTabBarController: UITabBarController {
    
    private let musicServiceVC: UIViewController
    
    // MARK: - Init

    init(musicServiceVC: UIViewController) {
        self.musicServiceVC = musicServiceVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }
    
    // MARK: - Private
    
    private func setUpTabs() {
        let settingsVC = BBSettingsTableViewController()
        let isSpotifyVC = musicServiceVC is BBSpotifyViewController
        let tabBarItemColor: UIColor = isSpotifyVC ? .systemGreen : .systemPink
        let musicTabBarItemTitle = isSpotifyVC ? "Spotify" : "Apple Music"
        
        let musicServiceNav = UINavigationController(rootViewController: musicServiceVC)
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        
        musicServiceNav.tabBarItem = getCustomTabBarItem(titled: musicTabBarItemTitle, withSystemImageName: "music.note.house.fill", colored: tabBarItemColor, andTagged: 1)
        
        settingsNav.tabBarItem = getCustomTabBarItem(titled: "Settings", withSystemImageName: "gear", colored: tabBarItemColor, andTagged: 2)
        
        let allNavVC = [musicServiceNav, settingsNav]
        
        allNavVC.forEach { $0.navigationController?.navigationBar.prefersLargeTitles = true }
        
        setViewControllers(allNavVC, animated: true)
    }

    
    private func getCustomTabBarItem(titled title: String, withSystemImageName systemName: String, colored color: UIColor, andTagged tag: Int) -> UITabBarItem {
        let tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: systemName), tag: tag)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: .selected)
        tabBarItem.selectedImage = UIImage(systemName: systemName)?.withRenderingMode(.alwaysOriginal).withTintColor(color)
        return tabBarItem
    }
    
}
