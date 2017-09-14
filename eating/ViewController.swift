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
    var nowLocation: CLLocation! = CLLocation()
    
    override func viewDidLoad() {

        //MARK: 現在位置関連

        //TODO: 現在位置を取得
        if CLLocationManager.locationServicesEnabled() {
            myLocationManager = CLLocationManager()
            myLocationManager.delegate = self
            myLocationManager.startUpdatingLocation()
        }
        
        //中心点を表示
        mapView.setCenter(nowLocation,animated:true)
        mapView.delegate = self
        
        var region:MKCoordinateRegion = MKCoordinateRegion()
        region.center = nowLocation
        region.span.latitudeDelta = 0.1
        region.span.longitudeDelta = 0.1
        mapView.setRegion(region,animated:true)
        super.viewDidLoad()
        
        
        //MARK: saveData関連
        //saveDataにデータを入れる
        if saveData.array(forKey: "storedata") != nil {
            let tmpArray = saveData.array(forKey: "storedata") as? [[String : Any]]
            for i in tmpArray!{
                storeInfos.append(toStoreInfo(dic: i))
                
                
            }
            
        } else{
            storeInfos = []
            
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
        
        nowLocation = locations.last
    }
}


