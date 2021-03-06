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




class ViewController: UIViewController,MKMapViewDelegate,PinViewDelegate {
    @IBOutlet var mapView: MKMapView!
    var saveData: UserDefaults = UserDefaults.standard
    var storeInfos: [StoreInfo] = []
    var backgroundTaskID : UIBackgroundTaskIdentifier = 0
    var myMapView: MKMapView!
    var locationManager: CLLocationManager!
    var selectedCoor: String?
    var location: CLLocation!
    var coordinate: CLLocationCoordinate2D!
    var myLocationManager:CLLocationManager!
    let alert: UIAlertController = UIAlertController(title: "注意！", message: "通知を拒否すると近くの店を探すことができません[設定]から通知を許可してください", preferredStyle: .alert)
    var texturl: String?
    
    // 緯度表示用のラベル
    var nowLatitude:CLLocation!
    // 経度表示用のラベル.
    var nowLongitude:CLLocation!
    
    override func viewDidLoad() {
        locationManager = CLLocationManager() // インスタンスの生成
        locationManager.delegate = self // CLLocationManagerDelegateプロトコルを実装するクラスを指定する
        mapView.delegate = self
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
                
                self.present(self.alert, animated: true, completion: nil)
                
            }
        })
        
        
        
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
            //let baseString = i.name
            //let attributedString = NSMutableAttributedString(string: baseString)
            //let URLstring = "https://www.google.com.searchsxas?q=" + baseString
            //attributedString.addAttribute(baseString, value: URLstring, range: NSString(string: baseString).range(of: baseString))
            
            
            annotation.title = i.name            //アノテーションビューのタイトルを設定するattributedString
            //print(type(of: baseString))
            
            annotation.subtitle = i.place            //アノテーションビューのサブタイトルを設定する
            annotation.pinColor = i.pinColor         //アノテーションビューのpincolorを設定する
            annotation.imageName = getImage(imagefile: i.imagename)//アノテーションビューの画像を設定する
            annotation.ID = i.ID                     //アンテーションビューのIDを設定する
            self.mapView.addAnnotation(annotation)   //ピンが押された時の動きを設定
            print(i.ID)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //annotation = PinPointAnnotation ではなかった時の処理
        guard let pinInfo = annotation as? PinMKPointAnnotation else { return nil }
        
        //ピンの吹き出し機能設定
        let annotationView = MKPinAnnotationView()
        let pinView = Bundle.main.loadNibNamed("PinView", owner: self, options: nil)?.first as! PinView//アノテーションビューを生成する。
        
        annotationView.annotation = pinInfo       //アノテーションビューに座標、タイトル、サブタイトルを設定する。
        annotationView.canShowCallout = true          //吹き出しの表示をON にする。
        //アノテーションビューに色を設定する。
        
        annotationView.pinTintColor = pinInfo.pinColor
        
        let baseString = pinInfo.title
        let attributedString = NSMutableAttributedString(string: baseString!)
        var URLstring = "https://www.google.co.jp/search?q=" + baseString!
        URLstring = URLstring.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        print("あ"+URLstring)
        attributedString.addAttribute(NSLinkAttributeName, value: URLstring, range: NSString(string: baseString!).range(of: baseString!))
        
        print(URLstring)
        pinView.PinViewmemo.text = pinInfo.subtitle
        pinView.PinViewname.attributedText = attributedString
        pinView.PinViewphoto.image = pinInfo.imageName
        pinView.annotation = annotation
        
        
        // 左ボタンをアノテーションビューに追加する。
        //    let pinimageView = UIImageView()
        //   pinimageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        //  pinimageView.image = pinInfo.imageName!
        //    annotationView.leftCalloutAccessoryView = pinimageView
        let widthConstraint = NSLayoutConstraint(item: pinView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 347)
        pinView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: pinView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 428)
        pinView
            
            .addConstraint(heightConstraint)
        
        annotationView.detailCalloutAccessoryView = pinView
        
        return annotationView
        
        
        
    }
    
    //吹き出しアクササリー押下時の呼び出しメソッド
    //    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    
    //        if(control == view.rightCalloutAccessoryView) {
    //            var removeindex:Int!
    //右のボタンが押された場合はピンを消す。
    //           guard let pinInfo = view.annotation as? PinMKPointAnnotation else {
    //               return
    //           }
    //           for (index, storeInfonumber) in storeInfos.enumerated(){
    //               if storeInfonumber.ID == pinInfo.ID{
    //                   removeindex = index
    //                    break
    //                }
    //           }
    
    //          storeInfos.remove(at: removeindex)
    
    //          let dictionaries = storeInfos.map{ $0.todictionary() }
    //          self.saveData.set(NSKeyedArchiver.archivedData(withRootObject: dictionaries), forKey: "storedata")
    //          print("保存完了１")
    //           mapView.removeAnnotation(view.annotation!)
    //       }
    //   }
    func diddelete() {
        
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        //通知設定に必要なクラスをインスタンス化
        //トリガーの設定
        var trigger: UNNotificationTrigger
        for i in storeInfos{
            let triggercoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude)
            let triggerregion = CLCircularRegion(center: coordinate, radius: 100.0, identifier: "description")
            trigger = UNLocationNotificationTrigger(region: triggerregion, repeats: false)
            let content = UNMutableNotificationContent()
            content.title = i.place
            content.body = "近くに"+i.place+"があります！"
            content.sound = UNNotificationSound.default()
            if let url = Bundle.main.url(forResource: "image", withExtension: "png") {
                let attachment = try? UNNotificationAttachment(identifier: "attachment", url: url, options: nil)
                if let attachment = attachment {
                    content.attachments = [attachment]
                }
                // categoryIdentifierを設定
                content.categoryIdentifier = "attachment"
            }
            let request = UNNotificationRequest(identifier: "attachment",
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    // ファイルを保存するURLを返す
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // ファイルに画像を保存する
    func saveImageToDocumentsDirectory(image: UIImage, name: String) {
        if let data = UIImagePNGRepresentation(image) {
            let filename = getDocumentsDirectory().appendingPathComponent(name)
            try? data.write(to: filename)
        }
    }
    
    func getImage(imagefile: String) -> UIImage?{
        let filename = getDocumentsDirectory().appendingPathComponent(imagefile)
        do {
            let data = try Data(contentsOf: filename)
            return UIImage(data: data)
        }catch{
            return  #imageLiteral(resourceName: "no image wow.png")
        }
        
    }
    
    
    
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse:
            // 位置情報の取得開始
            
            break
            
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            manager.startUpdatingLocation()
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
            print("起動時のみ、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            for location in locations {
                print("緯度:\(location.coordinate.latitude) 経度:\(location.coordinate.longitude) 取得時刻:\(location.timestamp.description)")
            }
        }
    }
    
}
