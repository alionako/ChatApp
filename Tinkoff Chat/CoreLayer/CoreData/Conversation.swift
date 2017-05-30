//
//  Conversation.swift
//  Tinkoff Chat
//
//  Created by Aliona on 30/05/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import CoreData

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
