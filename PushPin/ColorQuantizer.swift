////
////  ColorQuantizer.swift
////  PushPin
////
////  Created by Dongjie Zhang on 3/29/17.
////  Copyright © 2017 Zachary. All rights reserved.
////
//
//import Foundation
//
//class ColorQuantizer {
//    var octree: Octree
//    let hexasForBitLevel = [0x80, 0x40, 0x20, 0x10]
//    
//    required init() {
//        self.octree = Octree(level: 0)
//    }
//    
//    // Returns RGB-bit for level, level can be 0-3
//    private func bitForLevel(level: Int, color: Color) -> Int {
//        let hexa = UInt8(self.hexasForBitLevel[level])
//        let bitsToShift = UInt8(7 - level)
//        return Int((((color.r&hexa) >> bitsToShift) << 2) | (((color.g&hexa) >> bitsToShift) << 1) | ((color.b&hexa) >> bitsToShift))
//    }
//    
//    // Add color to a tree
//    func addColor(tree: Octree, color: Color) {
//        if (tree.isLeaf) {
//            tree.rsum += Double(color.r)
//            tree.gsum += Double(color.g)
//            tree.bsum += Double(color.b)
//            tree.refCount += 1
//        } else {
//            let deeperLevel = tree.level + 1
//            let levelBit = self.bitForLevel(deeperLevel, color: color)
//            
//            self.addColor(tree.children[levelBit] as! Octree, color: color)
//        }
//    }
//    
//    func getPalette(tree: Octree, colors: NSMutableArray) {
//        if (tree.isLeaf && tree.refCount > 0) {
//            colors.addObject(tree.color())
//        } else if (!tree.isLeaf) {
//            for index in 0...7 {
//                getPalette(tree: tree.children[index] as! Octree, colors: colors)
//            }
//        }
//    }
//}
//// Octree.swift
//import Foundation
//
//class Octree {
//    var rsum: Double = 0
//    var gsum: Double = 0
//    var bsum: Double = 0
//    var isLeaf: Bool = false
//    var refCount: Int = 0
//    var level: Int
//    var children = NSMutableArray()
//    
//    required init(level: Int) {
//        self.level = level
//        isLeaf = (level == 3)
//        
//        if (!isLeaf) {
//            for index in 0...7 {
//                self.children.insert(Octree(level: level + 1), at: index)
//            }
//        }
//    }
//    
//    func color() -> Color {
//        let r = UInt8(rsum / Double(refCount))
//        let g = UInt8(gsum / Double(refCount))
//        let b = UInt8(bsum / Double(refCount))
//        return Color(r: r, g: g, b: b)
//    }
//}
