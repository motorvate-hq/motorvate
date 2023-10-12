//
//  SettingsVC.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-25.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let logoutPromptMessage = "Are you sure you want to log out?"
}

final class SettingsViewController: UITableViewController {
    
    // MARK: - Variables
    weak var coordinator: SettingsCoordinator?
    private let viewModel: SettingsViewModel

    // MARK: - Lifecycle
    init(_ viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Settings"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func reloadConnectBank() {
        viewModel.hasConnectedBank()
    }
    
    private func showLogoutPopup() {
        BaseViewController.presentAlert(message: Constants.logoutPromptMessage, closeActionText: "Cancel", from: self) { [weak self] in
            self?.viewModel.signOut()
        }
    }
    
    private func present(from item: SettingItem) {
        switch item {
        case .account:              coordinator?.showAccountSettings()
        case .automatedMessage:     print("Automated Message")
        case .businessInformation:  print("Business information")
        case .contentLibrary:       print("Content Library")
        case .logout:               showLogoutPopup()
        case .addTeamMembers:       coordinator?.showAddTeamMember()
        case .shopNameAndPhone:     print("Shop name")
        case .connectBank:          coordinator?.showConnectBank()
        case .updateBank:           coordinator?.showUpdateBank()
        }
    }

    private func setup() {
        view.backgroundColor = .systemBackground

        tableView.register(SettingsViewCell.self)
        tableView.backgroundColor = .systemBackground
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none

        viewModel.showUpdateConnectBank.bind { [weak self] showUpdateConnectBank in
            if showUpdateConnectBank != nil {
                guard let connectIndexPath = self?.viewModel.indexPath(for: .connectBank),
                      let updateIndexPath = self?.viewModel.indexPath(for: .updateBank)
                      else { return }
                self?.tableView.reloadRows(at: [connectIndexPath, updateIndexPath], with: .fade)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsViewCell = tableView.dequeueReusableCell(for: indexPath)
        let item = viewModel.item(at: indexPath)
        cell.configure(item)
            
        switch item {
        case .connectBank:
            cell.isHidden = viewModel.showUpdateConnectBank.value != .connect
        case .updateBank:
            cell.isHidden = viewModel.showUpdateConnectBank.value != .update
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = viewModel.item(at: indexPath)
        switch item {
        case .connectBank:
            return viewModel.showUpdateConnectBank.value == .connect ? 65 : 0
        case .updateBank:
            return viewModel.showUpdateConnectBank.value == .update ? 65 : 0
        default:
            return 65
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath)
        present(from: item)
    }
}
