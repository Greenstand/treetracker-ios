//
//  ViewTreesCollectionViewCell.swift
//  TreeTracker
//
//  Created by Remi Varghese on 11/2/20.
//  Copyright © 2020 Greenstand. All rights reserved.
//

import UIKit

class ViewTreesCollectionViewCell: UICollectionViewCell {
    static let customCellIdentifier = "ViewTreesCollectionViewCell"

    @IBOutlet weak var treesImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
