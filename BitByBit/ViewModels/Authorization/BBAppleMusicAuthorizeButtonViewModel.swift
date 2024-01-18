//
//  BBAppleMusicAuthorizeButtonViewModel.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/17/24.
//

import MusicKit

protocol BBAppleMusicAuthorizeButtonViewModelDelegate: AnyObject {
    func bbAppleMusicAuthorizeButtonViewModel(_ viewModel: BBAppleMusicAuthorizeButtonViewModel, didSuccessfullyAuthorize success: Bool)
}

final class BBAppleMusicAuthorizeButtonViewModel {

    public weak var delegate: BBAppleMusicAuthorizeButtonViewModelDelegate?
    
    private var musicAuthorizationStatus: MusicAuthorization.Status = .notDetermined {
        didSet {
            if musicAuthorizationStatus == .authorized {
                delegate?.bbAppleMusicAuthorizeButtonViewModel(self, didSuccessfullyAuthorize: true)
            }
        }
    }
    
    // MARK: - Init
    
    init() {}
    
    // MARK: - Public
    
    public func authorizeAppleMusic() {
        switch MusicAuthorization.currentStatus {
        case .notDetermined:
            Task {
                let musicAuthorizationStatus = await MusicAuthorization.request()
                await update(with: musicAuthorizationStatus)
            }
        case .denied:
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        case .authorized:
            print("Already authorized!")
            delegate?.bbAppleMusicAuthorizeButtonViewModel(self, didSuccessfullyAuthorize: true)
        default:
            fatalError("This should not happen")
        }
    }
    
    
    // MARK: - Private
    @MainActor
    private func update(with musicAuthorizationStatus: MusicAuthorization.Status) {
        self.musicAuthorizationStatus = musicAuthorizationStatus
    }
}
