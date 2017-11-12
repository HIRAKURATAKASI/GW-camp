//
//  cellViewController.swift
//  eating
//
//  Created by Flatpine8 on 2017/05/11.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit

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
        tmpArray = saveData.array(forKey: "storedata") as! [[String : Any]]
        for i in tmpArray{
            storeInfos.append(toStoreInfo(dic: i))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //cellの設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return  storeInfos.count
    }      //cellの個数設定
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoplist", for: indexPath)
        cell.textLabel?.text = storeInfos[indexPath.row].name
        return cell
        
    }
    
    //cellが選択された時
    func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
       selectedCoordinate = storeInfos[indexPath.row].place
        
        
        if selectedCoordinate != nil{
            // ViewController へ遷移するために Segue を呼び出す
            performSegue(withIdentifier: "toViewController",sender: nil)
        }
    }
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toViewController") {
        
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
