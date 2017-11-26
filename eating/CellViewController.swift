//
//  cellViewController.swift
//  eating
//
//  Created by Flatpine8 on 2017/05/11.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit

// 必要に応じてimportします
import CoreLocation


class CellViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var table : UITableView!
    var saveData: UserDefaults = UserDefaults.standard
    var storeInfos: [StoreInfo] = []
    var tmpArray: [[String : Any]]!
    var selectedCoordinate: String!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  table.datasource
        // Do any additional setup after loading the view.
        table.dataSource = self
        table.delegate = self
        print("あ")
        print("い")
        
        if saveData.array(forKey: "storedata")==nil{
            print("まだ情報が保存されてません")
        }else{
            print("情報を取得しました")
            tmpArray = saveData.array(forKey: "storedata") as! [[String : Any]]
            
            for i in tmpArray{
                storeInfos.append(toStoreInfo(dic: i))
            }
            

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //cellの設定

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var  number = 0
        
        if tmpArray==nil{
          number =  0
        }else{
          number =  storeInfos.count
        }
        return number
    }      //cellの個数設定
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoplist", for: indexPath)
        if tmpArray==nil{
            print("検索できませんでした")
        }else{
            cell.textLabel?.text = storeInfos[indexPath.row].name
        }
        return cell
        
    }
    
    //cellが選択された時
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
       selectedCoordinate = storeInfos[indexPath.row].place
    if selectedCoordinate != nil {
            // ViewController へ遷移するために Segue を呼び出す
            performSegue(withIdentifier: "toViewController",sender: nil)
        }
    }
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toViewController") {
            let VC: ViewController = (segue.destination as? ViewController)!
            // SubViewController のselectedImgに選択された画像を設定する
            VC.selectedCoor = selectedCoordinate

        
        }
    }
    //cellのテキスト
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
