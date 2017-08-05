//
//  StoreInfo.swift
//  eating
//
//  Created by Flatpine8 on 2017/06/22.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit
import  CoreLocation

class StoreInfo {
    
    var place: String = ""
    var name: String =  ""
    var web: URL!
    var  locate: CLLocation!
    
    
    init(p: String,n: String,w: URL,l: CLLocation) {
        place = p
        name = n
        web = w
        locate = l
        
    }
    
    func setValue(p: String,n: String,w: URL) {
        place = p
        name = n
        web = w
    }
    
}
