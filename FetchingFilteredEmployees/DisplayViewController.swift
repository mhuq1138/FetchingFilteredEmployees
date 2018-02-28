//
//  DisplayViewController.swift
//  FetchingFilteredEmployees
//
//  Created by Mazharul Huq on 2/25/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit

class DisplayViewController: UITableViewController {
    @IBOutlet var predicateLabel: UILabel!
    
    var employees:[Employee] = []
    var dataManager:DataManager!
    var filterOption = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 90.0

        self.dataManager = DataManager(dataModel: "EmployeeList")
        if let predicate = getPredicate(option: self.filterOption){
            if filterOption == 3{
                self.predicateLabel.text = "startDate < 01/01/2005"
            }
            else{
                self.predicateLabel.text = String(describing: predicate)
            }
            employees = self.dataManager.fetchEmployees(predicate)
        }
    }

    func getPredicate(option:Int)-> NSPredicate?{
        var predicate:NSPredicate? = nil
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        
        switch option{
        case 0:
            predicate = NSPredicate(format: "firstName == 'Mary'")
        case 1:
            predicate  = NSPredicate(format: "%K CONTAINS %@", "firstName", "an")
        case 2:
            predicate  = NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(Employee.belongsTo.name), "acc")
        case 3:
            let date = formatter.date(from: "1/1/2005")
            predicate  = NSPredicate(format: "%K < %@", #keyPath(Employee.startDate), date! as CVarArg)
        case 4:
            predicate  = NSPredicate(format: "%K CONTAINS[c] %@", #keyPath(Employee.department.name), "acc")
        default: break
        }
        return predicate
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return employees.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let employee = employees[indexPath.row]
        var nameString = ""
 
        if let first = employee.firstName,
            let last = employee.lastName,
            let dob = employee.dateOfBirth{
            nameString = first + " " + last + "  dob:" + dateFormatter.string(from: dob as Date)
        }
        var departmentString = ""
        var department = ""
        if let name = employee.belongsTo?.name{
            department = name
        }
        if let date = employee.startDate{
            departmentString = department + "  Start Date:" + dateFormatter.string(from: date as Date)
        }
        var managerString = ""
        if let name = employee.department?.name{
            managerString = "Manager: " + name
        }
        
        cell.nameLabel?.text = nameString
        cell.departmentLabel?.text = departmentString
        cell.managerLabel?.text = managerString

        return cell
    }
    
}
