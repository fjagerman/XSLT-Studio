//
//  BotomRightViewController.swift
//  XSLT Studio
//
//  Created by Freek Jagerman on 02/01/2019.
//  Copyright © 2019 Jagerman Services. All rights reserved.
//

import Cocoa
import WebKit

class BottomRightViewController: NSViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    
    var docObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        if document.content!.html {
            webView.loadHTMLString(document.content!.output, baseURL: nil)
        }
        
        docObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name.XsltStudioDocumentChanged, // the name of the radio station
            object: nil, // the broadcaster is the topRightViewController meaning the HTML checkbox has changed
            queue: OperationQueue.main // the queue on which to dispatch the closure below
        ) { (notification: Notification) -> Void in // closure executed when broadcasts occur
            if self.document.content!.html {
                self.webView.loadHTMLString(self.document.content!.output, baseURL: nil)
            }
        }
    }
    
    var document: Document! {
        return representedObject as? Document
    }
}
