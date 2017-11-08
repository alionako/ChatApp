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
    var discoveryInfo : [String : String]
    let peerID = MCPeerID(displayName: UIDevice.current.name)
    
    var advertiser : MCNearbyServiceAdvertiser
    var browser : MCNearbyServiceBrowser
    
    var sessionsList : [String : MCSession]
    var peersList : [String : MCPeerID]
    
    var _online : Bool = false
    var _delegate : CommunicatorDelegate?
    
    override init() {
        
        if let appUserName = StorageManager.getAppUser()?.currentUser?.name {
            discoveryInfo = ["userName" : appUserName]
        } else {
            discoveryInfo = ["userName" : ""]
        }
        sessionsList = [:]
        peersList = [:]
        
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
        sessionsList = [:]
    }
    
    func sendMessage(string: String, to userID: String, completionHandler:
        ((_ success : Bool, _ error: Error?) -> ())?) {
        
        if let session = sessionsList[userID],
           let userPeerId = peersList[userID] {
            let data = string.data(using: .utf8)
            do {
                try session.send(data!, toPeers: [userPeerId], with: .reliable)
            } catch let error as NSError {
                print(error)
                if let handler = completionHandler {
                    handler(false, error)
                }
            }
        } else {
            if let handler = completionHandler {
                handler(false, "No session with this user found" as? Error)
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
        self.confirmInvitation(userPeerId: peerID, invitationHandler: invitationHandler)
    }
    
    private func confirmInvitation(userPeerId : MCPeerID, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let peer = self.getStringFromPeerId(userPeerId)
        if self.hasSessionWithPeer(peer) {
            invitationHandler(false, nil)
            return
        }
        let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        sessionsList[peer] = session
        peersList[peer] = userPeerId
        invitationHandler(true, session)
    }
}

extension MultipeerCommunicator : MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        self.startOrRetrieveSession(userPeerId: peerID)
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
    
    private func startOrRetrieveSession(userPeerId : MCPeerID) {
        let peer = getStringFromPeerId(userPeerId)
        if self.hasSessionWithPeer(peer) {
            return
        }
        let session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        browser.invitePeer(userPeerId, to: session, withContext: nil, timeout: 5.0)
        sessionsList[peer] = session
        peersList[peer] = userPeerId
    }
    
    func hasSessionWithPeer(_ peer: String) -> Bool {
        if let _ = sessionsList[peer] {
            return true
        }
        return false
    }
    
    func getStringFromPeerId(_ peerId: MCPeerID) -> String {
        return peerId.displayName
    }
}



extension MultipeerCommunicator : MCSessionDelegate {
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state.rawValue)")
        let userID = peerID.displayName
        switch (state) {
        case .connected:
            
            delegate?.didFoundUser(userID: userID, userName: peerID.displayName)
            break
        case .notConnected:
            delegate?.didLostUser(userID: userID)
            break
        default:
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }


    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("%@", "didFinishReceivingResourceWithName")
    }

}


