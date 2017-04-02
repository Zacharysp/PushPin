//
//  SizeVC.swift
//  PushPin
//
//  Created by Dongjie Zhang on 4/2/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit
class SizeVC: UIViewController {
    
    var originImage: UIImage!
    var images: SizeDitherImage!

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images = SizeDitherImage(image: originImage)
        images.delegate = self
        
        buildPageControl()
        buildCollectionView()
    }
    
    func buildPageControl(){
        pageControl.numberOfPages = images.imageArray.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.red
    }
    
    func buildCollectionView(){
        
        sizeCollectionView.backgroundColor = UIColor.clear
        sizeCollectionView.register(SizeCell.self, forCellWithReuseIdentifier: "sizeCell")
        sizeCollectionView.collectionViewLayout = buildLayout()
    }
    
    func buildLayout() -> UICollectionViewFlowLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20.0
        //left and right inset
        let screenWidth = UIScreen.main.bounds.size.width
        layout.sectionInset = UIEdgeInsetsMake(0, screenWidth/10, 0, screenWidth/10)

        return layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SizeVC: SizeDitherImageDelegate {
    func finishDither() {
        DispatchQueue.main.async {
            self.sizeCollectionView.reloadData()
        }
    }
}

extension SizeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sizeCell", for: indexPath) as! SizeCell
        cell.workSize = images.imageArray[indexPath.row].size
        if let image = images.imageArray[indexPath.row].ditherImage {
            cell.imageView.image = image
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = CGFloat(images.imageArray.count) * (scrollView.contentOffset.x + UIScreen.main.bounds.size.width*0.2) / scrollView.contentSize.width
        guard currentPage >= 0 && currentPage < 5 else {
            return
        }
        pageControl.currentPage = Int(currentPage)
    }
}

extension SizeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width*0.8, height: collectionView.bounds.height - 40)
    }
}

