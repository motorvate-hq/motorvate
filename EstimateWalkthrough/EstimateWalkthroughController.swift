//
//  EstimateWalkthroughController.swift
//  Motorvate
//
//  Created by Nikita Benin on 21.03.2022.
//  Copyright © 2022 motorvate. All rights reserved.
//

import UIKit

class EstimateWalkthroughController: UIViewController {
    
    // MARK: - UI Elements
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIScreen.main.bounds.size
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(EstimateWalkthroughStepOne.self)
        collectionView.register(EstimateWalkthroughStepTwo.self)
        collectionView.register(EstimateWalkthroughStepThree.self)
        collectionView.register(EstimateWalkthroughStepFour.self)
        collectionView.register(EstimateWalkthroughStepFive.self)
                
        return collectionView
    }()
    
    // MARK: - Lifecycle
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.alpha = 1
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setupConstraints()
    }
    
    private func handleNextAction() {
        if let indexPath = collectionView.indexPathsForVisibleItems.first {
            if indexPath.item == EstimateWalkthroughCellType.allCases.count - 1 {
                dismiss(animated: false)
            } else {
                let nextIndexPath = IndexPath(item: indexPath.item + 1, section: 0)
                collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    private func handleGotItAction() {
        dismiss(animated: false)
    }
    
    // MARK: - UI Setup
    private func setViews() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDelegate
extension EstimateWalkthroughController: UICollectionViewDelegate { }

// MARK: - UICollectionViewDataSource
extension EstimateWalkthroughController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return EstimateWalkthroughCellType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellType = EstimateWalkthroughCellType(rawValue: indexPath.row) else { return UICollectionViewCell() }
        switch cellType {
        case .stepOne:
            let cell: EstimateWalkthroughStepOne = collectionView.dequeueReusableCell(for: indexPath)
            cell.setCell(type: cellType, handleNextAction: handleNextAction, handleGotItAction: handleGotItAction)
            return cell
        case .stepTwo:
            let cell: EstimateWalkthroughStepTwo = collectionView.dequeueReusableCell(for: indexPath)
            cell.setCell(type: cellType, handleNextAction: handleNextAction, handleGotItAction: handleGotItAction)
            return cell
        case .stepThree:
            let cell: EstimateWalkthroughStepThree = collectionView.dequeueReusableCell(for: indexPath)
            cell.setCell(type: cellType, handleNextAction: handleNextAction, handleGotItAction: handleGotItAction)
            return cell
        case .stepFour:
            let cell: EstimateWalkthroughStepFour = collectionView.dequeueReusableCell(for: indexPath)
            cell.setCell(type: cellType, handleNextAction: handleNextAction, handleGotItAction: handleGotItAction)
            return cell
        case .stepFive:
            let cell: EstimateWalkthroughStepFive = collectionView.dequeueReusableCell(for: indexPath)
            cell.setCell(type: cellType, handleAllSetAction: handleGotItAction)
            return cell
        }
    }
}
