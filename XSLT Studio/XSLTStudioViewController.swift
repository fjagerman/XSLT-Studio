            //
            //  ViewController.swift
            //  XSLT Studio
            //
            //  Created by Freek Jagerman on 27/12/2018.
            //  Copyright © 2018 Jagerman Services. All rights reserved.
            //
            
            import Cocoa
            import WebKit
            
            extension Notification.Name {
                static var XsltStudioDocumentChanged = Notification.Name("XsltStudioDocumentChanged")
            }
            
            class XSLTStudioViewController: NSSplitViewController {
                
                var xmlXml: XMLDocument?
                
                var document: Document! {
                    return representedObject as? Document
                }
                
                var tlvc: TopLeftViewController!
                // No need to unregister any old observer: by using the observer-propery we take care of this atomatically
                
                var blvc: BottomLeftViewController!
                var trvc: TopRightViewController!
                var brvc: BottomRightViewController!
                
                // MARK: - Notification Observer
                var docObserver: NSObjectProtocol? // Cookies to later “stop listening” with
                var topLeftObserver: NSObjectProtocol?
                var bottomLeftObserver: NSObjectProtocol?
                var topRightObserver:  NSObjectProtocol?
                
                // MARK: - LifeCycle
                override func viewDidLoad() {
                    super.viewDidLoad()
                    
                    // Do any additional setup after loading the view.
                }
                
                override func viewWillAppear() {
                    // Hook-up the four viewcontrollers
                    
                    if let lvc = splitViewItems[0].viewController as? NSSplitViewController {
                        tlvc = lvc.splitViewItems[0].viewController as? TopLeftViewController
                        // Assign observer for XML-changes
                        // (No need to unregister any old observer: by using the observer-propery we take care of this atomatically)
                        topLeftObserver = NotificationCenter.default.addObserver(
                            forName: Notification.Name.XsltStudioDocumentChanged, // the name of the radio station
                            object: tlvc, // the broadcaster is the topLeftViewController. This means the XML has changed
                            queue: OperationQueue.main // the queue on which to dispatch the closure below
                        ) { (notification: Notification) -> Void in // closure executed when broadcasts occur
                            if let newXml = self.tlvc.xmlInput?.stringValue {
                                if self.document.content?.xml != newXml {
                                    // actual user input: update and notify the document
                                    self.document.content?.xml = newXml
                                    self.tlvc.xmlInput.stringValue = self.document.content?.xml ?? ""
                                    self.refresh()
                                    self.document.updateChangeCount(.changeDone)
                                }
                            }
                        }
                        
                        blvc = lvc.splitViewItems[1].viewController as? BottomLeftViewController
                        // Set the whiteSpace checkbox according to the document
                        blvc.whiteSpaceCheckbox.state = NSControl.StateValue(rawValue: self.document.content!.preserveWhitespace ? 1 : 0)
                        
                        //Assign observer for XSLT-changes
                        bottomLeftObserver = NotificationCenter.default.addObserver(
                            forName: Notification.Name.XsltStudioDocumentChanged, // the name of the radio station
                            object: blvc, // the broadcaster is the bottomLeftViewController meaning: the XSLT has changed
                            queue: OperationQueue.main // the queue on which to dispatch the closure below
                        ) { (notification: Notification) -> Void in // closure executed when broadcasts occur
                            if let newXslt = self.blvc.xsltInput?.stringValue {
                                if self.document.content?.xslt != newXslt ||
                                    self.document.content?.preserveWhitespace != (self.blvc.whiteSpaceCheckbox.state.rawValue == 1)
                                {
                                    self.document.content!.preserveWhitespace = (self.blvc.whiteSpaceCheckbox.state.rawValue == 1)
                                    // actual user input: update and notify the document
                                    self.document.content!.xslt = newXslt
                                    self.refresh()
                                }
                            }
                        }
                        
                        if let rvc = splitViewItems[1].viewController as? NSSplitViewController {
                            trvc = rvc.splitViewItems[0].viewController as? TopRightViewController
                            // align the HTML checkbox with the document
                            trvc.htmlCheckbox.state = NSControl.StateValue(rawValue: self.document.content!.html ? 1 : 0)
                            
                            brvc = rvc.splitViewItems[1].viewController as? BottomRightViewController
                            // Restore the splitview sliders
                            if let content = self.document.content {
                                // Set middle divider
                                self.splitView.setPosition(content.middle * self.view.frame.width, ofDividerAt: 0)
                                // Set left divider
                                lvc.splitView.setPosition(content.left * self.view.frame.height, ofDividerAt: 0)
                                // Set right divider
                                rvc.splitView.setPosition(content.right * self.view.frame.height, ofDividerAt: 0)
                                
                                
                                refresh()
                                
                                topRightObserver = NotificationCenter.default.addObserver(
                                    forName: Notification.Name.XsltStudioDocumentChanged, // the name of the radio station
                                    object: trvc, // the broadcaster is the topRightViewController meaning the HTML checkbox has changed
                                    queue: OperationQueue.main // the queue on which to dispatch the closure below
                                ) { (notification: Notification) -> Void in // closure executed when broadcasts occur
                                    self.document.content!.html = (self.trvc.htmlCheckbox.state.rawValue == 1)
                                    rvc.splitView.setPosition(self.document.content!.right * self.view.frame.height, ofDividerAt: 0)
                                    self.refresh()
                                }
                            }
                        }
                    }
                }
                
                
                func refresh() {
                    if tlvc != nil && blvc != nil &&  trvc != nil && brvc != nil {
                        if let doc = document.content {
                            tlvc.xmlInput.stringValue = doc.xml
                            blvc.xsltInput.stringValue = doc.xslt
                            trvc.textView.string = doc.output
                            if doc.html {
                                brvc.webView.loadHTMLString(doc.html ? doc.output : "", baseURL: nil)
                            }
                            document.updateChangeCount(.changeDone)
                        }
                    }
                }
                
                
                override var representedObject: Any? {
                    didSet {
                        // Update the view, if already loaded.
                        // Pass down the represented object to all of the child view controllers.
                        // saple code provided tis loop, but we keep all logic in this viewcontoller:
                        if (representedObject as? Document) != nil {
                            print("It's a XsltStudioObject!")
                        }
                        /*
                         for child in children {
                         child.representedObject = representedObject
                         } */
                        
                        
                        self.refresh()
                        
                    }
                }
                
                // MARK: - SplitviewDelegate
                override func splitViewDidResizeSubviews(_ notification: Notification) {
                    // Update the slider-positions in content
                    if self.tlvc != nil {
                        self.document.content?.middle = tlvc.view.frame.width / view.frame.width
                        self.document.content?.left = tlvc.view.frame.height / view.frame.height
                        if trvc.htmlCheckbox.state.rawValue == 1 {
                            self.document.content?.right = trvc.view.frame.height / view.frame.height
                        }
                        self.document.updateChangeCount(.changeDone)
                    }
                }
            }
            
