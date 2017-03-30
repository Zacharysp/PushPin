//
//  NewItemVC.swift
//  PushPin
//
//  Created by Dongjie Zhang on 3/29/17.
//  Copyright © 2017 Zachary. All rights reserved.
//

import UIKit

struct Resolution {
    let small = (x: 50, y: 67)
    let medium = (x: 75, y: 100)
    let large = (x: 100, y: 134)
    let xLarge = (x: 150, y: 200)
}

class NewItemVC: UIViewController {

    @IBOutlet weak var newItemStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func buildResolutionView(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
