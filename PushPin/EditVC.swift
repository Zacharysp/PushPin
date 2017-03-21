//
//  EditVC.swift
//  PushPin
//
//  Created by Dongjie Zhang on 3/21/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit

class EditVC: UIViewController {

    @IBOutlet weak var editImageView: UIImageView!
    
    var editImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = UIImage(named: "test")!
        editImage = PPImage.resize(image: image, newWidth: 50)
        
        editImageView.contentMode = UIViewContentMode.scaleAspectFit
        editImageView.image = image

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let generatePage = segue.destination as? GenerateVC {
            generatePage.editImage = editImage
        }
    }
}
