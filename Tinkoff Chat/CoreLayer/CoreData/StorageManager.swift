//
//  StorageManager.swift
//  Tinkoff Chat
//
//  Created by Aliona on 30/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import CoreData

class StorageManager {
    
    private static var _coreDataStack: CoreDataStack?
    public static var coreDataStack: CoreDataStack? {
        get {
            if _coreDataStack == nil {
                _coreDataStack = CoreDataStack.init()
            }
            return _coreDataStack
        }
    }
    
    static func getAppUser() -> AppUser? {
        if let context = self.coreDataStack?.saveContext {
            return self.findOrInsertAppUser(in:context)
        }
        return nil
    }
    
    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert (false)
            return nil
        }
        var appUser : AppUser?
        guard let fetchRequest = AppUser.fetchRequestAppUser(model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple users found!")
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUser \(error)")
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        
        return appUser
    }
    
    static func saveUserData(_ data: UserData?, success: Void) {
        if let saveContext = StorageManager.coreDataStack?.saveContext {
            if let appUser = (StorageManager.findOrInsertAppUser(in: saveContext))?.currentUser {
                if let name = data?.name {
                    appUser.name = name
                }
                if let about = data?.about {
                    appUser.about = about
                }
                StorageManager.coreDataStack?.performSave(context: (self.coreDataStack?.saveContext)!, completionHandler: {success})
            } else {
                print("Failed to get user")
            }
        }
    }
}
