//
//  SizeDitherImage.swift
//  PushPin
//
//  Created by Dongjie Zhang on 4/3/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import Foundation
import UIKit

protocol SizeDitherImageDelegate {
    func finishDither()
}

class SizeDitherImage: NSObject {
    
    var imageArray: Array<DitherImage> = []
    
    var ditherJobCounter = 0
    var delegate: SizeDitherImageDelegate?
    
    init(image: UIImage) {
        super.init()
        let sizes = [
            WorkSize(type: .xSmall, isPortrait: true),
            WorkSize(type: .small, isPortrait: true),
            WorkSize(type: .medium, isPortrait: true),
            WorkSize(type: .large, isPortrait: true),
            WorkSize(type: .xLarge, isPortrait: true)
        ]
        ditherJobCounter = sizes.count
        for size in sizes {
            guard let newImage = image.resize(newWidth: size.isPortrait ? size.width : size.height) else {
                ditherJobCounter = ditherJobCounter - 1
                return
            }
            let ditherImage = DitherImage(image: newImage, size: size, mapping: nil)
            ditherImage.delegate = self
            ditherImage.doDither()
            imageArray.append(ditherImage)
        }
    }
}

extension SizeDitherImage: DitherImageDelegate {
    func finishDither() {
        ditherJobCounter = ditherJobCounter - 1
        if ditherJobCounter == 0 {
            delegate?.finishDither()
        }
    }
}

protocol DitherImageDelegate {
    func finishDither()
}

class DitherImage: NSObject {
    var image: UIImage!
    var ditherImage: UIImage?
    var counter: [PixelColor: Int]?
    var size: WorkSize!
    var colorMapping: [PixelColor: PixelColor]?
    
    var delegate: DitherImageDelegate?
    
    init(image: UIImage, size: WorkSize, mapping: [PixelColor: PixelColor]?) {
        super.init()
        self.image = image
        self.size = size
        self.counter = [:]
        self.colorMapping = mapping
    }
    
    func doDither(){
        DispatchQueue.global().async {
            self.ditherImage = Dither.dither(image: self.image,
                                        paletteMapping: self.colorMapping,
                                        counter: &self.counter!,
                                        type: self.size)
            self.delegate?.finishDither()
        }
    }
}
