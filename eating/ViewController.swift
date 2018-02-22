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
import UserNotifications

class ViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate{
    @IBOutlet var mapView: MKMapView!
    var saveData: UserDefaults = UserDefaults.standard
    var storeInfos: [StoreInfo] = []
    var backgroundTaskID : UIBackgroundTaskIdentifier = 0
    var myMapView: MKMapView!
    var LocationManager: CLLocationManager!
    var selectedCoor: String?
    var location: CLLocation!
    var coordinate: CLLocationCoordinate2D!
    var myLocationManager:CLLocationManager!
    let alert: UIAlertController = UIAlertController(title: "注意！", message: "通知を拒否すると近くの店を探すことができません[設定]から通知を許可してください", preferredStyle: <#T##UIAlertControllerStyle#>)

    
    // 緯度表示用のラベル
    var nowLatitude:CLLocation!
    // 経度表示用のラベル.
    var nowLongitude:CLLocation!
    
    override func viewDidLoad() {
        // 通知を使用可能にする設定
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {
            (granted, error) in
            // エラー処理
            if error != nil {
                return
            }
            
            if granted {
                debugPrint("通知許可")
                
            } else {
                debugPrint("通知拒否")
                //UIAlertViewを出しましょう。
                //調べたら出てくる。メモ帳にある
                self.alert.addAction(
                UIAlertAction(
                    title: "OK!",
                    style: .default,
                    handler: { action in
                        //ボタンが押された時のどうさ
                    print("OK!")
                }
                    )
                )

                present(self.alert, animated: true, completion: nil)
                
            }
        })
        
        
        
        // 現在地の取得.
        
        myLocationManager = CLLocationManager()
        myLocationManager.delegate = self
        // セキュリティ認証のステータスを取得.
        
        let status = CLLocationManager.authorizationStatus()
        
        
        
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        
        if(status == CLAuthorizationStatus.notDetermined) {
            print("didChangeAuthorizationStatus:\(status)");
            // まだ承認が得られていない場合は、認証ダイアログを表示.
            self.myLocationManager.requestAlwaysAuthorization()
        }
        
        
        // 取得精度の設定.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 取得頻度の設定.
        myLocationManager.distanceFilter = 100
        
        //MARK: delegateの設定
        mapView.delegate = self
        
        //表示位置
        if selectedCoor == nil{
            coordinate = CLLocationCoordinate2DMake(35.696135, 139.768322)
            
            
        }else{
            
            let Geocoder:CLGeocoder = CLGeocoder()
            print("a")
            Geocoder.geocodeAddressString(selectedCoor!, completionHandler: { (placemarks, error) -> Void in
                print("ab")
                if(error==nil){
                    print("av")
                    for placemark in placemarks!{
                        // locationにplacemark.locationをCLLocationとして代入する
                        self.location = placemark.location!
                        self.coordinate = CLLocationCoordinate2DMake(self.location.coordinate.latitude,self.location.coordinate.longitude)
                        let span = MKCoordinateSpanMake(0.005, 0.005)
                        let region = MKCoordinateRegionMake(self.coordinate, span)
                        self.mapView.setRegion(region, animated:true)
                        print("af")
                    }
                } else {
                    print("検索できませんでした！")
                }
            })
            
            
        }
        
        
        
        
        
        
        
        
        /*
         //表示範囲を設定
         let myLat: CLLocationDegrees = 37.506804
         let myLon: CLLocationDegrees = 139.930531
         region.span.latitudeDelta = 10
         region.span.longitudeDelta = 10
         mapView.setRegion(region,animated:true)
         */
        super.viewDidLoad()
        
        //MARK: saveData関連
        //saveDataにデータを入れる
        if self.saveData.value(forKey: "storedata") != nil {
            let storezip = self.saveData.value(forKey: "storedata") as?NSData
            //self.saveData.set(NSKeyedArchiver.archivedData(withRootObject: storeInfos), forKey: "storedata")
            
            let tmpArray = NSKeyedUnarchiver.unarchiveObject(with: storezip as! Data) as? [[String : Any]]
            
            for i in tmpArray!{
                storeInfos.append(toStoreInfo(dic: i))
                
            }
        } else{
            storeInfos = []
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in storeInfos {
            //MARK: ピンの吹き出し機能設定
            let annotation = PinMKPointAnnotation()     //アノテーションビューを生成する
            let location: CLLocation = i.locate
            annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)                           //アノテーションビューの座標を設定する
            annotation.title = i.name                //アノテーションビューのタイトルを設定する
            annotation.subtitle = i.place            //アノテーションビューのサブタイトルを設定する
            annotation.pinColor = i.pinColor
            
            self.mapView.addAnnotation(annotation)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //ピンの吹き出し機能設定
        let testPinView = MKPinAnnotationView()    //アノテーションビューを生成する。
        testPinView.annotation = annotation        //アノテーションビューに座標、タイトル、サブタイトルを設定する。
        testPinView.canShowCallout = true          //吹き出しの表示をON にする。
        //アノテーションビューに色を設定する。
        if let test = annotation as? PinMKPointAnnotation {
            testPinView.pinTintColor = test.pinColor
        }
        
        //左ボタンをアノテーションビューに追加する。
        let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.setTitle("色", for: .normal)
        button.setTitleColor(UIColor.black, for:.normal)
        button.backgroundColor = UIColor.yellow
        testPinView.leftCalloutAccessoryView = button
        
        //右ボタンをアノテーションビューに追加する。
        let button2 = UIButton()                   //ボタンを定義
        button2.frame = CGRect(x: 0, y: 0, width: 40, height: 40)//座標、大きさを設定する
        button2.setTitle("削除", for: .normal)//ボタンの名前
        button2.backgroundColor = UIColor.red//ボタンの色
        button2.setTitleColor(UIColor.white, for:.normal)//バックカラー
        testPinView.rightCalloutAccessoryView = button2
        return testPinView
    }
    //吹き出しアクササリー押下時の呼び出しメソッド
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if(control == view.leftCalloutAccessoryView) {
            //左のボタンが押された場合はピンの色をランダムに変更する。
            if let pinView = view as? MKPinAnnotationView {
                pinView.pinTintColor = UIColor(red: CGFloat(drand48()),
                                               green: CGFloat(drand48()),
                                               blue: CGFloat(drand48()),
                                               alpha: 1.0)
            }
        } else {
            
            //右のボタンが押された場合はピンを消す。
            mapView.removeAnnotation(view.annotation!)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus");
        // 認証のステータスをログで表示.
        var statusStr = "";
        switch (status) {
            
        case .notDetermined:
            
            statusStr = "NotDetermined"
            
        case .restricted:
            
            statusStr = "Restricted"
            
        case .denied:
            
            statusStr = "Denied"
            
        case .authorizedAlways:
            
            statusStr = "AuthorizedAlways"
            
        case .authorizedWhenInUse:
            
            statusStr = "AuthorizedWhenInUse"
            
        }
        
        print(" CLAuthorizationStatus: \(statusStr)")
        
    }
    // ボタンイベントのセット.
    
    func onClickMyButton(sender: UIButton){
        
        // 現在位置の取得を開始.
        
        myLocationManager.startUpdatingLocation()
        // 位置情報取得に成功したときに呼び出されるデリゲート.
        
        func locationManager(manager: CLLocationManager!,didUpdateLocations locations: [AnyObject]!){
            // 緯度・経度の表
            
        }
        
        // 位置情報取得に失敗した時に呼び出されるデリゲート.
        
        func locationManager(manager: CLLocationManager!,didFailWithError error: NSError!){
            print("error")
        }
    }    
}


