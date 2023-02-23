//
//  UICollectionView+Extension.swift
//  RickMorty-Assignment
//
//  Created by cleanmac on 23/02/23.
//

import UIKit

extension UICollectionView {
    func deselectItemsInSection(section: Int, animated: Bool = false) {
        if let selectedIndexPathsInSection = indexPathsForSelectedItems?.filter({ $0.section == section }) {
            for indexPath in selectedIndexPathsInSection {
                deselectItem(at: indexPath, animated: animated)
            }
        }
    }
}
