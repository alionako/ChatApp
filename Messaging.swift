//
//  Messaging.swift
//  Tinkoff Chat
//
//  Created by Aliona on 05/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import MultipeerConnectivity


protocol Communicator {
    func sendMessage(string: String, to userID: String, completionHandler:
        ((_ success : Bool, _ error: Error?) -> ())?)
    weak var delegate : CommunicatorDelegate? {get set}
    var online : Bool {get set}
}

class MultipeerCommunicator : NSObject, Communicator {
    
    private let serviceType = "tinkoff-chat"
    private let peerID = MCPeerID(displayName: UIDevice.current.name)
    
    var _online : Bool
    var _delegate : CommunicatorDelegate?
    
    var advertiser : MCNearbyServiceAdvertiser
    var browser : MCNearbyServiceBrowser?
    
    var sessionsList : [MCSession]? = nil
    
    override init() {
        advertiser = MCNearbyServiceAdvertiser.init(peer: peerID, discoveryInfo: ["userName" : "Aliona"], serviceType: serviceType)
        _online = false
        super.init()
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
    
    func sendMessage(string: String, to userID: String, completionHandler:
        ((_ success : Bool, _ error: Error?) -> ())?) {
        let message = ["eventType": "TextMessage", "messageId": generateMessageId(), "text": string]
    }
    
    weak var delegate : CommunicatorDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }
    
    var online : Bool {
        get {
            return _online
        }
        set {
            _online = newValue
//            if newValue == true {
//                advertiser.startAdvertisingPeer()
//            } else {
//                advertiser.stopAdvertisingPeer()
//            }
        }
    }
}

extension MultipeerCommunicator : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
    }
}

class CommunicationManager : CommunicatorDelegate {
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
     
    }

    func failedToStartAdvertising(error: Error) {
        print("Failed to start advertising: \(error.localizedDescription)")
    }

    func failedToStartBrowsingForUsers(error: Error) {
        print("Failed to start browsing for users: \(error.localizedDescription)")
    }

    func didLostUser(userID: String) {
        
    }

    func didFoundUser(userID: String, userName: String?) {
    
    }
}

protocol CommunicatorDelegate : class {
    //discovering 
    func didFoundUser(userID : String, userName : String?)
    func didLostUser(userID : String)
    
    //errors 
    func failedToStartBrowsingForUsers(error : Error)
    func failedToStartAdvertising(error : Error)
    
    //messages 
    func didReceiveMessage(text: String, fromUser: String, toUser: String)
}

func generateMessageId() -> String {
    let string = "\(arc4random_uniform(UINT_FAST32_MAX))+\(Date.timeIntervalSinceReferenceDate)+\(arc4random_uniform(UINT_FAST32_MAX))".data(using: .utf8)?.base64EncodedString()
    return string!
}
