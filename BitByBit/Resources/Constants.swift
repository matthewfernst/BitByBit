//
//  Constants.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/14/24.
//

import Foundation

struct Constants {
    struct Spotify {
        static let clientID = "4b54195c4e1e4c98a753bcab8f61cfe8"
        static let redirectURI = URL(string: "spotify-ios-quick-start://spotify-login-callback")!
        static let accessTokenKey = "access-token-key"
        static let secretKey = "35f08e662c994eadafd175b1f570700d"
        
        static let scopes: SPTScope = [
            .userReadEmail, .userReadPrivate,
            .userReadPlaybackState, .userModifyPlaybackState, .userReadCurrentlyPlaying,
            .streaming, .appRemoteControl,
            .playlistReadCollaborative, .playlistModifyPublic, .playlistReadPrivate, .playlistModifyPrivate,
            .userLibraryModify, .userLibraryRead,
            .userTopRead, .userReadPlaybackState, .userReadCurrentlyPlaying,
            .userFollowRead, .userFollowModify,
        ]
        
        static let stringScopes = [
            "user-read-email", "user-read-private",
            "user-read-playback-state", "user-modify-playback-state", "user-read-currently-playing",
            "streaming", "app-remote-control",
            "playlist-read-collaborative", "playlist-modify-public", "playlist-read-private", "playlist-modify-private",
            "user-library-modify", "user-library-read",
            "user-top-read", "user-read-playback-position", "user-read-recently-played",
            "user-follow-read", "user-follow-modify",
        ]
    }
}
