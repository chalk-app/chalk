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
    
    let peerID: MCPeerID
    let session: MCSession
    var peers : [MCPeerID]
    let delegate: ChalkSessionDelegate
    var advertiser : MCAdvertiserAssistant?
    
    init(username: String,delegate: ChalkSessionDelegate)
    {
        self.delegate = delegate
        self.peerID = MCPeerID(displayName: username)
        self.session = MCSession(peer: self.peerID)
        self.peers = []
        super.init()
        self.session.delegate = self
    }
    
    func openBrowser(){
        let browser = MCBrowserViewController(serviceType:"chat-files", session: self.session)

    }

    func start()
    {
        if let runnningAdvertiser = self.advertiser{
        }else{
            let mcAdvertiser = MCAdvertiserAssistant(serviceType: "ChalkSession", discoveryInfo: [NSObject : AnyObject](), session: self.session)
            mcAdvertiser.start()
            self.advertiser = mcAdvertiser
        }
    }
    
    func stop()
    {
        if let runnningAdvertiser = self.advertiser{
            runnningAdvertiser.stop()
            self.advertiser = nil
        }
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
        self.session.sendData(data, toPeers: self.peers, withMode: MCSessionSendDataMode.Unreliable, error: &error)
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

