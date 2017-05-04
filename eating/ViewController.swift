//
//  ViewController.swift
//  eating
//
//  Created by Flatpine8 on 2017/05/03.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate{
    
    
    @IBOutlet var mapView: MKMapView!
    
   
    override func viewDidLoad() {
    let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(35.681298, 139.766247)
        
    mapView.setCenter(location,animated:true)
        // 縮尺を設定
        var region:MKCoordinateRegion = mapView.region
        region.center = location
        region.span.latitudeDelta = 1.0
        region.span.longitudeDelta = 1.0
        
        mapView.setRegion(region,animated:true)
        
        // 表示タイプを航空写真と地図のハイブリッドに設定
        //        mapView.mapType = MKMapType.standard
        //        mapView.mapType = MKMapType.satellite
        mapView.mapType = MKMapType.hybrid
        
     
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

