//
//  WorkItem.swift
//  PushPin
//
//  Created by Dongjie Zhang on 4/1/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import Foundation
import UIKit

class WorkItem: NSObject {
    var image: UIImage
    var counter: [PixelColor: Int]
    var palette: PixelPalette
    var isNew: Bool
    
    override init() {
        image = UIImage(named: "test.jpg")!
        counter = [:]
        palette = PixelPalette()
        isNew = true
    }
}
