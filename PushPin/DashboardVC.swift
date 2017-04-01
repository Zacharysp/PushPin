//
//  DashboardVC.swift
//  PushPin
//
//  Created by Dongjie Zhang on 3/29/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit
import ImageIO

class DashboardVC: UIViewController, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var DashboardCollectionView: UICollectionView!
    //selected image from photo library or capture from camera
    var selectedImage: UIImage?
    
    var items: Array<WorkItem> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        //append new item to the end
        items.append(WorkItem())
        
        buildCollectionView()
    }
    
    func buildCollectionView(){
        DashboardCollectionView.register(DashboardCell.self, forCellWithReuseIdentifier: "dashboardCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let filterPage = segue.destination as? FilterVC {
            guard selectedImage != nil else {
                return
            }
            filterPage.originImage = selectedImage!
        }
    }
    
    //MARK: image picker methods
    func noCamera(){
        showAlert(message: "Sorry, this device has no camera")
    }
    
    func showAlert(message: String){
        let alertVC = UIAlertController( title: "PushPin", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction( title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DashboardVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImage = chosenImage
            performSegue(withIdentifier: "toFilter", sender: nil)
        } else{
            showAlert(message: "Image type not supported")
        }
        dismiss(animated:true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension DashboardVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardCell", for: indexPath) as! DashboardCell
        cell.backgroundColor = UIColor.gray
        cell.delegate = self
        return cell
    }
}

extension DashboardVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 2)
    }
}

extension DashboardVC: DashboardCellDelegate {
    func didStartNewItem() {
        buildAlertSheet()
    }
    
    func buildAlertSheet(){
        //setting up alert controller from new work source
        let alertActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: Constants.ALERT.CANCEL, style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        alertActionSheet.addAction(cancelAction)
        //from photo library
        let libraryAction: UIAlertAction = UIAlertAction(title: Constants.ALERT.FROM_LIBRARY, style: .default) { action -> Void in
            self.openLibrary()
        }
        alertActionSheet.addAction(libraryAction)
        //from camera
        let cameraAction: UIAlertAction = UIAlertAction(title: Constants.ALERT.FROM_CAMERA, style: .default) { action -> Void in
            self.openCamera()
        }
        alertActionSheet.addAction(cameraAction)
        alertActionSheet.view.tintColor = UIColor.red
        self.present(alertActionSheet, animated: true, completion: nil)
    }
    
    func openLibrary() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(self.picker, animated: true, completion: nil)
    }
    
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(self.picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
}
