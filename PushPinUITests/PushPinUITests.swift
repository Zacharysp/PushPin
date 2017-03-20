//
//  PushPinUITests.swift
//  PushPinUITests
//
//  Created by Zachary on 3/18/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import XCTest

class PushPinUITests: XCTestCase {
    
    var image: UIImage!
    var pushpinColorArr: Array<PPColor>!
    
    var vc: ViewController!
        
    override func setUp() {
        super.setUp()
        
        
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "wife", ofType: "jpg")!
        
        image = UIImage(contentsOfFile: path)        
        //construct color array for hex, rgb or UIColor
        var pushpinColorArr: Array<PPColor> =  [
            PPColor(hex: "#FF007F"),
            PPColor(hex: "#FF0000"),
            PPColor(hex: "#FF7F00"),
            PPColor(hex: "#FFFF00"),
            PPColor(hex: "#7FFF00"),
            PPColor(hex: "#00FF00"),
            PPColor(hex: "#00FF7F"),
            PPColor(hex: "#00FFFF"),
            PPColor(hex: "#007FFF"),
            PPColor(hex: "#0000FF"),
            PPColor(hex: "#7F00FF"),
            PPColor(hex: "#FF00FF")
        ]
        
        pushpinColorArr.append(PPColor(color: UIColor.red))
        pushpinColorArr.append(PPColor(color: UIColor.blue))
        pushpinColorArr.append(PPColor(color: UIColor.green))
        pushpinColorArr.append(PPColor(color: UIColor.yellow))
        pushpinColorArr.append(PPColor(color: UIColor.black))
        pushpinColorArr.append(PPColor(color: UIColor.brown))
        pushpinColorArr.append(PPColor(color: UIColor.purple))
        pushpinColorArr.append(PPColor(color: UIColor.magenta))
        pushpinColorArr.append(PPColor(color: UIColor.white))
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateInitialViewController() as! ViewController
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        self.measure() {
            //do something you want to measure
            
            let newImage = self.vc.makeImage(oldImage: self.image, sectionSize: 12, colors: self.pushpinColorArr)
            
            XCTAssertNotNil(newImage)

        }
    }
    
}
