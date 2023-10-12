//
//  CommunicationViewController.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-25.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

final class CommunicationViewController: UIViewController {

    fileprivate enum DisplayConstants {
        static let cellHeight: CGFloat = 89.7
    }

    fileprivate let viewModel = CommunicationViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.register(CommunicationViewCell.self)
        tableView.refreshControl = UIRefreshControl()
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.isVisible = true
        
        setUpBackButton()
        viewModel.fetchChatHistories()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.isVisible = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.didReceiveAction = { [weak self] action in
            self?.handle(action)
        }

        viewModel.fetchChatHistories()
        setup()
        NotificationRepository.shared.addListener(self)
    }

    private func handle(_ action: CommunicationViewModel.Action) {
        switch action {
        case .reloadData:
            tableView.backgroundView = nil
            tableView.reloadData()
            tableView.refreshControl?.endRefreshing()
        case .setLoadingMode(let shouldLoad):
            setAsLoading(shouldLoad)
        case .showAlert:
            presentAlert(title: "Error", message: "Something went wrong.") // Generic for now.
        case .showPlaceholder:
            tableView.backgroundView = EmptyDataPlaceholderView(type: .custom(title: "No chat histories found."))
        }
    }

    private func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setUpBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    @objc private func refreshData() {
        viewModel.fetchChatHistories()
    }
}

// MARK: - UITableViewDataSource

extension CommunicationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommunicationViewCell = tableView.dequeueReusableCell(for: indexPath)
        let customer = viewModel.item(at: indexPath)
        let isLast = viewModel.isLastItem(at: indexPath)
        
        cell.configure(with: customer, isLastAtIndex: isLast)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatViewModel = ChatViewModel(chatHistory: viewModel.item(at: indexPath))
        let chatViewController = ChatViewController(viewModel: chatViewModel)
        navigationController?.pushViewController(chatViewController, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension CommunicationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DisplayConstants.cellHeight
    }
}

// MARK: NotificationRepositoryListener
extension CommunicationViewController: NotificationRepositoryListener {    
    func receivedNotification(type: APNsNotificationType) {
        switch type {
        case .newMessage:
            viewModel.fetchChatHistories()
        default:
            break
        }
    }
    
    func receivedNotificationInteraction(type: APNsNotificationType) {
        switch type {
        case .newMessage:
            viewModel.fetchChatHistories()
        default:
            break
        }
    }
}
