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

    func areaAverage() -> UIColor {
        var bitmap = [UInt8](repeating: 0, count: 4)
        
        // Get average color.
        let context = CIContext()
        let inputImage: CIImage = ciImage ?? CoreImage.CIImage(cgImage: cgImage!)
        let extent = inputImage.extent
        let inputExtent = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)
        let filter = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: inputExtent])!
        let outputImage = filter.outputImage!
        let outputExtent = outputImage.extent
        assert(outputExtent.size.width == 1 && outputExtent.size.height == 1)
        
        // Render to bitmap.
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        
        
        // Compute result.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
}
