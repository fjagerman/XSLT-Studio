//
//  RefGuideWindowController.swift
//  XSLT Studio
//
//  Created by Freek Jagerman on 26/02/2020.
//  Copyright © 2020 Jagerman Services. All rights reserved.
//

import Cocoa
import WebKit

class RefGuideWindowController: NSWindowController { //}, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
//    override func loadWindow() {
//                let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        //webView.uiDelegate = self
//        //view = webView
//    }
    override func windowDidLoad() {
        
        super.windowDidLoad()
        
        let myURL = URL(fileReferenceLiteralResourceName: "XSL Transformations (XSLT).html")
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
    
}
