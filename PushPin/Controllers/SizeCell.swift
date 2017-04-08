//
//  SizeCell.swift
//  PushPin
//
//  Created by Dongjie Zhang on 4/2/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit

enum WorkSizeType: Int {
    case xSmall = 0
    case small = 1
    case medium = 2
    case large = 3
    case xLarge = 4
}

struct WorkSize {
    var width: Int = 0
    var height: Int = 0
    var total: Int = 0
    var isPortrait = false
    
    init(type: WorkSizeType, isPortrait: Bool) {
        func setup(w: Int, h: Int){
            width = isPortrait ? w : h
            height = isPortrait ? h : w
            total = width * height
        }
        switch type {
        case .xSmall:
            setup(w: 50, h: 67)
            break
        case .small:
            setup(w: 75, h: 100)
            break
        case .medium:
            setup(w: 100, h: 134)
            break
        case .large:
            setup(w: 125, h: 167)
            break
        case .xLarge:
            setup(w: 150, h: 200)
            break
        }
        self.isPortrait = isPortrait
    }
}

class SizeCell: UICollectionViewCell {
    
    var totalLabel: UILabel!
    var imageView: UIImageView!
    
    var workSize: WorkSize? {
        didSet {
            totalLabel.text = "Total: \(workSize!.total)"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildLabel()
        buildImageView()
    }
    
    func buildLabel(){
        totalLabel = UILabel(frame: .zero)
        totalLabel.textAlignment = .center
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(totalLabel)
        
        totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        totalLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        totalLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func buildImageView(){
        imageView = UIImageView(frame: .zero)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: totalLabel.topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
