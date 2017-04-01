//
//  Dither.swift
//  PushPin
//
//  Created by Dongjie Zhang on 3/30/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import Foundation
import UIKit

struct Matrix
{
    let row: Int
    let column: Int
    let ratio: Int
}

struct Dither {
    
    static func pixelArrayFrom(image: UIImage) -> [UInt8]? {
        let dataSize = image.size.width * image.size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: &pixelData,
                                width: Int(image.size.width),
                                height: Int(image.size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: Int(image.size.width) * 4,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        
        guard let cgImage = image.cgImage else {
            return nil
        }
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        return pixelData
    }
    
    static func dither(image: UIImage, paletteMapping: [PixelColor: PixelColor], counter: inout [PixelColor: Int]) -> UIImage? {
        //using atkinson dithering
        let divisor = 8
        let matrix = [
            Matrix(row: 0, column: 1, ratio: 1),
            Matrix(row: 0, column: 2, ratio: 1),
            Matrix(row: 1, column: -1, ratio: 1),
            Matrix(row: 1, column: 0, ratio: 1),
            Matrix(row: 1, column: 1, ratio: 1),
            Matrix(row: 2, column: 0, ratio: 1)]
        
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        
        //Create a 2D pixel Array for dither pixel processing
        guard var pixelArray = pixelArrayFrom(image: image) else {
            return nil
        }
        
        //Calculate error to add to matrix values & curb UInt8 overflow
        func addError(component: UInt8, pixelError: UInt8, ratio: Int) -> UInt8 {
            let _component = Int(component)
            let _pixelError = Int(pixelError)
            let apportionedError = _pixelError * ratio / divisor
            return UInt8(_component + apportionedError > 255 ? 255 : _component + apportionedError)
        }
        
        //Subtract Dither from current component & curb UInt8 underflow
        func subtractDither(component: UInt8, dither: UInt8) -> UInt8 {
            return Int(component) - Int(dither) < 0 ? 0 : component - dither
        }
        
        //Distribute error to matrix color components
        func distributeError(pixel: PixelColor, pixelError: PixelColor, ratio: Int) -> PixelColor {
            return PixelColor(
                red: addError(component: pixel.red, pixelError: pixelError.red, ratio: ratio),
                green: addError(component: pixel.green, pixelError: pixelError.green, ratio: ratio),
                blue: addError(component: pixel.blue, pixelError: pixelError.blue, ratio: ratio),
                alpha: pixel.alpha)
        }
        
        // Calculate the dither for the current pixel
        func calculateDither(pixel: PixelColor) -> PixelColor {
            let color = PixelColor(red: pixel.red < 128 ? 0 : 255,
                         green: pixel.green < 128 ? 0 : 255,
                         blue: pixel.blue < 128 ? 0 : 255,
                         alpha: pixel.alpha)
            if paletteMapping[color] != nil {
                return paletteMapping[color]!
            }else {
                return color
            }
        }
        
        // Calculate Error by substracting dither from current color components
        func calculateError(current: PixelColor, dither: PixelColor) -> PixelColor {
            return PixelColor(red: subtractDither(component: current.red, dither: dither.red),
                         green: subtractDither(component: current.green, dither: dither.green),
                         blue: subtractDither(component: current.blue, dither: dither.blue),
                         alpha: current.alpha)
        }

        
        // calculate memory offset
        func offset(row: Int, column: Int) -> Int {
            return row * width * 4 + column * 4
        }
        
        func getCurrentPixel(index: Int) -> PixelColor {
            return PixelColor(red: pixelArray[index],
                         green: pixelArray[index + 1],
                         blue: pixelArray[index + 2],
                         alpha: pixelArray[index + 3])
        }
        
        func setPixelColor(index: Int, array: inout [UInt8], pixel: PixelColor){
            array[index] = pixel.red
            array[index + 1] = pixel.green
            array[index + 2] = pixel.blue
            array[index + 3] = pixel.alpha
        }
        
        // Loop through each pixel and apply dither
        for y in 0..<height
        {
            for x in 0..<width
            {
                let currentIndex = offset(row: y, column: x)
                
                let currentColor = getCurrentPixel(index: currentIndex)
                
                let ditherColor = calculateDither(pixel: currentColor)
                let errorColor = calculateError(current: currentColor, dither: ditherColor)

                if counter[ditherColor] != nil {
                    counter[ditherColor] = counter[ditherColor]! + 1
                }else {
                    counter[ditherColor] = 1
                }
                
                setPixelColor(index: currentIndex, array: &pixelArray, pixel: ditherColor)
//                /* draw on canvas */
//                let newColor = UIColor(
//                    red: CGFloat(ditherColor.red / 255),
//                    green: CGFloat(ditherColor.green / 255),
//                    blue: CGFloat(ditherColor.blue / 255),
//                    alpha: CGFloat(ditherColor.alpha / 255)
//                )
//                canvas.setFillColor(newColor.cgColor)
//                let pointStartY = currentIndex / width//get start y axis of this section
//                let pointStartX = currentIndex % width // get start x axis of this section
//                canvas.addArc(center: CGPoint(x: CGFloat(x) + 0.5, y: CGFloat(y) + 0.5),
//                              radius: CGFloat(0.5),
//                              startAngle: 0,
//                              endAngle: 2 * CGFloat.pi,
//                              clockwise: false)
//                canvas.fillPath()
                
                /* Apply Error To Matrix Pixels */
                for neighbor in matrix {
                    let row = y + neighbor.row
                    let column = x + neighbor.column
                    
                    // Bounds check
                    guard row >= 0
                        && row < height
                        && column >= 0
                        && column < width else {
                        continue
                    }
                    
                    let neighborIndex = offset(row: row, column: column)
                    let neighborColor = getCurrentPixel(index: neighborIndex)
                    let neighborNewColor = distributeError(pixel: neighborColor, pixelError: errorColor, ratio: neighbor.ratio)
                    setPixelColor(index: neighborIndex, array: &pixelArray, pixel: neighborNewColor)
                }
            }
        }
        /* Recomposite image from pixelArray */
        
        print("done dither:", pixelArray.count)
        //build canvas ready for drawing the new image
        guard let canvas = CGContext(data: &pixelArray,
                                     width: width,
                                     height: height,
                                     bitsPerComponent: 8,
                                     bytesPerRow: MemoryLayout<UInt8>.size * width * 4,
                                     space: CGColorSpaceCreateDeviceRGB(),
                                     bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
            else {
                return nil
        }
        
//        canvas.translateBy(x: 0, y: image.size.height) // to flip the image vertically
//        canvas.scaleBy(x: 1, y: -1) // to flip the image vertically

        
        guard let cgImage = canvas.makeImage() else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
}
