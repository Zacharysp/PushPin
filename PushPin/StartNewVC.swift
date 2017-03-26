//
//  StartNewVC.swift
//  PushPin
//
//  Created by Dongjie Zhang on 3/22/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit

class StartNewVC: UIViewController,UINavigationControllerDelegate{
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var myImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
    
    @IBAction func photoFromLibrary(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
    }
    
    @IBAction func shootPhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    func noCamera(){
        showAlert(message: "Sorry, this device has no camera")
    }
   
    @IBAction func generateBtnPressed(_ sender: UIButton) {
        guard myImageView.image != nil else {
            showAlert(message: "Please select image first")
            return
        }
        
        performSegue(withIdentifier: "toFilter", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filterPage = segue.destination as? FilterVC {
            filterPage.originImage = myImageView.image!
        }
    }
    
    func showAlert(message: String){
        let alertVC = UIAlertController( title: "PushPin", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction( title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
}

extension StartNewVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            myImageView.contentMode = .scaleAspectFit
            myImageView.image = chosenImage
        } else{
            showAlert(message: "Image type not supported")
        }
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
