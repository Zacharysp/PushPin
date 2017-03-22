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
    
    var editImage: UIImage?
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var colorBoxStack: UIStackView!
    
    
    
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
    
    @IBAction func saturationBtnPressed(_ sender: UIButton) {
        guard myImageView.image != nil else {
            showAlert(message: "Please select image first")
            return
        }
        let ciImage = CIImage(cgImage: myImageView.image!.cgImage!)
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(2.0, forKey: kCIInputSaturationKey)
        let result = filter?.value(forKey: kCIOutputImageKey) as! CIImage
        let cgimage = CIContext.init(options: nil).createCGImage(result, from: result.extent)
        myImageView.image = UIImage(cgImage: cgimage!)
    }
    @IBAction func getColorBtnPressed(_ sender: UIButton) {
        guard myImageView.image != nil else {
            showAlert(message: "Please select image first")
            return
        }
        stackViewRemoveAll()
        colorBoxStack.translatesAutoresizingMaskIntoConstraints = false
        let colors = myImageView.image!.dominantColors()
        
        let boxHeight = colorBoxStack.frame.size.height
        let boxWidth = colorBoxStack.frame.size.width / CGFloat(colors.count)
        for color in colors {
            let box = UIView()
            box.widthAnchor.constraint(equalToConstant: boxWidth).isActive = true
            box.heightAnchor.constraint(equalToConstant: boxHeight).isActive = true
            box.backgroundColor = color
            colorBoxStack.addArrangedSubview(box)
        }
        
    }
    @IBAction func generateBtnPressed(_ sender: UIButton) {
        guard myImageView.image != nil else {
            showAlert(message: "Please select image first")
            return
        }
        
        editImage = PPImage.resize(image: myImageView.image!, newWidth: 50)
        
        performSegue(withIdentifier: "toGenerate", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let generatePage = segue.destination as? GenerateVC {
            generatePage.editImage = editImage
        }
    }
    
    func showAlert(message: String){
        let alertVC = UIAlertController( title: "PushPin", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction( title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func stackViewRemoveAll(){
        for subview in colorBoxStack.arrangedSubviews {
            colorBoxStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
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
