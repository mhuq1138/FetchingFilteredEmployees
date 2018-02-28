//
//  DataManager.swift
//  WorkingWithManagedObjects
//
//  Created by Mazharul Huq on 1/15/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class DataManager{
    var coreDataStack:CoreDataStack
    var managedObjectContext:NSManagedObjectContext
    
    init(dataModel:String){
        self.coreDataStack = CoreDataStack(modelName: dataModel)
        self.managedObjectContext = self.coreDataStack.managedObjectContext
    }
    
   //Creating records
    func createEmployee(firstName: String, lastName: String, dobString:String, sdString:String){
        //Create an entity and insert into context
        let entityDesciption = NSEntityDescription.entity(forEntityName: "Employee",in: self.managedObjectContext)
        let employee = NSManagedObject(entity:entityDesciption!,insertInto: self.managedObjectContext)
        //Set attribute values
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        employee.setValue(firstName, forKey: "firstName")
        employee.setValue(lastName, forKey: "lastName")
        employee.setValue(formatter.date(from: sdString), forKey: "startDate")
        employee.setValue(formatter.date(from: dobString), forKey: "dateOfBirth")
        
        //Save context
        if !self.coreDataStack.saveContext(){
            print("Unable to create employee")
        }
    }
        
    func createDepartment(name: String){
        let department =
               NSEntityDescription.insertNewObject(forEntityName:
                  "Department", into: self.managedObjectContext)
        //Set attribute values
        department.setValue(name, forKey: "name")
        
        //Save context
        if !self.coreDataStack.saveContext(){
            print("Unable to create employee")
        }
    }
    
    func createRecords(){
        createEmployee(firstName: "John", lastName: "Holder", dobString: "02-23-1945", sdString: "01-01-2001")
        createEmployee(firstName: "Jane", lastName: "Miller", dobString: "12-23-1940", sdString: "03-25-2010")
        createEmployee(firstName: "Richard", lastName: "Smith", dobString: "03-23-1955", sdString: "04-01-2011")
        createEmployee(firstName: "Joseph", lastName: "Handle", dobString: "10-13-1965", sdString: "01-01-2006")
        createEmployee(firstName: "Mary", lastName: "Alderman", dobString: "06-21-1943", sdString: "01-01-1995")
        createEmployee(firstName: "Henry", lastName: "Rockbottom", dobString: "05-03-1970", sdString: "06-15-2012")
        createEmployee(firstName: "Bob", lastName: "Rocker", dobString: "03-23-1975", sdString: "04-01-2015")
        createEmployee(firstName: "Bill", lastName: "Riley", dobString: "10-13-1945", sdString: "01-01-2002")
        createEmployee(firstName: "Mary", lastName: "Bobbins", dobString: "06-21-1949", sdString: "01-01-1998")
        createEmployee(firstName: "Andrew", lastName: "Jobs", dobString: "05-03-1975", sdString: "06-15-2014")
        
        createDepartment(name:"Accounting")
        createDepartment(name:"Human Resource")
        createDepartment(name:"Production")
        createDepartment(name:"Research")
    }
    
    
    //Fetching records from store
    func fetchEmployees(_ predicate:NSPredicate)->[Employee]{
        var employees:[Employee] = []
        
        let fetchRequest:NSFetchRequest<Employee> = Employee.fetchRequest()
        fetchRequest.predicate = predicate
        
        do{
             employees = try self.managedObjectContext.fetch(fetchRequest)
        }
        catch let error as NSError{
            print("Could not save \(error),(error.userInfo)")
            return employees
        }
        
        return employees
    }
    
    
    
    //Fetching single records
    
    func getEmployee(_ firstName: String, lastName:String)->NSManagedObject{
        var employee:Employee!
        
        let fetchRequest:NSFetchRequest<Employee> = Employee.fetchRequest()
        
        let firstPredicate = NSPredicate(format: "firstName = %@", firstName)
        let secondPredicate = NSPredicate(format: "lastName = %@", lastName)
        let compoundPredicate = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: [firstPredicate,secondPredicate])
        fetchRequest.predicate = compoundPredicate
        
        do{
            let results = try self.managedObjectContext.fetch(fetchRequest)
            employee = results[0]
        }
        catch{
            let nserror = error as NSError
            print("Could not save \(nserror),(nserror.userInfo)")
        }
        return employee
    }
    
    func getDepartment(_ name: String)->NSManagedObject{
        var department:NSManagedObject!
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entityDescription = NSEntityDescription.entity(forEntityName: "Department", in: self.managedObjectContext)
        fetchRequest.entity = entityDescription
        
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate
        
        do{
            let results = try self.managedObjectContext.fetch(fetchRequest)
            department = results[0] as! NSManagedObject//results contains only one record
        }
        catch{
            let nserror = error as NSError
            print("Could not save \(nserror),(nserror.userInfo)")
        }
        return department
    }
    
    //Creating relationships
    func createToOneRelationship(){
        let employee1 = getEmployee("Jane", lastName: "Miller")
        let employee2 = getEmployee("Bill", lastName: "Riley")
        let employee3 = getEmployee("Bob", lastName: "Rocker")
        let department1 = getDepartment("Accounting")
        let department2 = getDepartment("Human Resource")
        let department3 = getDepartment("Production")
        department1.setValue(employee1, forKey: "manager")
        department2.setValue(employee2, forKey: "manager")
        department3.setValue(employee3, forKey: "manager")
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            print("Error creating relationship error:\(error)")
        }
    }
    
    func createToManyRelationship(){
        //Adding from One end
        let employee1 = getEmployee("John", lastName: "Holder")
        let employee2 = getEmployee("Mary", lastName: "Bobbins")
        let employee3 = getEmployee("Bill", lastName: "Riley")
        let department = getDepartment("Human Resource")
        employee1.setValue(department, forKey: "belongsTo")
        employee2.setValue(department, forKey: "belongsTo")
        employee3.setValue(department, forKey: "belongsTo")
        
        //Adding from Many end
        let employee4 = getEmployee("Jane", lastName: "Miller")
        let employee5 = getEmployee("Andrew", lastName: "Jobs")
        let employee6 = getEmployee("Joseph", lastName: "Handle")
        let department1 = getDepartment("Accounting")
        
        
        let employees1 = department1.mutableSetValue(forKey: "employees")
        employees1.add(employee4)
        employees1.add(employee5)
        employees1.add(employee6)
        
        
        let employee7 = getEmployee("Richard", lastName: "Smith")
        let employee8 = getEmployee("Mary", lastName: "Alderman")
        let employee9 = getEmployee("Henry", lastName: "Rockbottom")
        let employee10 = getEmployee("Bob", lastName: "Rocker")
        let department2 = getDepartment("Production")
        let employees2:NSMutableSet = department2.mutableSetValue(forKey: "employees")
        employees2.add(employee7)
        employees2.add(employee8)
        employees2.add(employee9)
        employees2.add(employee10)
        
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError {
            print("Error creating relationship error:\(error)")
        }
        
    }
    
}
