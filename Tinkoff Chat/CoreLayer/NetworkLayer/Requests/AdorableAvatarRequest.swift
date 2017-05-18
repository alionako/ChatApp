//
//  AdorableAvatarRequest.swift
//  Tinkoff Chat
//
//  Created by Aliona on 17/05/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import Foundation

class AdorableAvatarRequest: IRequest {
    private var baseUrl: String =  "https://api.adorable.io/avatars/"
    
    // MARK: - IRequest
    func urlStringForId(_ id: Int) -> String {
        return "\(baseUrl)\(id)"
    }
}
