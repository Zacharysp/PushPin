//
//  GenerateVC.swift
//  PushPin
//
//  Created by Dongjie Zhang on 3/21/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit

class GenerateVC: UIViewController {
    
    var editImage: UIImage!

    @IBOutlet weak var generateImageView: UIImageView!
    @IBOutlet weak var colorsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors = editImage.dominantColors()
        
        var colorArr: Array<PPColor> = []
        
        for color in colors {
           colorArr.append(PPColor(color:color))
        }
        
        if let newImage = PPImage.make(image: editImage, width: 400, size: 8, colors: colorArr) {
            generateImageView.contentMode = UIViewContentMode.scaleAspectFit
            generateImageView.image = UIImage(cgImage: newImage)
        }else {
            print("err")
        }
        /*
        if let newImage = PPImage.makeImage(oldImage: editImage, sectionSize: 2, colors: pushpinColorArr){
            generateImageView.contentMode = UIViewContentMode.scaleAspectFit
            generateImageView.image = UIImage(cgImage: newImage)
        }else {
            print("err")
        }*/
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
