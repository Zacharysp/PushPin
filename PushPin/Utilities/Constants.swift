//
//  Constants.swift
//  PushPin
//
//  Created by Dongjie Zhang on 4/1/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import Foundation
import UIKit

func dLog(message: String, filename: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
        print("***[\((filename as NSString).lastPathComponent):\(line)] \(function) ----- \(message)")
    #endif
}

struct Constants {
    static let APP_NAME = "PushPin"
    
    struct ALERT {
        static let NEW_ITEM = "Add new work"
        static let FROM_LIBRARY = "From library"
        static let FROM_CAMERA = "From camera"
        static let CANCEL = "Cancel"
    }
    
    struct COLOR {
        static let BACKGROUD = UIColor(red: 60/255.0, green: 92/255.0, blue: 102/255.0, alpha: 0.6)
    }
}
