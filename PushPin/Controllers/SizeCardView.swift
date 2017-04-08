////
////  SizeCardView.swift
////  PushPin
////
////  Created by Dongjie Zhang on 4/2/17.
////  Copyright © 2017 Zachary. All rights reserved.
////
//
//import UIKit
//
//
//
//class SizeCardView: TGLParallaxCarouselItem {
//
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//    fileprivate var image: UIImage?
//    
//    fileprivate var totalLable: UILabel!
//    fileprivate var workSize: WorkSize!
//    
//    @IBInspectable
//    var number: Int = 0 {
//        didSet{
//            print(number)
//        }
//    }
//    
//    // MARK: - init
//    convenience init(frame: CGRect, number: Int) {
//        self.init(frame: frame)
//        let workType = WorkSizeType(rawValue: number) ?? WorkSizeType.medium
//        workSize = WorkSize(type: workType, isPortrait: <#Bool#>)
//        totalLable.text = String(workSize.total)
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//    
//    func setup(){
//        backgroundColor = UIColor.white
//        layer.masksToBounds = false
//        layer.cornerRadius = 10
//        layer.shadowRadius = 30
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.65
//        buildLabel()
//    }
//    
//    func buildLabel(){
//        totalLable = UILabel(frame: .zero)
//        totalLable.textAlignment = .center
//        totalLable.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(totalLable)
//        
//        totalLable.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        totalLable.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        totalLable.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        totalLable.heightAnchor.constraint(equalToConstant: 40).isActive = true
//    }
//
//}
