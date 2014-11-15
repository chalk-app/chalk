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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.session = ChalkSession(username: self.username, delegate: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        usernameField?.becomeFirstResponder()
    }

    func presentWhiteboard()
    {
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }

    
    func textFieldDidEndEditing(textField: UITextField)
    {
        self.username = textField.text
        self.browseForDevices()
    }

    
}

