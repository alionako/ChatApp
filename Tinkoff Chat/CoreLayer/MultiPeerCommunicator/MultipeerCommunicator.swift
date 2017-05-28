//
//  MultipeerCommunicator.swift
//  Tinkoff Chat
//
//  Created by Aliona on 05/04/2017.
//  Copyright © 2017 Aliona. All rights reserved.
//

import MultipeerConnectivity

class MultipeerCommunicator : NSObject, Communicator {
    
    let serviceType : String = "tinkoff-chat"
    var discoveryInfo : [String : String]? = nil
    let peerID = MCPeerID(displayName: UIDevice.current.name)
    
    var advertiser : MCNearbyServiceAdvertiser
    var browser : MCNearbyServiceBrowser
    
    var sessionsList : [String : MCSession]? = nil
    
    var _online : Bool = false
    var _delegate : CommunicatorDelegate?
    
    override init() {
        
        if let appUserName = StorageManager.getAppUser()?.currentUser?.name {
            discoveryInfo = ["userName" : appUserName]
        } else {
            discoveryInfo = ["userName" : ""]
        }
        
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        
        super.init()
        
        browser.delegate = self
        browser.startBrowsingForPeers()
        
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
        
        _online = true
    }
    
    deinit {
        advertiser.stopAdvertisingPeer()
        browser.stopBrowsingForPeers()
    }
    
    func sendMessage(string: String, to userID: String, completionHandler:
        ((_ success : Bool, _ error: Error?) -> ())?) {
        _ = ["eventType": "TextMessage", "messageId": MessageIdGenerator.generateMessageId(), "text": string]
        let session : MCSession? = sessionsList?[userID]
        
        if (session != nil) && (session!.connectedPeers.count > 1) {
            do {
                try session?.send(string.data(using: .utf8)!, toPeers: (session?.connectedPeers)!, with: .unreliable)
            } catch let error {
                print(error)
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


