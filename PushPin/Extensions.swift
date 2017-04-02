//
//  Extensions.swift
//  PushPin
//
//  Created by Zachary on 3/19/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        return getRed(&r, green: &g, blue: &b, alpha: &a) ? (r,g,b,a) : nil
    }
}

extension UIImage {
    func pixelDataArray() -> [UInt8]? {
        let size = self.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return pixelData
    }
    
    //resize the image
    func resize(newWidth: Int) -> UIImage? {
        
        let newRect = findRatioRect(size: size, width: newWidth)
        
        //draw in rect for resizing
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newRect.size.width, height: newRect.size.height), false, 1.0)
        draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func filterImage(filterName: String) -> UIImage{
        guard self.cgImage != nil else {
            return self
        }
        let ciImage = CIImage(cgImage: self.cgImage!)
        
        //set filter with name
        let filter = CIFilter(name: filterName)
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        let result = filter?.value(forKey: kCIOutputImageKey) as! CIImage
        let imageOrientation = self.imageOrientation
        let cgImage = CIContext(options: nil).createCGImage(result, from: result.extent)
        return UIImage(cgImage: cgImage!, scale: 1, orientation: imageOrientation)
    }
    
    //get new image frame
    private func findRatioRect(size: CGSize, width: Int) -> CGRect{
        let ratio = size.height / size.width
        
        let cgWidth = CGFloat(width)
        let cgheight = cgWidth * ratio
        
        return CGRect(x: 0, y: 0, width: cgWidth, height: cgheight)
    }
}
