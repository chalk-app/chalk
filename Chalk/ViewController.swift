//
//  ViewController.swift
//  Chalk
//
//  Created by Alexander Ignatenko on 15/11/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, ChalkSessionDelegate, MCBrowserViewControllerDelegate {

    var session : ChalkSession!
    
    func username() -> String
    {
        return "ChalkUser"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.session = ChalkSession(username: self.username(), delegate: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        browseForDevices()
    }
    
    func browseForDevices()
    {
        session.browser.delegate = self
        self.presentViewController(session.browser, animated: true) { () -> Void in
        }
    }
    
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!)
    {
        session.browser.delegate = nil
        
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!)
    {
    }
    
    
    func peerDidConnect(peerID: MCPeerID)
    {
    }
    
    func peerWillDisconnect(peerID: MCPeerID)
    {
    
    }
    
    func didReceiveData(NSData,from: MCPeerID)
    {
    }
    
}

