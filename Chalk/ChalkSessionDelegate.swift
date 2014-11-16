//
//  ChalkSessionDelegate.swift
//  Chalk
//
//  Created by Fernando on 15/11/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ChalkSessionDelegate {
    func peerDidConnect(peerID: MCPeerID)
    func peerWillDisconnect(peerID: MCPeerID)
    func didReceiveData(NSData,from: MCPeerID)
    func peerDisplayName() -> String
}
