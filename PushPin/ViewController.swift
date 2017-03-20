//
//  ViewController.swift
//  PushPin
//
//  Created by Zachary on 3/18/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //construct color array for hex, rgb or UIColor
        var pushpinColorArr: Array<PPColor> =  [
            PPColor(hex: "#FF007F"),
            PPColor(hex: "#FF0000"),
            PPColor(hex: "#FF7F00"),
            PPColor(hex: "#FFFF00"),
            PPColor(hex: "#7FFF00"),
            PPColor(hex: "#00FF00"),
            PPColor(hex: "#00FF7F"),
            PPColor(hex: "#00FFFF"),
            PPColor(hex: "#007FFF"),
            PPColor(hex: "#0000FF"),
            PPColor(hex: "#7F00FF"),
            PPColor(hex: "#FF00FF")
        ]
        
        pushpinColorArr.append(PPColor(color: UIColor.red))
        pushpinColorArr.append(PPColor(color: UIColor.blue))
        pushpinColorArr.append(PPColor(color: UIColor.green))
        pushpinColorArr.append(PPColor(color: UIColor.yellow))
        pushpinColorArr.append(PPColor(color: UIColor.black))
        pushpinColorArr.append(PPColor(color: UIColor.brown))
        pushpinColorArr.append(PPColor(color: UIColor.purple))
        pushpinColorArr.append(PPColor(color: UIColor.magenta))
        pushpinColorArr.append(PPColor(color: UIColor.white))
        
        
        
        let image = UIImage(named: "wife.jpg")!
        
        let imageView = UIImageView(frame: view.frame)
        if let newImage = makeImage(oldImage: image, sectionSize: 12, colors: pushpinColorArr) {
            
            imageView.image = UIImage(cgImage: newImage)
            imageView.contentMode = UIViewContentMode.scaleAspectFit
        }
        view.addSubview(imageView)
 
    }
    
    func makeImage(oldImage: UIImage, sectionSize: Int, colors: Array<PPColor>) -> CGImage?{
        let bitsArr = oldImage.pixelData()!
        
        let outBounds = CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height)
        
        if let canvas = CGContext(data: nil,
                                  width: Int(oldImage.size.width),
                                  height: Int(oldImage.size.height),
                                  bitsPerComponent: 8,
                                  bytesPerRow: 0,
                                  space: CGColorSpaceCreateDeviceRGB(),
                                  bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) {
            
            canvas.translateBy(x: 0, y: outBounds.height) // to flip the image vertically
            canvas.scaleBy(x: 1, y: -1) // to flip the image vertically
            
            //render
            dividIntoSection(bitArr: bitsArr, sectionSize: sectionSize, rowLength: oldImage.size.width, canvas: canvas, outBounds: outBounds, colors: colors)
            
            return canvas.makeImage()
        } else {
            return nil
        }
    }
    
    //calculate distance from two colors
    func distanceFromColor(red: CGFloat, green: CGFloat, blue: CGFloat, pushpinColor: PPColor) -> CGFloat{
        //use weighted CIE76 here
        //((r2-r1)*0.30)^2 + ((g2-g1)*0.59)^2 + ((b2-b1)*0.11)^2
        return pow((pushpinColor.red - red)*0.30, 2) + pow((pushpinColor.green - green)*0.59, 2) + pow((pushpinColor.blue - blue)*0.11, 2)
    }
    
    func findNearestColor(red: UInt8, green: UInt8, blue: UInt8, pushpinColors: Array<PPColor>) -> PPColor{
        var distances : Array<CGFloat> = []
        var min : CGFloat = 1
        var nearestColor = PPColor(color: UIColor.white)
        for color in pushpinColors {
            let dis = distanceFromColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, pushpinColor: color)
            if dis < min {
                min = dis
                nearestColor = color
            }
            distances.append(dis)
        }
        
        return nearestColor
    }
    
    func findSectionNearestColor(bitArr: Array<UInt8>, colors: Array<PPColor>) -> UIColor{
        let colorCount = bitArr.count / 4
        
        var dominateColorCount = Array(repeating: 0, count: colors.count)
        
        for index in 0 ... colorCount - 1 {
            
            let currentIndex = index*4
            
            let nearestColor = findNearestColor(red: bitArr[currentIndex],
                             green: bitArr[currentIndex+1],
                             blue: bitArr[currentIndex+2],
                             pushpinColors: colors)
            
            if let index = colors.index(where: {$0 === nearestColor}) {
                dominateColorCount[index] += 1
            }
        }
        
        var dominateColorMax = 0
        var dominateColorIndex = 0
        
        for (index, count) in dominateColorCount.enumerated() {
            if count > dominateColorMax {
                dominateColorIndex = index
                dominateColorMax = count
            }
        }
        return colors[dominateColorIndex].toUIColor()
        
    }
    
    func dividIntoSection(bitArr: Array<UInt8>, sectionSize: Int, rowLength: CGFloat, canvas: CGContext, outBounds: CGRect, colors: Array<PPColor>){
        let rowIndexs = Int(rowLength * 4) //tatol number of bits in one row
        let rowNumber = Int(bitArr.count / rowIndexs) / sectionSize //number of section rows
        let colNumber = Int(rowIndexs / (sectionSize * 4)) //number of section columns
        
        let sectionCount = colNumber * rowNumber //total number of sections
        
        canvas.saveGState()
        canvas.clip(to: outBounds)
        canvas.translateBy(x: outBounds.minX, y: outBounds.minY)

        for sectionIndex in 0 ... sectionCount - 1 {
            var sectionBitArr = [UInt8]()
            let sectionStartY = Int(sectionIndex / colNumber) * sectionSize //get start y axis of this section
            let sectionStartX = sectionIndex % colNumber * sectionSize * 4 // get start x axis of this section
            for y in sectionStartY ..< sectionStartY + sectionSize { //iterate from start y to start y + section size
                let startIndex = y*colNumber*sectionSize*4 + sectionStartX //start index in whole bits array
                let endIndex = startIndex + (sectionSize*4) //end index in whole bits array
                sectionBitArr.append(contentsOf: bitArr[startIndex ..< endIndex])
            }
            
            let halfSize = CGFloat(sectionSize / 2)
            let color = findSectionNearestColor(bitArr: sectionBitArr, colors: colors)
            canvas.setFillColor(color.cgColor)
            canvas.addArc(center: CGPoint(x: sectionStartX/4 + sectionSize/2, y: sectionStartY + sectionSize/2),
                          radius: halfSize,
                          startAngle: 0,
                          endAngle: 2 * CGFloat.pi,
                          clockwise: false)
            canvas.fillPath()
        }
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
