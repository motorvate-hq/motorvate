//
//  JobStatusPopupController.swift
//  Motorvate
//
//  Created by Nikita Benin on 15.03.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

private struct Constants {
    static let backgroundCornerRadius: CGFloat = 20
    static let closeButtonSize: CGFloat = 40
    static let cellHeight: CGFloat = 60 + 13
}

class JobStatusPopupController: PopupController {

    // MARK: - UI Elements
    private let backgroundBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.backgroundCornerRadius
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Current Status"
        label.font = AppFont.archivo(.bold, ofSize: 19)
        label.textColor = UIColor(red: 0.078, green: 0.078, blue: 0.078, alpha: 1)
        return label
    }()
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.closeIcon(), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return button
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(JobStatusCell.self)
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: - Variables
    private(set) var handler: ((Job.Status) -> Void)?
    private var cellModels: [JobStatusCellModel]
    
    // MARK: - Lifecycle
    init(status: Job.Status, handler: ((Job.Status) -> Void)?) {
        self.handler = handler
        self.cellModels = JobStatusCellModel.allCases.filter({ $0.jobStatus != status })
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backgroundBackView.transform = CGAffineTransform(translationX: 0, y: 500)
        UIView.animate(withDuration: 0.3) {
            self.backgroundBackView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - UI Setup
    private func setView() {
        view.addSubview(backgroundBackView)
        backgroundBackView.addSubview(titleLabel)
        closeButton.addTarget(self, action: #selector(animateAndDismiss), for: .touchUpInside)
        backgroundBackView.addSubview(closeButton)
        tableView.delegate = self
        tableView.dataSource = self
        backgroundBackView.addSubview(tableView)
    }
    
    private func setupConstraints() {
        backgroundBackView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(44)
            make.centerX.equalToSuperview()
        }
        closeButton.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(Constants.closeButtonSize)
        }
        tableView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(37)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.cellHeight * CGFloat(cellModels.count) + 10)
            make.bottom.equalToSuperview().inset(10 + Constants.backgroundCornerRadius)
        }
    }
    
    // MARK: - Appearance animation
    override func animateDisappear(completion: ((Bool) -> Void)?) {
        super.animateDisappear(completion: completion)
        backgroundBackView.transform = CGAffineTransform(translationX: 0, y: 0)
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundBackView.transform = CGAffineTransform(translationX: 0, y: 500)
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - UITableViewDelegate
extension JobStatusPopupController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animateDisappear { [weak self] _ in
            self?.dismiss(animated: false, completion: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.handler?(strongSelf.cellModels[indexPath.row].jobStatus)
            })
        }
    }
}

// MARK: - UITableViewDataSource
extension JobStatusPopupController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JobStatusCell = tableView.dequeueReusableCell(for: indexPath)
        cell.setCell(model: cellModels[indexPath.row])
        return cell
    }
}
