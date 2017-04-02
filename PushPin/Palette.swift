//
//  Palette.swift
//  PushPin
//
//  Created by Dongjie Zhang on 3/31/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import Foundation
import UIKit

struct PixelColor: Equatable, Hashable{
    var red: UInt8
    var green: UInt8
    var blue: UInt8
    var alpha: UInt8
    
    static func toUInt8(value: Double) -> UInt8 {
        return value > 1.0 ? UInt8(255) : value < 0 ? UInt8(0) : UInt8(value * 255.0)
    }
    
    static func == (left: PixelColor, right: PixelColor) -> Bool {
        return left.red == right.red
            && left.green == right.green
            && left.blue == right.blue
            && left.alpha == right.alpha
    }
    
    var hashValue: Int {
        let r = UInt32(red) << 16
        let g = UInt32(green) << 8
        let b = UInt32(blue)
        
        return Int(r + g + b)
    }

    
    init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(color: UIColor) {
        var arr: [CGFloat] = [0,0,0,0]
        color.getRed(&arr[0], green: &arr[1], blue: &arr[2], alpha: &arr[3])
        self.red = UInt8(arr[0] * 255)
        self.green = UInt8(arr[0] * 255)
        self.blue = UInt8(arr[0] * 255)
        self.alpha = UInt8(arr[0] * 255)
    }
    
    func toUIColor() -> UIColor{
        return UIColor(
            red: CGFloat(red/255),
            green: CGFloat(green/255),
            blue: CGFloat(blue/255),
            alpha: CGFloat(alpha/255)
        )

    }
}

struct PaletteRange {
    var red: (min: UInt8, max: UInt8) = (0,0)
    var green: (min: UInt8, max: UInt8) = (0,0)
    var blue: (min: UInt8, max: UInt8) = (0,0)
    
    init(palette: Array<PixelColor>) {
        //if no color provide, it is all black
        guard palette.count > 0 else {
            return
        }
        func initRange(range: inout (min: UInt8, max: UInt8), value: UInt8) {
            range.min = value
            range.max = value
        }
        
        //assign inital value
        initRange(range: &red, value: palette.first!.red)
        initRange(range: &green, value: palette.first!.green)
        initRange(range: &blue, value: palette.first!.blue)
        
        func assign(range: inout (min: UInt8, max: UInt8), value: UInt8){
            if value < 128 {
                range.min = value
            }else {
                range.max = value
            }
        }
        
        //assign rest color value
        for index in 1..<palette.count {
            assign(range: &red, value: palette[index].red)
            assign(range: &green, value: palette[index].green)
            assign(range: &blue, value: palette[index].blue)
        }
    }
}

class PixelPalette {
    
    private var palette: Array<PixelColor> = []
    
    init(palette: Array<PixelColor>) {
        self.palette = palette
    }
    
    init(){}
    
    init(palette: Array<UIColor>) {
        for color in palette {
            self.palette.append(PixelColor(color: color))
        }
    }
    
    func add(color: PixelColor) {
        palette.append(color)
    }
    
    func remove(color: PixelColor) {
        guard let index = palette.index(of: color) else {
            return
        }
        palette.remove(at: index)
    }
    
    func getPalette() -> Array<PixelColor>{
        return palette
    }
}
