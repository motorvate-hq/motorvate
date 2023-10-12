//
//  SettingsAccountViewController.swift
//  Motorvate
//
//  Created by Emmanuel on 11/21/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit
import Combine

class AccountSettingsViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []

    private enum DisplayConstants {
        static let cellHeight: CGFloat = 72
        
        static let alertTitle = "Deleting the account"
        static let alertMessage = """
        Are you sure you want to delete
               your account?
        This action is irreverisble.
        """
    }

    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableFooterView = UIView(frame: .zero)
        table.separatorStyle = .none
        return table
    }()

    weak var coordinator: SettingsCoordinator?
    private let viewModel: AccountSettingsViewModel
    
    init(_ viewModel: AccountSettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.$accountDeletionComplete
            .sink { [weak self] success in
                if success {
                    self?.setAsLoading(false)
                    self?.viewModel.signOut()
                }
            }.store(in: &cancellables)
    }

    private func setup() {
        title = "My Account"

        view.backgroundColor = .systemBackground

        tableView.register(AccountSettingCell.self)
        tableView.register(AccountSettingSwitchCell.self)
        tableView.register(AccountSettingDeleteCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }

    private func deleteHandler(alert: UIAlertAction!) {
        guard let userID = UserSession.shared.userID else { return }
        setAsLoading(true)
        viewModel.delete(userId: userID)
    }
    
    private func present(from item: AccountSettingItem) {
        switch item {
        case .changeEmail:
            print("tap changeEmail")
        case .connectToAccounts:
            print("tap connectToAccounts")
        case .changePassword:
            coordinator?.showChangePassword()
        case .development, .deleteAccount:
            break
        }
        
    }
}

// MARK: - UITableViewDataSource
extension AccountSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = AccountSettingItem(rawValue: indexPath.row) else { return UITableViewCell() }
        switch cellType {
        case .changeEmail, .changePassword, .connectToAccounts:
            let cell: AccountSettingCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel.item(at: indexPath))
            return cell
        case .development:
            let cell: AccountSettingSwitchCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel.item(at: indexPath))
            return cell
        case .deleteAccount:
            let cell: AccountSettingDeleteCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel.item(at: indexPath), delegate: self)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension AccountSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.item(at: indexPath)
        present(from: item)
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DisplayConstants.cellHeight
    }
}

// MARK: - AccountSettingDeleteCellDelegate
extension AccountSettingsViewController: AccountSettingDeleteCellDelegate {
    func handleDeleteAction() {
        let alertController = UIAlertController(title: DisplayConstants.alertTitle, message: DisplayConstants.alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Yes, I'm sure", style: .destructive, handler: deleteHandler(alert:)))
        present(alertController, animated: true, completion: nil)
    }
}
