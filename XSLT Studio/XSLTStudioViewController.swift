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
                
                var document: Document? {
                    return representedObject as? Document
                }
                
                var tlvc: TopLeftViewController!
                // No need to unregister any old observer: by using the observer-propery we take care of this atomatically
                
                var blvc: BottomLeftViewController!
                var trvc: TopRightViewController!
                var brvc: BottomRightViewController!
                
                // MARK: - Outlets
                //@IBOutlet weak var leftSplitview: NSSplitView!
                //@IBOutlet weak var rightSplitview: NSSplitViewItem!
                
                // MARK: - LifeCycle
                override func viewDidLoad() {
                    super.viewDidLoad()
                    
                    // Do any additional setup after loading the view.
                }
                // MARK: - Notification Observer
                var docObserver: NSObjectProtocol? // a cookie to later “stop listening” with
                var topLeftObserver: NSObjectProtocol? // a cookie to later “stop listening” with
                var bottomLeftObserver: NSObjectProtocol? // a cookie to later “stop listening” with
                
                override func viewWillAppear() {
                    // Hook-up the four viewcontrollers
                    
                    if let lvc = splitViewItems[0].viewController as? NSSplitViewController {
                        tlvc = lvc.splitViewItems[0].viewController as? TopLeftViewController
                        // Assign observer for XML-changes
                        // (No need to unregister any old observer: by using the observer-propery we take care of this atomatically)
                        topLeftObserver = NotificationCenter.default.addObserver(
                            forName: Notification.Name.XsltStudioDocumentChanged, // the name of the radio station
                            object: tlvc, // the broadcaster is the topLeftViewController. This  means: the XML has changed
                            queue: OperationQueue.main // the queue on which to dispatch the closure below
                        ) { (notification: Notification) -> Void in // closure executed when broadcasts occur
                            if let newval = self.tlvc.xmlInput?.stringValue {
                                if self.document?.content?.xml != newval {
                                    // actual user input: update and notify the document
                                    self.document?.content?.xml = newval
                                    self.refresh()
                                    self.document?.updateChangeCount(.changeDone)
                                }
                            }
                        }
                        
                        blvc = lvc.splitViewItems[1].viewController as? BottomLeftViewController
                        
                        //Assign observer for XSLT-changes
                        bottomLeftObserver = NotificationCenter.default.addObserver(
                            forName: Notification.Name.XsltStudioDocumentChanged, // the name of the radio station
                            object: blvc, // the broadcaster is the topLeftViewController. This  means: the XML has changed
                            queue: OperationQueue.main // the queue on which to dispatch the closure below
                        ) { (notification: Notification) -> Void in // closure executed when broadcasts occur
                            if let newval = self.blvc.xsltInput?.stringValue {
                                if self.document?.content?.xslt != newval {
                                    // actual user input: update and notify the document
                                    self.document?.content?.xslt = newval
                                    self.refresh()
                                    self.document?.updateChangeCount(.changeDone)
                                }
                            }
                        }
                        
                        if let rvc = splitViewItems[1].viewController as? NSSplitViewController {
                            trvc = rvc.splitViewItems[0].viewController as? TopRightViewController
                            brvc = rvc.splitViewItems[1].viewController as? BottomRightViewController
                            if let content = self.document?.content {
                                // Set middle divider
                                self.splitView.setPosition(content.middle * self.view.frame.width, ofDividerAt: 0)
                                // Set left divider
                                lvc.splitView.setPosition(content.left * self.view.frame.height, ofDividerAt: 0)
                                // Set right divider
                                rvc.splitView.setPosition(content.right * self.view.frame.height, ofDividerAt: 0)
                                refresh()
                            }
                        }
                    }
                }
                
                
                // This is where all the magic happens:
                func refresh() {
                    if let xmlString = document?.content?.xml, let xsltString = document?.content?.xslt {
                        tlvc.xmlInput.stringValue = xmlString
                        blvc.xsltInput.stringValue = xsltString
                        do {
                            xmlXml = try XMLDocument(xmlString: xmlString, options: .documentTidyXML)
                            if let st = xmlXml?.xmlString(options: .nodePrettyPrint ) {
                                // Overwrite top left with PrettyPrinted version
                                tlvc.xmlInput.stringValue = st
                            }
                            do {
                                let xsltXml = try XMLDocument(xmlString: xsltString, options: [.documentTidyXML, .nodePreserveWhitespace] )
                                // Overwrite bottom right with PrettyPrindet version (may cause cleanup of the xslt)
                                blvc.xsltInput.stringValue = xsltXml.xmlString(options: [.nodePrettyPrint, .nodeCompactEmptyElement] )
                                // Attempt to get rid of the selected text
                                blvc.xsltInput.resignFirstResponder()
                                let xsltCompact = xsltXml.xmlString(options: .nodePreserveWhitespace )
                                if trvc != nil && brvc != nil && document?.content?.xslt != nil {
                                    if let xml = xmlXml {
                                        do {
                                            if let xmlAfterXSLT = try xml.object(byApplyingXSLTString: xsltCompact, arguments: ["author": "Freek"]) as? XMLDocument {
                                                // Causing xsl:version: only 1.0 features are supported
                                                trvc.textView.string = xmlAfterXSLT.xmlString(options: [.nodePrettyPrint, .nodeCompactEmptyElement, .nodePreserveWhitespace] )
                                                //webView.loadHTMLString(st, baseURL: nil)
                                                //TODO: insert the CSS for dark mode:
                                                /*
                                                 <style>
                                                 :root {
                                                 color-scheme: light dark;
                                                 }
                                                 </style>
                                                 */
                                                self.brvc.webView.loadHTMLString(xmlAfterXSLT.xmlString(options: [.documentTidyHTML, .nodePreserveWhitespace, .nodeCompactEmptyElement]), baseURL: nil)
                                            }
                                        }
                                        catch {
                                            print("Object by applying XSLT string failed: \(error)")
                                            self.trvc.textView.string = "XSLT is not valid: \(error)"
                                            self.brvc.webView.loadHTMLString("", baseURL: nil)
                                        }
                                    }
                                }
                            }
                            catch {
                                print("XSLT is not a valid XML: \(error)")
                            }
                        }
                        catch {
                            print("XML is not valid: \(error)")
                        }
                    }
                }
                
                
                override var representedObject: Any? {
                    didSet {
                        // Update the view, if already loaded.
                        // Pass down the represented object to all of the child view controllers.
                        // saple code provided tis loop, but we keep all logic in this viewcontoller:
                        /*
                         for child in children {
                         child.representedObject = representedObject
                         } */
                        // No need to unregister any old observer: by using the observer-propery we take care of this atomatically
                        docObserver = NotificationCenter.default.addObserver(
                            forName: Notification.Name.XsltStudioDocumentChanged, // the name of the radio station
                            object: representedObject, // the broadcaster is the document. This means: a file was read
                            queue: OperationQueue.main // the queue on which to dispatch the closure below
                        ) { (notification: Notification) -> Void in // closure executed when broadcasts occur
                            //let info: Any? = notification.userInfo
                            // info is usually a dictionary of notification-specific information
                            self.refresh()
                        }
                    }
                }
                
                // MARK: - SplitviewDelegate
                override func splitViewDidResizeSubviews(_ notification: Notification) {
                    // Update the slider-positions in content
                    if self.tlvc != nil {
                        self.document?.content?.middle = tlvc.view.frame.width / view.frame.width
                        self.document?.content?.left = tlvc.view.frame.height / view.frame.height
                        self.document?.content?.right = trvc.view.frame.height / view.frame.height
                        self.document?.updateChangeCount(.changeDone)
                    }
                }
            }
            
