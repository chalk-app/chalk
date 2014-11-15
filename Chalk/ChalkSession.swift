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
    let delegate: ChalkSessionDelegate
    let serviceType = "ChalkSession"
    var session : MCSession?
    
    init(delegate: ChalkSessionDelegate)
    {
        self.delegate = delegate
        self.peers = []
        super.init()
    }

    func browse() -> MCBrowserViewController
    {
        let peerID =  MCPeerID(displayName: UIDevice.currentDevice().name )
        session = MCSession(peer: peerID)
        session!.delegate = self
        let browser = MCBrowserViewController(serviceType: self.serviceType, session: session)
        return browser
    }
    
    func advertise() -> MCAdvertiserAssistant
    {
        let advertiser = MCAdvertiserAssistant(serviceType:self.serviceType
                , discoveryInfo:nil, session: session)
        advertiser.start()
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

