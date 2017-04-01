//
//  DashboardCell.swift
//  PushPin
//
//  Created by Dongjie Zhang on 4/1/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit

protocol DashboardCellDelegate {
    func didStartNewItem()
}

class DashboardCell: UICollectionViewCell {
    
    var newBtn: UIButton!
    var delegate: DashboardCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildButton()
        setConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildButton(){
        newBtn = UIButton(type: .custom)
        newBtn.titleLabel?.text = "New"
        newBtn.layer.cornerRadius = 5
        newBtn.backgroundColor = UIColor.red
        newBtn.translatesAutoresizingMaskIntoConstraints = false
        newBtn.addTarget(self, action: #selector(DashboardCell.didPressedStartNewBtn), for: .touchUpInside)
        self.addSubview(newBtn)
    }
    
    private func setConstraints(){
        newBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        newBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        newBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        newBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc private func didPressedStartNewBtn(){
        delegate?.didStartNewItem()
    }
}
