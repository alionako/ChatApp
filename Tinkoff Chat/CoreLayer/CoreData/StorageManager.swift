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
    
    static func getContext() -> NSManagedObjectContext? {
        if let context = self.coreDataStack?.saveContext {
            return context
        }
        return nil
    }
    
    static func save(completion: Void) {
        if let context = self.coreDataStack?.saveContext, let coreDataStack = self.coreDataStack {
            coreDataStack.performSave(context: context, completionHandler: {
                print ("Saved results!")
                completion
            })
        } else {
            print ("Save failure!")
            completion
        }
    }
    
    static func getAppUser() -> AppUser? {
        if let context = self.coreDataStack?.saveContext {
            return self.findOrInsertAppUser(in:context)
        }
        return nil
    }
    
    static func getOnlineUsers() -> [User]? {
        
        guard let context = StorageManager.coreDataStack?.saveContext else {
            return nil 
        }
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert (false)
            return nil
        }
        var onlineUsers : [User]?
        guard let fetchRequest = User.fetchRequestOnlineUsers(model: model) else {
            return nil
        }
        
        do {
            onlineUsers = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch online users \(error)")
        }
        
        return onlineUsers
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
