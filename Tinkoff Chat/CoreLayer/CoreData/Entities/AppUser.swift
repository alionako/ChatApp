//
//  AppUser.swift
//  Tinkoff Chat
//
//  Created by Aliona on 30/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import CoreData

extension AppUser {
    static func fetchRequestAppUser(model: NSManagedObjectModel) -> NSFetchRequest<AppUser>? {
        let templateName = "AppUser"
        guard let fetchRequest = model.fetchRequestTemplate(forName: templateName) as? NSFetchRequest<AppUser> else {
            assert(false, "No template with name \(templateName)!")
            return nil
        }
        return fetchRequest
    }
    
    static func insertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        if let appUser = NSEntityDescription.insertNewObject(forEntityName: "AppUser", into: context) as? AppUser {
            if appUser.currentUser == nil {
                let currentUser = User.findOrInsertUser(withId: User.generateUserIdString(), in: context)
                currentUser?.name = User.generateCurrentUserNameString()
                appUser.currentUser = currentUser
            }
            return appUser
        }
        return nil
    }
}
