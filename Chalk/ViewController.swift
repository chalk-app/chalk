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
    
    @IBOutlet weak var usernameField: UITextField?
    @IBOutlet weak var whiteboardView: WhiteboardView?
    var whiteboardViewDelegate = WhiteboardShapeDelegate()
    
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
        self.session.browser.delegate = self
        self.presentViewController(session.browser, animated: true) { () -> Void in
            self.session.start()
        }
    }
    
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!)
    {
        session.browser .dismissViewControllerAnimated(true) { () -> Void in
            self.session.stop()
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
        self.session = ChalkSession(username: textField.text, delegate: self)
        self.browseForDevices()
    }

    
}

