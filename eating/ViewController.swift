//
//  ViewController.swift
//  eating
//
//  Created by Flatpine8 on 2017/05/03.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController,MKMapViewDelegate{
    @IBOutlet var mapView: MKMapView!
    var saveData: UserDefaults = UserDefaults.standard
    var storeInfos: [StoreInfo] = []
    var backgroundTaskID : UIBackgroundTaskIdentifier = 0
    var myMapView: MKMapView!
    var myLocationManager: CLLocationManager!
    
    override func viewDidLoad() {
        var location:CLLocationCoordinate2D!
        location = CLLocationCoordinate2D(latitude: 35.1, longitude: 139.3)
        mapView.setCenter(location,animated:true)
        // 縮尺を設定
        mapView.delegate = self
        
        var region:MKCoordinateRegion = MKCoordinateRegion()
        region.center = location
        region.span.latitudeDelta = 1.0
        region.span.longitudeDelta = 1.0
        mapView.setRegion(region,animated:true)
        super.viewDidLoad()
        

        
        if saveData.array(forKey: "storedata") != nil {
            let tmpArray = saveData.array(forKey: "storedata") as? [[String : Any]]
            for i in tmpArray!{
                storeInfos.append(toStoreInfo(dic: i))
                
                
            }
            
        } else{
            let temparray : [String : Any] = [:]
            
            /*
            // LocationManagerの生成.
            myLocationManager = CLLocationManager()
            
            // Delegateの設定.
            myLocationManager.delegate = self
            
            // 距離のフィルタ.
            myLocationManager.distanceFilter = 0.1
            
            // 精度.
            myLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            
            // セキュリティ認証のステータスを取得.
            let status = CLLocationManager.authorizationStatus()
            
            // まだ認証が得られていない場合は、認証ダイアログを表示.
            if(status == CLAuthorizationStatus.notDetermined) {
                
                // まだ承認が得られていない場合は、認証ダイアログを表示.
                self.myLocationManager.requestAlwaysAuthorization();
            }
            // 位置情報の更新を開始.
            myLocationManager.startUpdatingLocation()
            
            // MapViewの生成.
            myMapView = MKMapView()
            
            // MapViewのサイズを画面全体に.
            myMapView.frame = self.view.bounds
            
            // Delegateを設定.
            myMapView.delegate = self
            
            // MapViewをViewに追加.
            self.view.addSubview(myMapView)
            
            // 中心点の緯度経度.
            let myLat: CLLocationDegrees = 35.640936
            let myLon: CLLocationDegrees = 139.733481
            let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLat, myLon) as CLLocationCoordinate2D
            
            // 縮尺.
            let myLatDist : CLLocationDistance = 1
            let myLonDist : CLLocationDistance = 1
            
            // Regionを作成.
            let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist);
            
            // MapViewに反映.
            myMapView.setRegion(myRegion, animated: true)
            */
        }
        // GPSから値を取得した際に呼び出されるメソッド.
        func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
            
            // 配列から現在座標を取得.
            var myLocations: NSArray = locations as NSArray
            let myLastLocation: CLLocation = myLocations.lastObject as! CLLocation
            var myLocation:CLLocationCoordinate2D = myLastLocation.coordinate
            
            // 縮尺.
            let myLatDist : CLLocationDistance = 1
            let myLonDist : CLLocationDistance = 1
            
            // Regionを作成.
            let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myLocation, myLatDist, myLonDist);
            
            // MapViewに反映.
            myMapView.setRegion(myRegion, animated: true)
        }
        
        //アノテーションビューを返すメソッド
        
         // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in storeInfos {
            
            let annotation = MKPointAnnotation()
            let location: CLLocation = i.locate
            annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            annotation.title = ""
            annotation.subtitle = ""
            self.mapView.addAnnotation(annotation)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //アノテーションビューを生成する。
        let testPinView = MKPinAnnotationView()
        
        //アノテーションビューに座標、タイトル、サブタイトルを設定する。
        testPinView.annotation = annotation
        
        //アノテーションビューに色を設定する。
        testPinView.pinTintColor = UIColor.blue
        
        //吹き出しの表示をONにする。
        testPinView.canShowCallout = true
        
        return testPinView
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            // 許可を求めるコードを記述する（後述）
            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        case .authorizedWhenInUse:
            // 位置情報の取得開始
            myLocationManager.startUpdatingLocation()
            break
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude) 取得時刻:\(location.timestamp.description)")
        }
    }
}
