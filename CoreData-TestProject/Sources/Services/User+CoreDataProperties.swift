//
//  User+CoreDataProperties.swift
//  CoreData-TestProject
//
//  Created by Мария Вольвакова on 23.08.2022.
//
//

import Foundation
import CoreData
import UIKit



@objc(User)
public class User: NSManagedObject {
    

    @NSManaged public var name: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var cityName: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var photo: Data?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
}
