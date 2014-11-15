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

    @IBOutlet weak var usernameField: UITextField?
    @IBOutlet weak var whiteboardView: WhiteboardView?
    @IBOutlet weak var spinner: UIActivityIndicatorView?
    @IBOutlet weak var browserSwitch : UISwitch?
    
    var whiteboardViewDelegate = WhiteboardShapeDelegate()
    var session : ChalkSession?
    var shouldBrowse : Bool = false
    
    override func viewDidAppear(animated: Bool) {
        usernameField?.becomeFirstResponder()
        self.spinner!.stopAnimating()
        self.usernameField!.alpha = 1.0
    }

    func presentWhiteboard()
    {
        self.usernameField?.hidden = true
        self.whiteboardView?.hidden = false;
        self.whiteboardView?.delegate = self.whiteboardViewDelegate
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!)
    {
        browserViewController.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!)
    {
        browserViewController.dismissViewControllerAnimated(true) { () -> Void in
        }
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
        textField.alpha = 0.4
        self.session = ChalkSession(delegate: self)
        self.shouldBrowse = !browserSwitch!.on
        let browser = session!.browse()
        browser.delegate = self
        if( shouldBrowse){
            self.presentViewController(browser, animated: true) { () -> Void in
            }
        }else{
            self.spinner!.startAnimating()
            let advertiser = session!.advertise()
        }
    }
    
}

