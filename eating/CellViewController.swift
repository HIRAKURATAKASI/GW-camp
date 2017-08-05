//
//  cellViewController.swift
//  eating
//
//  Created by Flatpine8 on 2017/05/11.
//  Copyright © 2017年 mycompany. All rights reserved.
//

import UIKit

class CellViewController: UIViewController, UITableViewDataSource {

    @IBOutlet var table:UITableView!
    var saveData: UserDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
      //  table.datasource
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        storeInfos.string(forKey: "storedata")
        return  storeInfos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shoplist", for: indexPath)
        cell.textLabel?.text = storeIfos[indexPath.row]
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
