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
    var pinColor: UIColor
    var locate: CLLocation!
    
    
    
    init(p: String,n: String,w: String,l: CLLocation,b: UIColor) {
        print("あ")
        place = p
        print("い")
        name = n
        print("う")
        web = w
        print("え")
        locate = l
        print("お")
        pinColor = b
        print("か")
        
    }
    
    func setValue(p: String,n: String,w: String,b: UIColor) {
        place = p
        name = n
        web = w
        pinColor = b
    }
    
    func todictionary()->[String:Any]{
        print("Dic1")
        var dic : [String:Any] = [:]
        dic["place"] = self.place
        dic["name"] = self.name
        dic["web"] = self.web
        let latitude = locate.coordinate.latitude
        let longitude = locate.coordinate.longitude
        dic["latitude"] = latitude
        dic["longitude"] = longitude
        dic["pick"] = self.pinColor
        print("Dic2")
        
        switch self.pinColor {
            case UIColor.red:
            dic["pick"] = "red"
            case UIColor.blue:
            dic["pick"] = "blue"
            case UIColor.yellow:
            dic["pick"] = "yellow"
            case UIColor.orange:
            dic["pick"] = "orange"
            default:
            dic["pick"] = "purple"
        }

        print("Dic3")
    
        return dic
        
    }
    
    
}


func toStoreInfo(dic: [String: Any]) -> StoreInfo{
    let latitude:CLLocationDegrees = CLLocationDegrees(exactly: dic["latitude"] as! Double)!
    let longitude:CLLocationDegrees = CLLocationDegrees(exactly: dic["longitude"] as! Double)!
    let locate:CLLocation = CLLocation(latitude: latitude, longitude: longitude)
    let colorNumber:String = dic["pick"] as! String
    
    var pinColor: UIColor!
    switch colorNumber{
    case "red":
        pinColor = UIColor.red
    case "blue":
        pinColor = UIColor.blue
    case "yellow":
        pinColor = UIColor.yellow
    case "orange":
        pinColor = UIColor.orange
    default:
        pinColor = UIColor.purple
        
        
    }
    
    let storeInfo = StoreInfo(p: dic["place"] as! String , n: dic["name"] as! String , w: dic["web"] as! String, l:locate,b: pinColor)
    return storeInfo
    
}
    
