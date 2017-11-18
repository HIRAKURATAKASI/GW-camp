//
//  detailViewController.swift
//  eating
//
//  Created by Flatpine8 on 2017/05/04.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit
import  CoreLocation

class detailViewController: UIViewController ,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate ,UIPickerViewDelegate,UIPickerViewDataSource{
    @IBOutlet var placeTextField: UITextField!
    @IBOutlet var webTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var haikeiimageView: UIImageView!
    var saveData: UserDefaults = UserDefaults.standard
    var picker: UIPickerView = UIPickerView()
    let pickerlist  = ["赤","青","黄色","オレンジ","ピンク"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegateの設定
        nameTextField.delegate = self
        placeTextField.delegate = self
        webTextField.delegate = self
        picker.delegate = self
        picker.dataSource = self
        
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        //表示する列数
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        //アイテム表示個数を返す（選択肢の個数）
        return pickerlist.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //選択肢のタイトル
        return pickerlist[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //選択時の処理
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveMemo(){
        let myGeocoder:CLGeocoder = CLGeocoder()
        //住所
        let searchStr = placeTextField.text
        var location:CLLocation
        location = CLLocation(latitude: 35.1, longitude: 139.3)
        //住所を座標に変換する。
        myGeocoder.geocodeAddressString(searchStr!, completionHandler: {(placemarks, error) in
            if(error == nil){
                for placemark in placemarks!{
                    location = placemark.location!
                }
            } else {
                self .placeTextField.text = "検索できませんでした"
            }
        //MARK: storeInfoに住所、名前、メモを保存する
            let storeInfo = StoreInfo(p: self.placeTextField.text!, n: self.nameTextField.text!, w: self.webTextField.text!, l: location)
            
            if (self.saveData.object(forKey: "storedata") != nil) {
                var storeInfos = self.saveData.array(forKey: "storedata") as![[String: Any]]
                storeInfos.append(storeInfo.todictionary())
                self.saveData.set(storeInfos, forKey: "storedata")
            }else{
                var storeInfos: [[String: Any]] = []
                storeInfos.append(storeInfo.todictionary())
                self.saveData.set(storeInfos, forKey: "storedata")
            }
            self.saveData.synchronize()
            
        })
        
        //alertを出す
        let alert:UIAlertController = UIAlertController(title:"保存",message: "保存が完了しました",preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertActionStyle.default,
                handler: {action in
                    //ボタンを押した時に前の画面に戻る
                    self.dismiss(animated: true, completion: nil)
            }
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        let now = Date()
        return formatter.string(from: now)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
    @IBAction func selectBackground(){
        //UIImagePikerControllerのインスタンスを作る
        let imagePickerController: UIImagePickerController = UIImagePickerController()
        
        //フォトライブラリを使う設定にする
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        //フォトライブラリを呼び出す
        self.present(imagePickerController,animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
        [String : Any]){
        
        //imageに選んだ画像を設定する
        let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        //そのimageを背景に設定する
        haikeiimageView.image = image
        
        //フォトライブラリを閉じる
        picker.dismiss(animated: true, completion: nil)
        
    }
    func configureObserver(){
        //Notificationを設定
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //notificationを削除
    func removeObserver(){
        
        let notification = NotificationCenter.default
        notification.removeObserver(self)
    }
    //キーボードが現れた時に、画面全体をずらす
    func keyboardWillShow(notification: Notification?){
        
        let rect = (notification?.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
        UIView.animate(withDuration: duration!, animations: { () in
            let  transform = CGAffineTransform(translationX: 0, y: -(rect?.size.height)!)
            self.view.transform = transform
        })
        
    }
    
    //キーボードが消えた時に画面を戻す
    func keyboardWillHide(notification: Notification?){
        
        let duration: TimeInterval? = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey]as? Double
        UIView.animate(withDuration: duration!,animations: { () in
            
            self.view.transform = CGAffineTransform.identity
        })
    }
    
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


