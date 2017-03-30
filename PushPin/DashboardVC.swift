//
//  DashboardVC.swift
//  PushPin
//
//  Created by Dongjie Zhang on 3/29/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit
import ImageIO

class DashboardVC: UIViewController {

    @IBOutlet weak var newItemBtn: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let image = PPImage.resize(image: UIImage(named: "test.jpg")!, newWidth: 150)
//
//        imageView.image = image
        
        if let ditherImage = Dither.dither(image: image) {
            imageView.image = ditherImage
        }
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
