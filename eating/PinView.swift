//
//  PinView.swift
//  eating
//
//  Created by Flatpine8 on 2018/05/24.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import MapKit

class PinView: MKPinAnnotationView {
    var saveData: UserDefaults = UserDefaults.standard

    @IBAction func delete() {

    }
    @IBOutlet var PinViewname :UILabel!
    @IBOutlet var PinViewmemo :UILabel!
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
