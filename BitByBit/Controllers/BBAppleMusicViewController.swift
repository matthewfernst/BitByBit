//
//  BBAppleMusicViewController.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/17/24.
//

import UIKit

final class BBAppleMusicViewController: UIViewController {
    
    private let viewModel = BBAppleMusicViewViewModel()
    
    private let appleMusicView = BBAppleMusicView()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = " Music"
        navigationController?.navigationBar.prefersLargeTitles = true
        appleMusicView.configure(with: viewModel)
        view.addSubview(appleMusicView)
        addConstraints()
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            appleMusicView.topAnchor.constraint(equalTo: view.topAnchor),
            appleMusicView.leftAnchor.constraint(equalTo: view.leftAnchor),
            appleMusicView.rightAnchor.constraint(equalTo: view.rightAnchor),
            appleMusicView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
