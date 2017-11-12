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
    var LocationManager: CLLocationManager!
    
    override func viewDidLoad() {
        //MARK: delegateの設定
        mapView.delegate = self
        
        //MARK: 現在位置情報を取得
        
        if CLLocationManager.locationServicesEnabled() {
            LocationManager = CLLocationManager()
            LocationManager.delegate = self
            LocationManager.startUpdatingLocation()
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
        if saveData.array(forKey: "storedata") != nil {
            let tmpArray = saveData.array(forKey: "storedata") as? [[String : Any]]
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
            let annotation = MKPointAnnotation()     //アノテーションビューを生成する
            let location: CLLocation = i.locate
            annotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)                           //アノテーションビューの座標を設定する
            annotation.title = i.name                //アノテーションビューのタイトルを設定する
            annotation.subtitle = i.place            //アノテーションビューのサブタイトルを設定する
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
        testPinView.canShowCallout = true          //吹き出しの表示をONにする。
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
            LocationManager.startUpdatingLocation()
            break
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude) 取得時刻:\(location.timestamp.description)")
            let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            
            //表示範囲
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(center, span)
            mapView.setRegion(region,animated:true)
        }
        
    }
}


