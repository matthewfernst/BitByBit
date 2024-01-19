//
//  BBSettingsTableViewController.swift
//  BitByBit
//
//  Created by Matthew Ernst on 1/16/24.
//

import UIKit
import SafariServices
import MessageUI
import StoreKit

class BBSettingsTableViewController: UITableViewController {
    
    private let viewModel = BBSettingsTableViewControllerViewModel(
        cellViewModelsBySection: [
            // API Section
            [BBSettingsOption.viewCode, .viewSpotifyAPI, .viewMusicKit].compactMap {
                return BBSettingsTableViewCellViewModel(option: $0)
            },
            
            // Other Section
            [BBSettingsOption.rateApp, .contactUs, .logout].compactMap {
                return BBSettingsTableViewCellViewModel(option: $0)
            }
        ]
    )
    
    // MARK: - Init
    
    init() {
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Settings"
        
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(BBSettingsTableViewCell.self, forCellReuseIdentifier: BBSettingsTableViewCell.cellIdentifier)
        tableView.register(BBMadeWithLoveFooterView.self, forHeaderFooterViewReuseIdentifier: BBMadeWithLoveFooterView.footerIdenitifer)

        setTableViewColors()
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { [weak self] (_: Self, _: UITraitCollection) in
            self?.setTableViewColors()
        }
    }
    
    // MARK: - Private

    private func setTableViewColors() {
        if traitCollection.userInterfaceStyle == .dark {
            // Dark Mode
            view.backgroundColor = .secondarySystemBackground
            tableView.backgroundColor = .systemBackground
        } else {
            // Light Mode
            view.backgroundColor = .systemBackground
            tableView.backgroundColor = .secondarySystemBackground
        }
    }
    
    private func handleTap(of cellViewModel: BBSettingsTableViewCellViewModel) {
        guard Thread.current.isMainThread else {
            return
        }
        
        switch cellViewModel.option {
        case .viewCode, .viewSpotifyAPI, .viewMusicKit:
            if let url = cellViewModel.option.targetURL {
                let vc = SFSafariViewController(url: url)
                present(vc, animated: true)
            }
        case .rateApp:
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        case .contactUs:
            openMailWithBugReport()
        case .logout:
            goToWelcomeScreen()
        }
    }
    
    private func openMailWithBugReport() {
        let email = "matthew.f.ernst@icloud.com"
        let body = """
                       Hello,
                       
                       I would like to report a bug in the app. Here are the details:
                       
                       - App Version: [App Version]
                       - Device: [Device Model]
                       - iOS Version: [iOS Version]
                       
                       Bug Description:
                       [Describe the bug you encountered]
                       
                       Steps to Reproduce:
                       [Provide steps to reproduce the bug]
                       
                       Expected Behavior:
                       [Describe what you expected to happen]
                       
                       Actual Behavior:
                       [Describe what actually happened]
                       
                       Additional Information:
                       [Provide any additional relevant information]
                       
                       Thank you for your attention to this matter.
                       
                       Regards,
                       [Your Name]
                       """
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = self
            composer.setToRecipients([email])
            composer.setSubject("BitByBit Bug Report: [Brief Description]")
            
            composer.setMessageBody(body, isHTML: false)
            
            self.present(composer, animated: true)
        } else {
            let ac = UIAlertController(title: "Failed to Open Mail", message: "We were unable to open the Mail app. Please send an email to \(email). You can copy the bug report template below.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Copy Bug Report Template", style: .default) {_ in
                UIPasteboard.general.string = body
            })
            ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    private func goToWelcomeScreen() {
        dismiss(animated: true)
    }
    
    // MARK: - UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.cellViewModelsBySection.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModelsBySection[section].count
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == viewModel.cellViewModelsBySection.count - 1 {
            guard let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: BBMadeWithLoveFooterView.footerIdenitifer) as? BBMadeWithLoveFooterView else {
                return nil
            }
            
            if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                footer.configure(withAppVersion: appVersion)
            }
            return footer
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == viewModel.cellViewModelsBySection.count - 1 ? 100 : 0
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BBSettingsTableViewCell.cellIdentifier, for: indexPath) as? BBSettingsTableViewCell else {
            fatalError("Unable to dequeue BBSettingsTableViewCell")
        }
        cell.configure(with: viewModel.cellViewModelsBySection[indexPath.section][indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handleTap(of: viewModel.cellViewModelsBySection[indexPath.section][indexPath.row])
    }
}

extension BBSettingsTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
