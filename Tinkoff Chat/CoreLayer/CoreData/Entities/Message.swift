//
//  Message.swift
//  Tinkoff Chat
//
//  Created by Aliona on 30/05/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import CoreData

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
        var conversationExists = false
        if let fetchRequest = Conversation.fetchConversationById(model: model, conversationId: userId) {
            do {
                let results = try context.fetch(fetchRequest)
                if let foundConversation = results.first {
                    conversation = foundConversation
                    conversationExists = true
                }
            } catch {
                print("Failed to fetch Conversation \(error)")
            }
        }
        if !conversationExists {
            conversation = NSEntityDescription.insertNewObject(forEntityName: "Conversation", into: context) as? Conversation
            conversation?.conversationId = userId
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
