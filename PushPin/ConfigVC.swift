////
////  ConfigVC.swift
////  PushPin
////
////  Created by Dongjie Zhang on 3/21/17.
////  Copyright © 2017 Zachary. All rights reserved.
////
//
//import UIKit
//
//class ConfigVC: UIViewController {
//    
//    var originImage: UIImage!
//    
//    var editImage: UIImage!
//    
//    var outputImage: UIImage!
//
//    @IBOutlet weak var outputImageView: UIImageView!
//    @IBOutlet weak var originImageView: UIImageView!
//    @IBOutlet weak var generateImageView: UIImageView!
//    @IBOutlet weak var colorBoxStack: UIStackView!
//    
//    @IBOutlet weak var segmentControl: UISegmentedControl!
//    @IBOutlet weak var contrastSlider: UISlider!
//    @IBOutlet weak var saturationSlider: UISlider!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        colorBoxStack.translatesAutoresizingMaskIntoConstraints = false
//        editImage = originImage
//        outputImage = originImage
//        makeOutputImage()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    @IBAction func saturationSlider(_ sender: UISlider) {
//        makeOutputImage()
//    }
//    
//    @IBAction func contrastSlider(_ sender: UISlider) {
//        makeOutputImage()
//    }
//    
//   
//    
//    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
//        makeOutputImage()
//    }
//    
//    
//    func resizeImage(){
//        var width = 50
//        switch segmentControl.selectedSegmentIndex {
//        case 0:
//            width = 50;
//        case 1:
//            width = 75;
//        case 2:
//            width = 100;
//        default:
//            width = 50;
//        }
//        editImage = PPImage.resize(image: originImage, newWidth: width)
//    }
//    
//    func stackViewRemoveAll(){
//        for subview in colorBoxStack.arrangedSubviews {
//            colorBoxStack.removeArrangedSubview(subview)
//            subview.removeFromSuperview()
//        }
//    }
//    
//    func handleSlider(){
//        let ciImage = CIImage(cgImage: editImage.cgImage!)
//        
//        let filter = CIFilter(name: "CIColorControls")
//        filter?.setValue(ciImage, forKey: kCIInputImageKey)
//        filter?.setValue(contrastSlider.value * 2, forKey: kCIInputContrastKey)
//        filter?.setValue(saturationSlider.value * 2, forKey: kCIInputSaturationKey)
//        let result = filter?.value(forKey: kCIOutputImageKey) as! CIImage
//        let cgimage = CIContext.init(options: nil).createCGImage(result, from: result.extent)
//        editImage = UIImage(cgImage: cgimage!)
//    }
//    
//    func makeOutputImage(){
//        DispatchQueue.global(qos: .default).async {
//            self.resizeImage()
//            self.handleSlider()
//            
//            guard let colors = ColorThief.getPalette(from: self.editImage, colorCount: 9, quality: 1, ignoreWhite: false) else {
//                return
//            }
//            
//            DispatchQueue.main.async { [weak self] in
//                self?.displayColors(colors: colors)
//                self?.originImageView.image =  self?.originImage
//                self?.generateImageView.image = self?.editImage
//            }
//        }
//    }
//    
//    func displayColors(colors: Array<MMCQ.Color>){
//        let boxHeight = colorBoxStack.frame.size.height
//        let boxWidth = colorBoxStack.frame.size.width / CGFloat(colors.count)
//        stackViewRemoveAll()
//        var colorArr: Array<PPColor> = []
//        for color in colors {
//            let box = UIView()
//            box.widthAnchor.constraint(equalToConstant: boxWidth).isActive = true
//            box.heightAnchor.constraint(equalToConstant: boxHeight).isActive = true
//            box.backgroundColor = color.makeUIColor()
//            colorBoxStack.addArrangedSubview(box)
//            colorArr.append(PPColor(color: color.makeUIColor()))
//        }
//        
//        if let newImage = PPImage.make(image: editImage, width: 1200, size: 16, colors: colorArr) {
//            outputImageView.contentMode = UIViewContentMode.scaleAspectFill
//            outputImageView.image = UIImage(cgImage: newImage)
//        }else {
//            print("err")
//        }
//    }
//
//}
