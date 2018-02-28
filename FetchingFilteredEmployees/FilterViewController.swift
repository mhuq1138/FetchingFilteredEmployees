//
//  FilterViewController.swift
//  FetchingFilteredEmployees
//
//  Created by Mazharul Huq on 2/25/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {
    var dataManager:DataManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataManager.createRecords()
        self.dataManager.createToOneRelationship()
        self.dataManager.createToManyRelationship()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "displayViewController") as! DisplayViewController
        
            vc.filterOption = indexPath.row
        
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
