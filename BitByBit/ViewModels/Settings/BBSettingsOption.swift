//
//  BBSettingsOption.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/17/24.
//

import UIKit

enum BBSettingsOption: CaseIterable {
    case rateApp
    case logout
    case viewCode
    case viewSpotifyAPI
    case viewMusicKit
    case contactUs
    
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .logout:
            return "Logout"
        case .viewCode:
            return "View App Code"
        case .viewSpotifyAPI:
            return "View Spotify API"
        case .viewMusicKit:
            return "View MusicKit"
        case .contactUs:
            return "Contact Us"
        }
    }
    
    
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .logout:
            return UIImage(systemName: "door.right.hand.closed")
        case .viewCode:
            return UIImage(systemName: "curlybraces")
        case .viewSpotifyAPI:
            return .spotifyLogo
        case .viewMusicKit:
            return .musickitLogo
        case .contactUs:
            return UIImage(systemName: "paperplane.fill")
        }
    }
    
    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemYellow
        case .logout:
            return .systemRed
        case .viewCode:
            return .systemBlue
        case .viewSpotifyAPI:
            return .black
        case .viewMusicKit:
            return UIColor(white: 0.95, alpha: 0.8)
        case .contactUs:
            return .systemIndigo
        }
    }
    
    var targetURL: URL? {
        switch self {
        case .viewCode:
            return URL(string: "https://github.com/matthewfernst/BitByBit")
        case .viewSpotifyAPI:
            return URL(string: "https://developer.spotify.com/documentation/ios")
        case .viewMusicKit:
            return URL(string: "https://developer.apple.com/musickit/")
        default:
            return nil
        }
    }
    
}
