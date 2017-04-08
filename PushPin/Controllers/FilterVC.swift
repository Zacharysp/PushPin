//
//  FilterVC.swift
//  PushPin
//
//  Created by Zachary on 3/26/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {
    
    @IBOutlet weak var mainImageView: CropImageView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    fileprivate let filterNameList = [
        "No Filter",
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTransfer",
        "CILinearToSRGBToneCurve",
        "CISRGBToneCurveToLinear"
    ]
    
    fileprivate let filterDisplayNameList = [
        "Normal",
        "Chrome",
        "Fade",
        "Instant",
        "Process",
        "Transfer",
        "Tone",
        "Linear"
    ]
    fileprivate let context = CIContext(options: nil)
    fileprivate var resizedImage: UIImage!
    fileprivate var selectedIndex = 0
    
    
    var originImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resizedImage = originImage.resize(newWidth: 100)
        filterCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainImageView.setup(image: originImage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pixelateBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "toSize", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let sizePage = segue.destination as? SizeVC {
            sizePage.originImage = mainImageView.image()!
        }
    }
}

extension FilterVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterDisplayNameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCell", for: indexPath) as! FilterCell
        var filteredImage = resizedImage
        if indexPath.row != 0 {
            filteredImage = resizedImage.filterImage(filterName: filterNameList[indexPath.row])
        }
        cell.preview.image = filteredImage
        cell.preview.contentMode = UIViewContentMode.scaleAspectFit
        cell.nameLabel.text = filterDisplayNameList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if indexPath.row != 0 {
            let newImage = originImage.filterImage(filterName: filterNameList[selectedIndex])
            mainImageView.setup(image: newImage)
        }else {
            mainImageView.setup(image: originImage)
        }
        self.filterCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension FilterVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.height - 24 // leave space for name label
        return CGSize(width: width, height: collectionView.frame.height)
    }
}


