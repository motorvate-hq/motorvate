//
//  AllCustomersViewController.swift
//  Motorvate
//
//  Created by Charlie Tuna on 2019-07-25.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

import SafariServices

final class CustomersViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Job.CustomerSectionItem, Job>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Job.CustomerSectionItem, Job>

    private lazy var dataSource = makeDatasource()
    private let viewModel: CustomersViewModel
    
    init(viewModel: CustomersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .systemBackground
        setConstraints()
        settableView()

        viewModel.listCompletedJobs { [weak self] (result) in
            self?.applySnapShot(data: result)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpBackButton()
    }
    
    private func settableView() {
        tableView.backgroundColor = .systemBackground
        tableView.separatorColor = .clear
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setConstraints() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)])
    }
    
    // MARK: - Operations
    private func handleGetJobPreviewLink(job: Job, completion: @escaping ((Result<String, Error>) -> Void)) {
        guard let shop = UserSession.shared.shop,
              let customerPhone = job.contactInfo?.phone?.dropFirst() else {
            return
        }
        let request = PaymentInvoicePreviewLinkRequest(
            shopID: shop.id,
            customerPhone: String(customerPhone),
            jobID: job.jobID,
            customerID: job.customerID ?? "",
            topicArn: shop.topicArn,
            feeFromShop: true
        )
        JobService().getPaymentInvoicePreviewLink(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.url))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func showPreview(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        present(SFSafariViewController(url: url), animated: true)
    }
    
    private func presentDetails(of job: Job) {
        let jobDetailsViewController = ServiceDetailsViewController(
            viewModel:
                JobDetailsViewModel(
                    job: job,
                    depositFeeType: .exclude
                ), excludingDeposit: false
        )
        navigationController?.pushViewController(jobDetailsViewController, animated: true)
    }

    private func setUpBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.register(CustomerJobCell.self)
        tableView.register(DateSectionHeaderFooterView.self)
        tableView.contentInset.top = 15
        tableView.sectionHeaderHeight = 26
        return tableView
    }()
}

private extension CustomersViewController {
    func applySnapShot(data: [Job.CustomerSectionItem]) {
        var snapshot = Snapshot()
        snapshot.appendSections(data)
        data.forEach { section in
            snapshot.appendItems(section.jobList, toSection: section)
        }

        updateEmptyStateShowing(data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func makeDatasource() -> DataSource {
        let datasource = DataSource(tableView: tableView) { (tableView, indexPath, job) -> UITableViewCell? in
            let cell: CustomerJobCell = tableView.dequeueReusableCell(for: indexPath)
            cell.delegate = self
            cell.configure(for: job)
            return cell
        }
        return datasource
    }
}

// MARK: - CustomerJobCellDelegate
extension CustomersViewController: CustomerJobCellDelegate {
    func customerJobCell(didSelectButtonFor job: Job, button: PopupActionButton) {
        guard (UserSession.shared.shop != nil), ((job.contactInfo?.phone) != nil) else {
            presentAlert(title: "Error", message: "Invalid customer phone.")
            return
        }
        button.setAsLoading(true)
        handleGetJobPreviewLink(job: job) { [weak self] result in
            button.setAsLoading(false)
            switch result {
            case .success(let url):
                self?.showPreview(urlString: url)
            case .failure(let error):
                self?.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension CustomersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header: DateSectionHeaderFooterView = tableView.dequeueReusableHeaderFooterView()
        guard let viewModel = viewModel.headerViewModel(at: section) else { return nil }
        header.configure(viewModel)
        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = viewModel.job(at: indexPath)
        presentDetails(of: job)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? CustomerJobCell {
            cell.setAsLoading(false)
        }
    }
}

// MARK: - Navigation Appearance
private extension CustomersViewController {
    func setNavigationBar() {
        let navigationBar = navigationController?.navigationBar
        navigationBar?.backgroundColor = .systemBackground
        navigationBar?.isTranslucent = false
        navigationBar?.shadowImage = UIImage()
    }
}

extension CustomersViewController {
    func updateEmptyStateShowing(_ section: [Job.CustomerSectionItem]) {
        if section.isEmpty {
            tableView.backgroundView = EmptyDataPlaceholderView(
                type: .custom(
                    title: "Once a jobs status is changed to \"Complete\" your previous customers will appear here"
                )
            )
        } else {
            tableView.backgroundView = nil
        }
    }
}
