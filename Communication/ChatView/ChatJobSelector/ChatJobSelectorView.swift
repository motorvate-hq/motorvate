//
//  ChatJobSelectorView.swift
//  Motorvate
//
//  Created by Nikita Benin on 20.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import SnapKit

import UIKit

private struct Constants {
    static let arrowImageViewSize: CGSize = CGSize(width: 25, height: 15)
    static let sideInset: CGFloat = 25
    static let maxHeight: CGFloat = UIScreen.main.bounds.height - 300
    static let cornerRadius: CGFloat = 8
    static let topPadding = UIApplication.shared.windows[0].safeAreaInsets.top + 40
}

class ChatJobSelectorView: UIView {

    // MARK: Variables
    var didSelectCellAction: ((ChatJobSelectorCellModel) -> Void)?
    private var viewModel: ChatJobSelectorViewModel?
    
    // MARK: UI Elements
    private let tappableView: UIView = UIView()
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.popupArrow()
        return imageView
    }()
    private let backView: UIView = {
        let view = UIView()
        view.layer.addShadow(
            backgroundColor: .white,
            shadowColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.15),
            cornerRadius: Constants.cornerRadius,
            shadowRadius: 7,
            shadowOffset: CGSize(width: 2, height: 2)
        )
        view.layer.borderColor = UIColor(red: 0.796, green: 0.796, blue: 0.796, alpha: 0.5).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.clipsToBounds = true
        tableView.bounces = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 75, bottom: 0, right: 10)
        tableView.register(ChatJobSelectorCell.self)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: Lifecycle    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismissView() {
        isHidden = true
    }
    
    func configure(with viewModel: ChatJobSelectorViewModel) {
        self.viewModel = viewModel
        backView.snp.updateConstraints { (make) -> Void in
            make.height.equalTo(viewHeight())
        }
        tableView.reloadData()
    }
    
    private func viewHeight() -> CGFloat {
        let contentHeight = ChatJobSelectorCell.cellHeight * CGFloat(viewModel?.numberOfItems() ?? 0)
        return contentHeight < Constants.maxHeight ? contentHeight : Constants.maxHeight
    }
    
    // MARK: UI Setup
    private func setView() {
        isHidden = true

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tappableView.addGestureRecognizer(tapRecognizer)
        addSubview(tappableView)
        
        addSubview(backView)
        addSubview(arrowImageView)
        
        tableView.delegate = self
        tableView.dataSource = self
        backView.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tappableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        arrowImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(Constants.topPadding)
            make.centerX.equalToSuperview()
            make.size.equalTo(Constants.arrowImageViewSize)
        }
        backView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(arrowImageView.snp.bottom).inset(1)
            make.left.equalToSuperview().offset(Constants.sideInset)
            make.right.equalToSuperview().inset(Constants.sideInset)
            make.height.equalTo(viewHeight())
        }
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDelegate
extension ChatJobSelectorView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ChatJobSelectorCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = viewModel?.itemForIndex(index: indexPath.row) else { return }
        didSelectCellAction?(model)
    }
}

// MARK: - UITableViewDataSource
extension ChatJobSelectorView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChatJobSelectorCell = tableView.dequeueReusableCell(for: indexPath)
        if let model = viewModel?.itemForIndex(index: indexPath.row) {
            cell.configure(model: model)
        }
        return cell
    }
}
