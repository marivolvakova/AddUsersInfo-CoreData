//
//  CoreDataStack.swift
//  CoreData-TestProject
//
//  Created by Мария Вольвакова on 23.08.2022.
//
import CoreData

// MARK: - CoreDataProtocol

protocol CoreDataProtocol: AnyObject {

    var users: [User]? { get }

    func saveNewUser(name: String)
    func getUsers() -> [User]?
    func deleteUser(user: User)
    func saveDetailedInfo(user: User, newName: String?, newCityName: String?, newDateOfBirth: String?, newPhoneNumber: String?, newPhoto: Data?)
}

// MARK: - CoreDataService

class CoreDataService: CoreDataProtocol{
    
    static let sharedManager = CoreDataService()
    
    var users: [User]? {
        return getUsers()
    }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Users")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context = persistentContainer.viewContext
    
    // MARK: - Functions
    
    func getUsers() -> [User]? {
        do {
            let request = User.fetchRequest() as NSFetchRequest<User>
            let users = try context.fetch(request)
            return users
        } catch {
            print(error)
            return nil
        }
    }
    
    func saveNewUser(name: String) {
        let newUser = User(context: context)
        newUser.name = name
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func deleteUser(user: User) {
        context.delete(user)
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func saveDetailedInfo(user: User, newName: String?, newCityName: String?, newDateOfBirth: String?, newPhoneNumber: String?, newPhoto: Data?) {
        
        if let newName = newName {
            user.name = newName
        }

        if let newDateOfBirth = newDateOfBirth {
            user.dateOfBirth = newDateOfBirth.convertToDate()
        }

        if let newCityName = newCityName {
            user.cityName = newCityName
        }

        if let newPhoneNumber = newPhoneNumber {
            user.phoneNumber = newPhoneNumber
        }
        
        if let newPhoto = newPhoto {
            user.photo = newPhoto
        }

        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}

// MARK: - Core Data Saving support

extension CoreDataService {
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
