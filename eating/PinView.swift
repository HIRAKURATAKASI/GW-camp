//
//  PinView.swift
//  eating
//
//  Created by Flatpine8 on 2018/05/24.
//  Copyright © 2018年 mycompany. All rights reserved.
//

import UIKit
import MapKit

// PinViewDelegate プロトコルを記述
@objc protocol PinViewDelegate {
    // デリゲートメソッド定義
    func diddelete()
}

class PinView: UIView {
    var saveData: UserDefaults = UserDefaults.standard

    var annotation: MKAnnotation!
    
    @IBAction func delete() {
        //self.delegate?.diddelete

    }
    @IBOutlet var PinViewname :UILabel!
    @IBOutlet var PinViewmemo :UILabel!
    @IBOutlet var PinViewphoto :UIImageView!
 
    
    
    //吹き出しアクササリー押下時の呼び出しメソッド
 //   func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
   //     if(control == view.rightCalloutAccessoryView) {
    //        var removeindex:Int!
            //右のボタンが押された場合はピンを消す。
  //          guard let pinInfo = view.annotation as? PinMKPointAnnotation else {
   //             return
  //          }
  //          for (index, storeInfonumber) in storeInfos.enumerated(){
  //              if storeInfonumber.ID == pinInfo.ID{
  //                  removeindex = index
  //                  break
  //              }
  //          }
            
  //          storeInfos.remove(at: removeindex)
            
  //          let dictionaries = storeInfos.map{ $0.todictionary() }
  //          self.saveData.set(NSKeyedArchiver.archivedData(withRootObject: dictionaries), forKey: "storedata")
  //          print("保存完了１")
  //          mapView.removeAnnotation(view.annotation!)
  //      }
 //   }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
