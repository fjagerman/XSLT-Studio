    //
    //  WebViewController.swift
    //  XSLT Studio
    //
    //  Created by Freek Jagerman on 03/01/2019.
    //  Copyright © 2019 Jagerman Services. All rights reserved.
    //
    
    import Cocoa
    import WebKit
    
    var outputText = "Welcome.\n"
    
    class WebViewController: NSViewController, WKUIDelegate, WKNavigationDelegate {
        
        //var delegate: feedBack?
        
        var myWebView: WKWebView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do view setup here.
            
            outputText += "0. WebViewController View loaded.\n"
            // freek NotificationCenter.default.post(name: Notification.Name(rawValue: notifyKeyOutput), object: self)
            let configuration = WKWebViewConfiguration()
            myWebView = WKWebView(frame: .zero, configuration: configuration)
            myWebView.translatesAutoresizingMaskIntoConstraints = false
            myWebView.navigationDelegate = self
            myWebView.uiDelegate = self
            view.addSubview(myWebView)
            // topAnchor only available in version 10.11
            [myWebView.topAnchor.constraint(equalTo: view.topAnchor),
             myWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             myWebView.leftAnchor.constraint(equalTo: view.leftAnchor),
             myWebView.rightAnchor.constraint(equalTo: view.rightAnchor)].forEach  {
                anchor in
                anchor.isActive = true
            }  // end forEach
            // let myURL = URL(string: "http://localhost:8042")
            let myURL = URL(string: "http://www.web3.lu/")
            let myRequest = URLRequest(url: myURL!)
            myWebView.load(myRequest)
        }  // end func
        
    }
