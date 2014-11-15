//
//  ViewController.swift
//  Chalk
//
//  Created by Alexander Ignatenko on 15/11/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, ChalkSessionDelegate, MCBrowserViewControllerDelegate, UITextFieldDelegate {

    var session : ChalkSession!
    
    var username = "ChalkUser"
    
    @IBOutlet weak var usernameField: UITextField?
    @IBOutlet weak var whiteboardView: WhiteboardView?
    var whiteboardViewDelegate = WhiteboardShapeDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.session = ChalkSession(username: self.username, delegate: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        usernameField?.becomeFirstResponder()
    }

    func presentWhiteboard()
    {
        self.usernameField?.hidden = true
        self.whiteboardView?.hidden = false;
        self.whiteboardView?.delegate = self.whiteboardViewDelegate
    }
    
    func browseForDevices()
    {
        session.browser.delegate = self
        self.presentViewController(session.browser, animated: true) { () -> Void in
        }
    }
    
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!)
    {
        session.browser .dismissViewControllerAnimated(true) { () -> Void in
            
        }
        session.browser.delegate = nil
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!)
    {
        session.browser .dismissViewControllerAnimated(true) { () -> Void in
            
        }
        session.browser.delegate = nil
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
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        self.username = textField.text
        self.browseForDevices()
    }

    
}

