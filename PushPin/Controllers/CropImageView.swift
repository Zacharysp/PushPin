//
//  CropImageView.swift
//  PushPin
//
//  Created by Dongjie Zhang on 4/1/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import Foundation
import UIKit

class CropImageView: UIView {
    private var imageView = UIImageView()
    private var cropView = UIView()
    
    var isPortrait: Bool = true
    
    private var tapGesture = UITapGestureRecognizer()
    private var panGesture = UIPanGestureRecognizer()
    private var pinchGesture = UIPinchGestureRecognizer()
    
    
    //overlayView
    private var topOverlayView = UIView()
    private var leftOverlayView = UIView()
    private var rightOverlayView = UIView()
    private var bottomOverlayView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    private func buildImageView(){
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        self.addSubview(imageView)
        buildCropView()
    }
    
    func setup(image: UIImage) {
        buildImageView()
        imageView.image = image
        setConstraints()
    }
    
    func image() -> UIImage? {
        return imageView.image
    }
    
    func setConstraints(){
        //imageView constraints
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        //height / weight ratio
        let ratio: CGFloat = isPortrait ? 1.25 : 0.8
        
        cropView.widthAnchor.constraint(equalToConstant: frame.size.width - 100)
        cropView.heightAnchor.constraint(equalTo: cropView.widthAnchor, multiplier: ratio)
        
        topOverlayView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        topOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        topOverlayView.trailingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        topOverlayView.bottomAnchor.constraint(equalTo: cropView.topAnchor).isActive = true
        
        leftOverlayView.topAnchor.constraint(equalTo: topOverlayView.bottomAnchor).isActive = true
        leftOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        leftOverlayView.trailingAnchor.constraint(equalTo: cropView.leadingAnchor).isActive = true
        leftOverlayView.bottomAnchor.constraint(equalTo: bottomOverlayView.topAnchor).isActive = true
        
        rightOverlayView.topAnchor.constraint(equalTo: topOverlayView.bottomAnchor).isActive = true
        rightOverlayView.leadingAnchor.constraint(equalTo: cropView.trailingAnchor).isActive = true
        rightOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true
        rightOverlayView.bottomAnchor.constraint(equalTo: bottomOverlayView.topAnchor).isActive = true
        
        bottomOverlayView.topAnchor.constraint(equalTo: cropView.bottomAnchor).isActive = true
        bottomOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        bottomOverlayView.trailingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        bottomOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
    }
    
    private func buildCropView() {
        
        cropView.layer.borderWidth = 2
        cropView.layer.borderColor = UIColor.white.cgColor
        cropView.alpha = 0.2
        cropView.backgroundColor = UIColor.clear
        cropView.center = center
        cropView.isUserInteractionEnabled = true
        
//        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        tapGesture.numberOfTapsRequired = 2
//        tapGesture.delegate = self
//        cropView.addGestureRecognizer(tapGesture)
//        
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        panGesture.delegate = self
//        cropView.addGestureRecognizer(panGesture)
//        
//        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
//        pinchGesture.delegate = self
//        cropView.addGestureRecognizer(pinchGesture)
        
        //init overlay view
        topOverlayView.backgroundColor = UIColor.black
        topOverlayView.alpha = 0.2
        topOverlayView.translatesAutoresizingMaskIntoConstraints = false
        
        leftOverlayView.backgroundColor = UIColor.black
        leftOverlayView.alpha = 0.2
        leftOverlayView.translatesAutoresizingMaskIntoConstraints = false
        
        rightOverlayView.backgroundColor = UIColor.black
        rightOverlayView.alpha = 0.2
        rightOverlayView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomOverlayView.backgroundColor = UIColor.black
        bottomOverlayView.alpha = 0.2
        bottomOverlayView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.addSubview(cropView)
        imageView.addSubview(topOverlayView)
        imageView.addSubview(leftOverlayView)
        imageView.addSubview(rightOverlayView)
        imageView.addSubview(bottomOverlayView)
        
        imageView.bringSubview(toFront: cropView)
    }
}
