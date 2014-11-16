//
//  ChalkSession.swift
//  Chalk
//
//  Created by Fernando on 15/11/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ChalkSession: NSObject, MCSessionDelegate {
    
    var peers : [MCPeerID]
    let peerID : MCPeerID
    let delegate: ChalkSessionDelegate
    let serviceType = "Chalk-join"
    var session : MCSession!
    
    init(delegate: ChalkSessionDelegate)
    {
        self.delegate = delegate
        var peerName = delegate.peerDisplayName()
        self.peerID =  MCPeerID(displayName: peerName)
        self.peers = []
        super.init()
    }

    func startSession() -> MCSession
    {
        
        let discoverySession = MCSession(peer:self.peerID,
            securityIdentity:nil,
            encryptionPreference: MCEncryptionPreference.None)
        
        discoverySession.delegate = self
        
        return discoverySession
    }

    
    func discover() -> MCBrowserViewController
    {
        
        let browser = MCNearbyServiceBrowser(peer:self.peerID,serviceType:self.serviceType);
        
        self.session = self.startSession()
        
        let browserViewController = MCBrowserViewController(browser:browser,
            session:self.session!)
        
        return browserViewController
    }
    
    func advertise() -> MCNearbyServiceAdvertiser
    {
        let advertiser = MCNearbyServiceAdvertiser(peer:self.peerID,
                discoveryInfo:nil,
                serviceType:self.serviceType)
        advertiser.startAdvertisingPeer()
        return advertiser
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState)
    {
        //  MCSessionStateConnected—the nearby peer accepted the invitation and is now connected to the session.
        if(state == MCSessionState.Connected){
            self.peers.append(peerID)
            self.delegate.peerDidConnect(peerID)
        }
        //  MCSessionStateNotConnected—the nearby peer declined the invitation, the connection could not be established, or a previously connected peer is no longer connected.
        if(state == MCSessionState.NotConnected){
            self.delegate.peerWillDisconnect(peerID)
            self.peers = self.peers.filter {$0 != peerID}
        }
    }
    
    func sendData(data: NSData){
        var error : NSError?
        self.session!.sendData(data, toPeers: self.peers, withMode: MCSessionSendDataMode.Unreliable, error: &error)
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        self.delegate.didReceiveData(data,from: peerID)
    }
    
//MARK: - REQUIRED (send/receive NSURL + Stream)
    
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }

}

