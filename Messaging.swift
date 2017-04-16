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
    
    let serviceType : String = "tinkoff-chat"
    let discoveryInfo : [String : String]? = ["userName" : "Aliona"]
    let peerID = MCPeerID(displayName: UIDevice.current.name)
    
    var advertiser : MCNearbyServiceAdvertiser
    var browser : MCNearbyServiceBrowser
    
    var sessionsList : [String : MCSession]? = nil
    
    var _online : Bool = true
    var _delegate : CommunicatorDelegate?
    
    override init() {
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        browser = MCNearbyServiceBrowser(peer: MCPeerID(displayName: UIDevice.current.name), serviceType: serviceType)
        
        super.init()
        
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        
        browser.delegate = self
        browser.startBrowsingForPeers()
        
        _online = true
    }
    
    deinit {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
    func sendMessage(string: String, to userID: String, completionHandler:
        ((_ success : Bool, _ error: Error?) -> ())?) {
        let message = ["eventType": "TextMessage", "messageId": generateMessageId(), "text": string]
        let session : MCSession? = sessionsList?[userID]
        
        if (session != nil) && (session!.connectedPeers.count > 1) {
            do {
                try session?.send(string.data(using: .utf8)!, toPeers: (session?.connectedPeers)!, with: .unreliable)
            } catch let error {
                error
            }
        }
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
        }
    }
}

extension MultipeerCommunicator : MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
        self.delegate?.failedToStartAdvertising(error: error)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        
    }
}

extension MultipeerCommunicator : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        self.delegate?.didFoundUser(userID: peerID.displayName, userName: info?["userName"])
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
        self.delegate?.didLostUser(userID: peerID.displayName)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
        self.delegate?.failedToStartAdvertising(error: error)
    }
}

class CommunicationManager : CommunicatorDelegate {
    
    var contactListViewController : ConversationsListViewController? = nil
    var contactList : [String : String?]? = nil
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        contactListViewController?.showAlertWithText("Ого, сообщение!!! Текст сообщения: \(text)")
    }
    
    func failedToStartAdvertising(error: Error) {
        contactListViewController?.showAlertWithText("Не удалось включить обнаружение другими устройствами!")
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        contactListViewController?.showAlertWithText("Не удалось начать поиск пользователей!")
    }
    
    func didLostUser(userID: String) {
        contactList?.removeValue(forKey: userID)
        contactListViewController?.contactTable.reloadData()
    }
    
    func didFoundUser(userID: String, userName: String?) {
        contactList = [userID : userName]
        contactListViewController?.contactList = contactList!
        contactListViewController?.contactTable.reloadData()
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
