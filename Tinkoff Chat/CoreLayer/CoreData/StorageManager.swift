//
//  StorageManager.swift
//  Tinkoff Chat
//
//  Created by Aliona on 30/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import CoreData
import UIKit

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
    
    static func getImageForUserWithId(_ userId: String?) -> UIImage? {
        if let id = userId, let context = self.coreDataStack?.saveContext {
            guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
                print("Model is not available in context!")
                assert (false)
                return nil
            }
            guard let fetchRequest = User.fetchRequestUserImage(model: model, userId: id) else {
                return nil
            }
            
            do {
                let results = try context.fetch(fetchRequest)
                if let foundImage = results.first {
                    if let userImageData = foundImage.content {
                        return UIImage(data: userImageData as Data)
                    }
                }
            } catch {
                print("Failed to fetch UserImage \(error)")
            }
        }
        return nil
    }
    
    static func getUsers() -> [User]? {
        
        guard let context = StorageManager.coreDataStack?.saveContext else {
            return nil 
        }
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert (false)
            return nil
        }
        var users : [User]?
        guard let fetchRequest = User.fetchRequestUsers(model: model) else {
            return nil
        }
        
        do {
            users = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch online users \(error)")
        }
        
        return users
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
    
    static func createOrUpdateImage(_ inContext: NSManagedObjectContext, forUserId: String, img: UIImage) -> Image? {
        guard let model = inContext.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert (false)
            return nil
        }
        var userImage : Image?
        guard let fetchRequest = User.fetchRequestUserImage(model: model, userId: forUserId) else {
            return nil
        }
        
        do {
            let results = try inContext.fetch(fetchRequest)
            if let foundImage = results.first {
                userImage = foundImage
            }
        } catch {
            print("Failed to fetch UserImage \(error)")
        }
        
        if userImage == nil {
            userImage = User.insertImage(in: inContext, forUserId: forUserId)
        }
        
        userImage?.content = UIImagePNGRepresentation(img) as NSData?
        
        return userImage
    }
    
    static func saveUserData(_ data: UserData?, success: Void) {
        if let saveContext = StorageManager.coreDataStack?.saveContext {
            if let appUser = (StorageManager.findOrInsertAppUser(in: saveContext))?.currentUser {
                print ("\(appUser)")
                if let name = data?.name {
                    appUser.name = name
                }
                if let about = data?.about {
                    appUser.about = about
                }
                if  let image = data?.image,
                    let userId = appUser.userId {
                    let _ = StorageManager.createOrUpdateImage(saveContext, forUserId: userId, img: image)
                }
                StorageManager.coreDataStack?.performSave(context: saveContext, completionHandler: {success})
            } else {
                print("Failed to get user")
            }
        }
    }
}
