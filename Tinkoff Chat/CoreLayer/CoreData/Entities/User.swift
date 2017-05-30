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
    
    
    static func findOrInsertUser(withId: String, in context: NSManagedObjectContext) -> User? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert (false)
            return nil
        }
        var user : User?
        guard let fetchRequest = User.fetchRequestUserById(model: model, id: withId) else {
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
            user = User.insertAppUser(in: context, id: withId)
        }
        
        return user
    }
    
    static func insertAppUser(in context: NSManagedObjectContext, id: String) -> User? {
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User
        user?.name = "Name"
        user?.userId = id
        let image = NSEntityDescription.insertNewObject(forEntityName: "Image", into: context) as? Image
        image?.user = user
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
    
    static func changeUserState(userId: String, online: Bool, completion: Void) {
        guard let context = StorageManager.getContext() else {
            print ("Failed to retrieve save context")
            completion
            return
        }
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert (false)
            completion
            return
        }
        if let fetchRequest = User.fetchRequestUserById(model: model, id: userId) {
            do {
                let results = try context.fetch(fetchRequest)
                if let foundUser = results.first {
                    foundUser.isOnline = online
                }
            } catch {
                print("Failed to fetch User \(error)")
                completion
            }
        }
        StorageManager.save(completion: completion)
    }
    
    static func fetchRequestUserById(model: NSManagedObjectModel, id: String) -> NSFetchRequest<User>? {
        let templateName = "UserById"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["id" : id]) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        return fetchRequest
    }
    
    static func fetchRequestUserImage(model: NSManagedObjectModel, userId: String) -> NSFetchRequest<Image>? {
        let templateName = "ImageForUser"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["id" : userId]) as? NSFetchRequest<Image> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        return fetchRequest
    }
    
    static func fetchRequestUsers(model: NSManagedObjectModel) -> NSFetchRequest<User>? {
        let templateName = "Users"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<User> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        return fetchRequest.copy() as? NSFetchRequest<User>
    }
    
    static func insertImage(in context: NSManagedObjectContext, forUserId: String) -> Image? {
        if let image = NSEntityDescription.insertNewObject(forEntityName: "Image", into: context) as? Image {
            if let user = User.findOrInsertUser(withId: forUserId, in: context) {
                image.user = user
            }
            return image
        }
        return nil
    }
 
}


extension Message {
    static func fetchRequestMessages(model: NSManagedObjectModel, conversationId: String) -> NSFetchRequest<Message>? {
        let templateName = "MessagesForConversation"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["id" : conversationId]) as? NSFetchRequest<Message> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        return fetchRequest.copy() as? NSFetchRequest<Message>
    }
    
    static func saveMessage(userId: String, text: String, sentByAppUser: Bool, completion: Void) {
        guard let context = StorageManager.getContext() else {
            print ("Failed to retrieve save context")
            completion
            return
        }
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert (false)
            completion
            return
        }
        
        var conversation : Conversation?
        if let fetchRequest = Conversation.fetchConversationById(model: model, conversationId: userId) {
            do {
                let results = try context.fetch(fetchRequest)
                if let foundConversation = results.first {
                    conversation = foundConversation
                } else {
                    conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation
                    conversation?.conversationId = userId
                }
            } catch {
                print("Failed to fetch Conversation \(error)")
            }
        }
        
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as? Message
        message?.conversation = conversation
        message?.date = NSDate()
        message?.sentByAppUser = sentByAppUser
        message?.text = text
        message?.messageId = "\(NSDate().timeIntervalSinceReferenceDate)"
        
        StorageManager.save(completion: completion)
    }
}

extension Conversation {
    static func fetchConversationById(model: NSManagedObjectModel, conversationId: String) -> NSFetchRequest<Conversation>? {
        let templateName = "ConversationById"
        guard let fetchRequest = model.fetchRequestFromTemplate(withName: templateName, substitutionVariables: ["id" : conversationId]) as? NSFetchRequest<Conversation> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        return fetchRequest.copy() as? NSFetchRequest<Conversation>
    }
}
