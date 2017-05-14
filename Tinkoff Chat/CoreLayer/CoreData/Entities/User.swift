//
//  User.swift
//  Tinkoff Chat
//
//  Created by Aliona on 30/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import CoreData

extension User {
    
    static func generateUserIdString() -> String {
        return "id_test"
    }
    
    static func generateCurrentUserNameString() -> String {
        return "Test username"
    }
    
    
    static func findOrInsertUser(with: String, in context: NSManagedObjectContext) -> User? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert (false)
            return nil
        }
        var user : User?
        guard let fetchRequest = User.fetchRequestUserById(model: model, id: with) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple users found!")
            if let foundUser = results.first {
                user = foundUser
            }
        } catch {
            print("Failed to fetch User \(error)")
        }
        
        if user == nil {
            user = User.insertAppUser(in: context)
        }
        
        return user
    }
    
    static func insertAppUser(in context: NSManagedObjectContext) -> User? {
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
        user?.name = "Name"
        return user
    }
    
    static func saveUser(id: String, name: String, completion: Void) -> User? {
        guard let context = StorageManager.getContext() else {
            print ("Failed to retrieve save context")
            completion
            return nil
        }
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert (false)
            completion
            return nil
        }
        var user : User?
        if let fetchRequest = User.fetchRequestUserById(model: model, id: id) {
            do {
                let results = try context.fetch(fetchRequest)
                //assert(results.count < 2, "Multiple users found!")
                if let foundUser = results.first {
                    user = foundUser
                    if user?.name == name && user?.isOnline == true { return foundUser }
                    user?.name = name
                    user?.isOnline = true
                }
            } catch {
                print("Failed to fetch User \(error)")
            }
        }

        if user == nil {
            user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
            user?.name = name
            user?.userId = id
            user?.isOnline = true
        }
        StorageManager.save(completion: completion)
        return user
    }
    
    static func fetchRequestUserById(model: NSManagedObjectModel, id: String) -> NSFetchRequest<User>? {
        let templateName = "UserById"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["id" : id]) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        return fetchRequest
    }
    
    static func fetchRequestOnlineUsers(model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        let templateName = "OnlineUsers"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        return fetchRequest.copy() as? NSFetchRequest<User>
    }
 
}
