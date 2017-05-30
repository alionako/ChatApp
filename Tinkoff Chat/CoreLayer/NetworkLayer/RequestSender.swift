//
//  RequestSender.swift
//  Tinkoff Chat
//
//  Created by Aliona on 18/05/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import UIKit

class RequestSender : IRequestSender {
    
    let session = URLSession.shared
    
    func send(requestNumber: Int, completionHandler: @escaping (Result) -> Void) {
        let urlString = AdorableAvatarRequest().urlStringForId(requestNumber)
        
        guard let url = URL(string: urlString) else {
            return
        }

        let urlRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(Result.Fail(error.localizedDescription))
                return
            }
            guard let data = data else {
                completionHandler(Result.Fail("Request returned no data"))
                return
            }
            guard let img = UIImage(data: data) else {
                completionHandler(Result.Fail("Result is not an image"))
                return
            }
            completionHandler(Result.Success(img))
        }
        
        task.resume()
    }
}
