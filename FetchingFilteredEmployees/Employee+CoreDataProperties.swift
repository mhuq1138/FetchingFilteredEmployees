//
//  Employee+CoreDataProperties.swift
//  FetchingFilteredEmployees
//
//  Created by Mazharul Huq on 2/25/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var startDate: NSDate?
    @NSManaged public var belongsTo: Department?
    @NSManaged public var department: Department?

}
