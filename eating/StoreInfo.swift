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
    var web: String = ""
    var  locate: CLLocation!
    
    
    
    init(p: String,n: String,w: String,l: CLLocation) {
        place = p
        name = n
        web = w
        locate = l
    }
    
    func setValue(p: String,n: String,w: String) {
        place = p
        name = n
        web = w
    }
    
    func todictionary()->[String:Any]{
        var dic : [String:Any] = [:]
        dic["place"] = self.place
        dic["name"] = self.name
        dic["web"] = self.web
        let latitude = locate.coordinate.latitude
        let longitude = locate.coordinate.longitude
        dic["latitude"] = latitude
        dic["longitude"] = longitude
        return dic
        
    }
    
}
func toStoreInfo( dic :[String: Any]) -> StoreInfo{
    let latitude:CLLocationDegrees = CLLocationDegrees(exactly: dic["latitude"] as! Double)!
    let longitude:CLLocationDegrees = CLLocationDegrees(exactly: dic["longitude"] as! Double)!
    let locate:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
    
    let storeInfo = StoreInfo(p: dic["place"] as! String , n: dic["name"] as! String , w: dic["web"] as! String, l:locate)
    return storeInfo
    
}
