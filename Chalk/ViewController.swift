//
//  ViewController.swift
//  Chalk
//
//  Created by Alexander Ignatenko on 15/11/14.
//  Copyright (c) 2014 Alexander Ignatenko. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, ChalkSessionDelegate, MCBrowserViewControllerDelegate, UITextFieldDelegate, MCNearbyServiceAdvertiserDelegate {

    @IBOutlet weak var usernameField: UITextField?
    @IBOutlet weak var whiteboardView: WhiteboardView?
    @IBOutlet weak var spinner: UIActivityIndicatorView?
    @IBOutlet weak var joinButton : UIButton?
    
    var whiteboardViewDelegate = WhiteboardShapeDelegate()
    var session : ChalkSession?
    var shouldBrowse : Bool = false
    
    override func viewDidAppear(animated: Bool) {
        usernameField?.becomeFirstResponder()
        self.spinner!.stopAnimating()
        self.whiteboardView!.backgroundColor = UIColor.lightGrayColor()
    }

    func presentWhiteboard()
    {
        self.spinner!.stopAnimating()
        self.usernameField?.enabled = false
        self.whiteboardView!.backgroundColor = UIColor.whiteColor()
        self.whiteboardView!.userInteractionEnabled = true
        self.whiteboardView!.delegate = self.whiteboardViewDelegate
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }

    func textFieldDidEndEditing(textField: UITextField)
    {
        self.presentWhiteboard()
        self.session = ChalkSession(delegate: self)
        self.advertise()
    }
    
    @IBAction func joinWasPressed()
    {
        self.whiteboardView!.backgroundColor = UIColor.lightGrayColor()
        self.whiteboardView!.userInteractionEnabled = false
        self.spinner!.startAnimating()
        self.discover()
    }
    
    func advertise()
    {
        let advertiser = self.session!.advertise()
        advertiser.delegate = self;
    }
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didReceiveInvitationFromPeer peerID: MCPeerID!, withContext context: NSData!, invitationHandler: ((Bool, MCSession!) -> Void)!) {
        
        let alertController = UIAlertController(title: "Did Receiver Invitation From Peer", message: "\(peerID.displayName)", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            invitationHandler(false,nil)
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            let basicSession = self.session!.startSession()
            invitationHandler(true,basicSession)
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) { () -> Void in
            
        }
    }
    
        
    func advertiser(advertiser: MCNearbyServiceAdvertiser!, didNotStartAdvertisingPeer error: NSError!) {
    
    }
    
    func discover()
    {
        let browserVC = self.session!.discover()
        browserVC.delegate = self;
        self.presentViewController(browserVC,
            animated:true,
            completion:{()->Void in
                    browserVC.browser.startBrowsingForPeers()
        })
    }
    
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!)
    {
        browserViewController.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!)
    {
        browserViewController.dismissViewControllerAnimated(true) { () -> Void in
            self.presentWhiteboard()
        }
    }
    
    func peerDisplayName() -> String{
        if(self.usernameField!.text.isEmpty){
            return UIDevice.currentDevice().name
        }else{
            return self.usernameField!.text
        }
    }

    func peerDidConnect(peerID: MCPeerID)
    {
        let data = self.whiteboardViewDelegate.snapshot()
        self.session!.sendData(data)
    }
    
    func peerWillDisconnect(peerID: MCPeerID)
    {
        
    }
    
    func didReceiveData(NSData,from: MCPeerID)
    {
        //TODO:
        //Convert back to shapes and initialize/update the whiteboard!!
    }

    
}

