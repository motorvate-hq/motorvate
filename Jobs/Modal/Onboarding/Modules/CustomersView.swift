//
//  OnBoardingCustomersViewController.swift
//  Motorvate
//
//  Created by Emmanuel on 8/10/19.
//  Copyright © 2019 motorvate. All rights reserved.
//

import UIKit

private enum CustomersViewConstant {
    static let defaultWidth: CGFloat = 276
    static let emptyDataViewMessage = """
                                      Whoops!
                                      Looks like you dont have any Inquiries created.
                                      Go to New Inquiry to add new.
                                      """
}

class CustomerInquiryViewController: UIViewController {

    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .systemGray6
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomerViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return collectionView
    }()
    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()

    // MARK: - Variables
    private let viewModel: OnboardViewModel
    var selectInquiryHandler: ((Inquiry) -> Void)?
    
    // MARK: - Lifecycle
    init(_ viewModel: OnboardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        setView()
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let shopID = UserSession.shared.shopID else { return }
        showLoading(true)
        viewModel.getAllInquiries(for: shopID) { [weak self] in
            self?.showLoading(false)
            self?.collectionView.reloadData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func showLoading(_ isLoading: Bool) {
        collectionView.isHidden = isLoading
        isLoading ? activityIndicatorView.startAnimating() : activityIndicatorView.stopAnimating()
    }
}

private extension CustomerInquiryViewController {
    
    // MARK: - UI Setup
    private func setView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        view.addSubview(activityIndicatorView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        activityIndicatorView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
    }
}

extension CustomerInquiryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        updateEmptyState()
        return viewModel.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CustomerViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(viewModel, indexPath: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
        selectInquiryHandler?(viewModel.item(at: indexPath))
    }
}

extension CustomerInquiryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let note = viewModel.note(at: indexPath)
        let calculatedWidth = width(for: note)
        return CGSize(width: calculatedWidth, height: view.frame.height)
    }

    private func width(for item: String) -> CGFloat {
        let sizingLabel = UILabel()
        sizingLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        sizingLabel.text = item
        let size = sizingLabel.intrinsicContentSize
        print(size.height)
        let half = view.frame.width / 2
        if size.width < half {
            return half
        }
        return size.width
    }
}

// MARK: EmptyDataViewProviding
extension CustomerInquiryViewController {
    func updateEmptyState() {
        if viewModel.numberOfItems == 0 {
            collectionView.backgroundView = EmptyDataPlaceholderView(type: .custom(title: CustomersViewConstant.emptyDataViewMessage))
        } else {
            collectionView.backgroundView = nil
        }
    }
}
