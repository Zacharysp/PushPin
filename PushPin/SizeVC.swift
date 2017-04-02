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
    
    var sizes: Array<WorkSize>!

//    @IBOutlet weak var sizeCardView: TGLParallaxCarousel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var sizeCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originImage = UIImage(named: "test.jpg")!.resize(newWidth: 100)
        sizes = [
            WorkSize(type: .xSmall),
            WorkSize(type: .small),
            WorkSize(type: .medium),
            WorkSize(type: .large),
            WorkSize(type: .xLarge)
        ]
        
        buildPageControl()
        buildCollectionView()
    }
    
//    func setupCarousel() {
//        sizeCardView.delegate = self
//        sizeCardView.margin = 10
//        sizeCardView.selectedIndex = 0
//        sizeCardView.type = .threeDimensional
//    }
    
    func buildPageControl(){
        pageControl.numberOfPages = sizes.count
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
        let layout = SizeFlowLayout()
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

extension SizeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sizeCell", for: indexPath) as! SizeCell
        cell.backgroundColor = UIColor.gray
        cell.workSize = WorkSize(type: WorkSizeType(rawValue: indexPath.row) ?? WorkSizeType.medium)
        cell.image = originImage
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = CGFloat(sizes.count) * (scrollView.contentOffset.x + UIScreen.main.bounds.size.width*0.2) / scrollView.contentSize.width
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

class SizeFlowLayout: UICollectionViewFlowLayout {
    let ActiveDistance : CGFloat = 300
    let ScaleFactor : CGFloat = 0.25
    
//    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        var offsetAdjustment = CGFloat(MAXFLOAT)
//        let horizontalCenter = proposedContentOffset.x + (self.collectionView!.bounds.width / 2.0)
//        let targetRect = CGRect(x: proposedContentOffset.x, y: 0.0, width:  self.collectionView!.bounds.size.width, height: self.collectionView!.bounds.size.height)
//        let array = super.layoutAttributesForElements(in: targetRect) as [UICollectionViewLayoutAttributes]!
//        for layoutAttributes in array!{
//            let itemHorizontalCenter = layoutAttributes.center.x
//            if(abs(itemHorizontalCenter-horizontalCenter) < abs(offsetAdjustment)){
//                offsetAdjustment = itemHorizontalCenter-horizontalCenter
//            }
//        }
//        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
//    }
//    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        let array = super.layoutAttributesForElements(in: rect)
//        var visibleRect = CGRect()
//        visibleRect.origin = self.collectionView!.contentOffset
//        visibleRect.size = self.collectionView!.bounds.size
//        for attributes in array!{
//            let distance = visibleRect.midX - attributes.center.x
//            let normalizedDistance = distance/ActiveDistance
//            let zoom = 1 - ScaleFactor*(abs(normalizedDistance))
//            let alpha = 1 - abs(normalizedDistance)
//            attributes.transform3D = CATransform3DMakeScale(1.0, zoom, 1.0)
//            attributes.alpha = alpha
//            attributes.zIndex = 1
//        }
//        return array
//    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

