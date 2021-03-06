//
//  ConnectionManager.swift
//  PingPongHero
//
//  Created by Hariel Giacomuzzi on 7/22/15.
//  Copyright (c) 2015 Hariel Giacomuzzi. All rights reserved.
//

import Foundation
import MultipeerConnectivity



class ConnectionManager: NSObject, MCSessionDelegate{
    var peerID: MCPeerID = MCPeerID();
    var session: MCSession = MCSession();
    var browser: MCBrowserViewController?;
    var advertiser: MCAdvertiserAssistant = MCAdvertiserAssistant();
    static let sharedInstance = ConnectionManager();
    
    func setupConnectionWithOptions(displayName : String, active : Bool){
        setupPeerWithDisplayName(displayName);
        setupSession();
        advertiseSelf(active);
    }
    
    func setupPeerWithDisplayName (displayName:String){
        peerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession(){
        session = MCSession(peer: peerID)
        session.delegate = self
    }
    
    func setupBrowser(){
        browser = MCBrowserViewController(serviceType: "pingponghero", session: session)
    }
    
    func advertiseSelf(advertise:Bool){
        if advertise{
            advertiser = MCAdvertiserAssistant(serviceType: "pingponghero", discoveryInfo: nil, session: session)
            advertiser.start()
        }else{
            advertiser.stop()
            advertiser = MCAdvertiserAssistant();
        }
        
    }
    
    // Remote peer changed state
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState){
        let userInfo = ["peerID":peerID, "state":state.rawValue]
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_ConnectionStatusChanged", object: nil, userInfo: userInfo)
        })
    }
    
    // Received data from remote peer
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!){
        let userInfo = ["data":data, "peerID":peerID]
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("ConnectionManager_DataReceived", object: nil, userInfo: userInfo)
        })
    }
    
    // Received a byte stream from remote peer
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!){
    
    }
    
    // Start receiving a resource from remote peer
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!){
    
    }
    
    // Finished receiving a resource from remote peer and saved the content in a temporary location - the app is responsible for moving the file to a permanent location within its sandbox
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!){
    
    }
    
}