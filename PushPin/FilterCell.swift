//
//  FilterwCell.swift
//  PushPin
//
//  Created by Zachary on 3/26/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var preview: UIImageView!
    
    override var isSelected: Bool {
        willSet {
            nameLabel.font = newValue ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
        }
    }
}
