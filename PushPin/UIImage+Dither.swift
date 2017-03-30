////
////  UIImage+Dither.swift
////  PushPin
////
////  Created by Dongjie Zhang on 3/30/17.
////  Copyright © 2017 Zachary. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//
//extension UIImage
//{
//  
//    
//    // MARK: - dither function -
//    
//    ///  Dither NSImage to improve clarity with low color or low resolution
//    ///  - parameter method: optional DitherMethod type
//    ///  - returns: new optional NSImage
//    public func dither() -> UIImage?
//    {
//        // Retrieve method divisor & matrix
//        //using atkinson dithering
//        let divisor = 8
//        let matrix = [
//            Matrix(row: 0, column: 1, ratio: 1),
//            Matrix(row: 0, column: 2, ratio: 1),
//            Matrix(row: 1, column: -1, ratio: 1),
//            Matrix(row: 1, column: 0, ratio: 1),
//            Matrix(row: 1, column: 1, ratio: 1),
//            Matrix(row: 2, column: 0, ratio: 1)]
//        
//        // Dimensions
//        let width = Int(self.size.width)
//        let height = Int(self.size.height)
//        
//        /* Calculate error to add to matrix values & curb UInt8 overflow */
//        func addError(component: UInt8, pixelError: UInt8, ratio: Int) -> UInt8
//        {
//            let _component = Int(component)
//            let _pixelError = Int(pixelError)
//            let apportionedError = _pixelError * ratio / divisor
//            return UInt8(_component + apportionedError > 255 ? 255 : _component + apportionedError)
//        }
//        
//        /* Subtract Dither from current component & curb UInt8 underflow */
//        func subtractDither(component: UInt8, dither: UInt8) -> UInt8
//        {
//            return Int(component) - Int(dither) < 0 ? 0 : component - dither
//        }
//        
//        /* Distribute error to matrix color components */
//        func distributeError(pixel: Pixel, pixelError: Pixel, ratio: Int) -> Pixel
//        {
//            return Pixel(
//                red: addError(component: pixel.red, pixelError: pixelError.red, ratio: ratio),
//                green: addError(component: pixel.green, pixelError: pixelError.green, ratio: ratio),
//                blue: addError(component: pixel.blue, pixelError: pixelError.blue, ratio: ratio),
//                alpha: pixel.alpha)
//        }
//        
//        /* Calculate the dither for the current pixel */
//        func calculateDither(pixel: Pixel) -> Pixel
//        {
//            return Pixel(red: pixel.red < 128 ? 0 : 255,
//                         green: pixel.green < 128 ? 0 : 255,
//                         blue: pixel.blue < 128 ? 0 : 255,
//                         alpha: pixel.alpha)
//        }
//        
//        /* Calculate Error by substracting dither from current color components */
//        func calculateError(current: Pixel, dither: Pixel) -> Pixel
//        {
//            return Pixel(red: subtractDither(component: current.red, dither: dither.red),
//                         green: subtractDither(component: current.green, dither: dither.green),
//                         blue: subtractDither(component: current.blue, dither: dither.blue),
//                         alpha: current.alpha)
//        }
//        
//        
//        
//        /* Create a 2D pixel Array for dither pixel processing */
//        guard var pixelArray = self.pixelDataArray() else
//        {
//            return nil
//        }
//        
//        //build canvas ready for drawing the new image
//        guard let canvas = CGContext(data: nil,
//                                  width: width,
//                                  height: height,
//                                  bitsPerComponent: 8,
//                                  bytesPerRow: 0,
//                                  space: CGColorSpaceCreateDeviceRGB(),
//                                  bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else { return nil }
//        
//        canvas.translateBy(x: 0, y: CGFloat(height)) // to flip the image vertically
//        canvas.scaleBy(x: 1, y: -1) // to flip the image vertically
//    
//        /* Loop through each pixel and apply dither */
//        for y in 0..<height
//        {
//            for x in 0..<width
//            {
//                
//                let pixelWidth = width / 4
//                
//                let currentColor = getPixelColor(row: y, column: x, array: pixelArray)
//                
//                let ditherColor = calculateDither(pixel: currentColor)
//                let errorColor = calculateError(current: currentColor, dither: ditherColor)
//                
//                /* Dither Current Pixel */
//                setPixelColor(row: y, column: x, array: &pixelArray, pixel: ditherColor)
//                
//                /* draw on canvas */
//                let newColor = UIColor(
//                    red: CGFloat(ditherColor.red / 255),
//                    green: CGFloat(ditherColor.red / 255),
//                    blue: CGFloat(ditherColor.red / 255),
//                    alpha: CGFloat(ditherColor.red / 255)
//                )
//                canvas.setFillColor(newColor.cgColor)
//                canvas.addArc(center: CGPoint(x: pixelWidth + 0.5, y: height + 0.5),
//                              radius: CGFloat(size / 2),
//                              startAngle: 0,
//                              endAngle: 2 * CGFloat.pi,
//                              clockwise: false)
//                
//                CGContextFillRect (context, CGRectMake (CGFloat(i), CGFloat(j), 1, 1));
//                
//                /* Apply Error To Matrix Pixels */
//                for neighbor in matrix
//                {
//                    let row = y + neighbor.row
//                    let column = x + neighbor.column * 4
//                    
//                    // Bounds check
//                    guard row >= 0
//                        && row < height
//                        && column >= 0
//                        && column < width else
//                    {
//                        continue
//                    }
//                    
//                    let neighborColor = getPixelColor(row: row, column: column, array: pixelArray)
//                    setPixelColor(row: row, column: column, array: &pixelArray, pixel: distributeError(pixel: neighborColor, pixelError: errorColor, ratio: neighbor.ratio))
//                }
//            }
//        }
//        
//        /* Recomposite image from pixelArray */
//    
//        guard let cgImage = canvas.makeImage() else {
//            return nil
//        }
//        
//        return UIImage(cgImage: cgImage)
//    }
//}
