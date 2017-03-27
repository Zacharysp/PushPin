//
//  PixelateVC.swift
//  PushPin
//
//  Created by Zachary on 3/27/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit

class PixelateVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var pixelScrollView: UIScrollView!
    
    @IBOutlet weak var pixelCollectionView: UICollectionView!
    
    var pixelImage: UIImage!
    
    var editImage: UIImage?
    
    var colorArray: Array<PPColor> = []
    
    var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editImage = PPImage.resize(image: pixelImage, newWidth: 75)
        generatePixelImage(image: editImage!)
        // Do any additional setup after loading the view.
    }
    
    func buildScrollView(size: CGSize){
        pixelScrollView.backgroundColor = UIColor(red: 90, green: 90, blue: 90, alpha: 0.90)
        pixelScrollView.alwaysBounceVertical = false
        pixelScrollView.alwaysBounceHorizontal = false
        let zoomScale = getZoomScale(size: size)
        pixelScrollView.minimumZoomScale = zoomScale
        pixelScrollView.maximumZoomScale = 1.0
        pixelScrollView.zoomScale = zoomScale
        pixelScrollView.contentSize = size
    }
    
    func generatePixelImage(image: UIImage){
        let generteImage = increaseSaturation(image: image.cgImage!)
        guard let colors = ColorThief.getPalette(from: generteImage, colorCount: 9, quality: 1, ignoreWhite: false) else {
            //cannot get colors
            return
        }
        for color in colors {
            colorArray.append(PPColor(color: color.makeUIColor()))
        }
        pixelCollectionView.reloadData()
        
        if let newImage = PPImage.make(image: generteImage, width: 1200, size: 16, colors: colorArray) {
            imageView = UIImageView(image: UIImage(cgImage: newImage))
            buildScrollView(size: imageView!.frame.size)
            pixelScrollView.addSubview(imageView!)
        }else {
            print("err")
        }
    }
  
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func getZoomScale(size: CGSize) -> CGFloat{
        if size.width > size.height {
            return pixelScrollView.frame.width / size.width
        }else {
            return pixelScrollView.frame.height / size.height
        }
    }
    
    func increaseSaturation(image: CGImage) -> UIImage{
        let ciImage = CIImage(cgImage: image)
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(1.1, forKey: kCIInputContrastKey)
        filter?.setValue(1.1, forKey: kCIInputSaturationKey)
        let result = filter?.value(forKey: kCIOutputImageKey) as! CIImage
        let cgimage = CIContext.init(options: nil).createCGImage(result, from: result.extent)
        return UIImage(cgImage: cgimage!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PixelateVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pixelCell", for: indexPath) 
        cell.contentView.backgroundColor = colorArray[indexPath.row].toUIColor()
        return cell
    }
}

extension PixelateVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 4
        return CGSize(width: width, height: width)
    }
}
