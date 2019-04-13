//
//  ManagerContainerController.swift
//  Kiosk
//
//  Created by Mohini Mehetre on 30/03/19.
//  Copyright © 2019 Mayur Deshmukh. All rights reserved.
//

import UIKit

class ManagerContainerController: UIViewController {

    public var usersArray = [LastEntry]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func reloadDeviceEntries() {
        self.tableView.reloadData()
    }

}


extension ManagerContainerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserTableViewCell
        userCell.userName?.text = "\(usersArray[indexPath.row].firstName) \(usersArray[indexPath.row].lastName)"
        return userCell
    }
    
    
}
