//
//  ViewController.swift
//  PushPin
//
//  Created by Zachary on 3/18/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var libraryBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        
    
 
    }
    
    @IBAction func libraryBtnPressed(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //resize the image to 200px * 323px
    func resize(image: UIImage) -> UIImage {
        let newRect = CGRect(x: 0, y: 0, width: 200, height: 323)
        
        //draw in rect for resizing
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 200, height: 323), false, 1.0)
        image.draw(in: newRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            guard selectedImage != nil else {
                return
            }
            if let editPage = segue.destination as? EditVC {
                editPage.editImage = selectedImage!
            }
    }
}

extension ViewController: UIImagePickerControllerDelegate{
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            self.selectedImage = self.resize(image: image)
            self.performSegue(withIdentifier: "toEdit", sender: nil)
        })
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in
            //cancel
        })
    }
}


