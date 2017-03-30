//
//  PPImage.swift
//  PushPin
//
//  Created by Dongjie Zhang on 3/21/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import Foundation
import UIKit

struct PPImage {
    
    public static func make(image: UIImage, width: Int, size: Int, colors: Array<PPColor>) -> CGImage?{
        let bitsArr = image.pixelDataArray()!
        
        let outBounds = findRatioRect(size: image.size, width: width)
        
        if let canvas = CGContext(data: nil,
                                  width: Int(outBounds.size.width),
                                  height: Int(outBounds.size.height),
                                  bitsPerComponent: 8,
                                  bytesPerRow: 0,
                                  space: CGColorSpaceCreateDeviceRGB(),
                                  bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) {
            
            canvas.translateBy(x: 0, y: outBounds.height) // to flip the image vertically
            canvas.scaleBy(x: 1, y: -1) // to flip the image vertically
            
            //render
            render(bitArr: bitsArr, rowLength: image.size.width, canvas: canvas, outBounds: outBounds, size: size, colors: colors)
            
            return canvas.makeImage()
        } else {
            return nil
        }
    }
    
    
    //resize the image
    public static func resize(image: UIImage, newWidth: Int) -> UIImage {
        
        let newRect = findRatioRect(size: image.size, width: newWidth)
        
        //draw in rect for resizing
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newRect.size.width, height: newRect.size.height), false, 1.0)
        image.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    public static func filterImage(filterName: String, image: UIImage) -> UIImage{
        let ciImage = CIImage(cgImage: image.cgImage!)
        
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        let result = filter?.value(forKey: kCIOutputImageKey) as! CIImage
        let imageOrientation = image.imageOrientation
        let cgImage = CIContext(options: nil).createCGImage(result, from: result.extent)
        return UIImage(cgImage: cgImage!, scale: 1, orientation: imageOrientation)
    }

    
    //get new image frame
    fileprivate static func findRatioRect(size: CGSize, width: Int) -> CGRect{
        let ratio = size.height / size.width
        
        let cgWidth = CGFloat(width)
        let cgheight = cgWidth * ratio
        
        return CGRect(x: 0, y: 0, width: cgWidth, height: cgheight)
    }
    
    //calculate distance from two colors
    fileprivate static func distanceFromColor(red: CGFloat, green: CGFloat, blue: CGFloat, pushpinColor: PPColor) -> CGFloat{
        //use weighted CIE76 here
        //((r2-r1)*0.30)^2 + ((g2-g1)*0.59)^2 + ((b2-b1)*0.11)^2
        return pow((pushpinColor.red - red)*0.30, 2) + pow((pushpinColor.green - green)*0.59, 2) + pow((pushpinColor.blue - blue)*0.11, 2)
    }
    
    fileprivate static func findNearestColor(red: UInt8, green: UInt8, blue: UInt8, pushpinColors: Array<PPColor>) -> PPColor{
        var min : CGFloat = 1
        var nearestColor = PPColor(color: UIColor.white)
        for color in pushpinColors {
            let dis = distanceFromColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, pushpinColor: color)
            if dis < min {
                min = dis
                nearestColor = color
            }
        }
        return nearestColor
    }
    
    fileprivate static func render(bitArr: Array<UInt8>, rowLength: CGFloat, canvas: CGContext, outBounds: CGRect, size: Int, colors: Array<PPColor>) {
        let bitCount = bitArr.count / 4
        
        for index in 0 ..< bitCount {
            let currentIndex = index*4
            let nearestColor = findNearestColor(red: bitArr[currentIndex], green: bitArr[currentIndex+1], blue: bitArr[currentIndex+2], pushpinColors: colors)
            canvas.setFillColor(nearestColor.toUIColor().cgColor)
            let pointStartY = Int(CGFloat(index) / rowLength) * size//get start y axis of this section
            let pointStartX = index % Int(rowLength) * size // get start x axis of this section
            canvas.addArc(center: CGPoint(x: pointStartX + size/2, y: pointStartY + size/2),
                          radius: CGFloat(size / 2),
                          startAngle: 0,
                          endAngle: 2 * CGFloat.pi,
                          clockwise: false)
            canvas.fillPath()
        }
        
    }
}

public class PPColor {
    var red: CGFloat = 1
    var green: CGFloat = 1
    var blue: CGFloat = 1
    var alpha: CGFloat = 1
    
    public init(color: UIColor) {
        if let colorComponents = color.components {
            red = colorComponents.red
            green = colorComponents.green
            blue = colorComponents.blue
            alpha = colorComponents.alpha
        }
    }
    
    public init(red: Double, green: Double, blue: Double, alpha: Double) {
        self.red = CGFloat(red / 255.0)
        self.green = CGFloat(green / 255.0)
        self.blue = CGFloat(blue / 255.0)
        self.alpha = CGFloat(alpha)
    }
    
    public init (hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        guard cString.characters.count == 6 else {
            return
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        alpha = CGFloat(1.0)
    }
    
    
    public func toUIColor() -> UIColor{
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public func toArray() -> UIColor{
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
