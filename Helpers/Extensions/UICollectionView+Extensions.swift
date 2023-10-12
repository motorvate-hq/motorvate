//
//  UICollectionView+Extensions.swift
//  Motorvate
//
//  Created by Nikita Benin on 12.04.2021.
//  Copyright © 2021 motorvate. All rights reserved.
//

import UIKit

extension UICollectionView {
    private func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfItems(inSection: indexPath.section)
    }

    func scrollToTop(_ animated: Bool = false) {
        let indexPath = IndexPath(row: 0, section: 0)
        if hasRowAtIndexPath(indexPath: indexPath) {
            scrollToItem(at: indexPath, at: .top, animated: animated)
        }
    }
}
