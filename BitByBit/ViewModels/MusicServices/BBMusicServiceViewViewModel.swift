//
//  BBMusicServiceViewViewModel.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/17/24.
//

import Foundation


/// Protocol for BBSpotify and BBAppleMusic View Models to abide by
@objc
protocol BBMusicServiceViewModel {
    @objc
    func didTapShuffle(_ button: UIButton)
    
    @objc
    func didTapBackwardTrack(_ button: UIButton)
    
    @objc
    func didTapPauseOrPlay(_ button: UIButton)
    
    @objc
    func didTapForwardTrack(_ button: UIButton)
    
    @objc
    func didTapRepeat(_ button: UIButton)
    
    func initialUpdateState()
}
