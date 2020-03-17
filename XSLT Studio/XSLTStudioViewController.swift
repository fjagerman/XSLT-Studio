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
                
                @IBOutlet weak var leftSplitViewItem: NSSplitViewItem!
                @IBOutlet weak var rightSplitViewItem: NSSplitViewItem!
                
                var xmlXml: XMLDocument?
                
                var document: Document! {
                    return representedObject as? Document
                }
                
                var lvc: LeftViewController? {
                    if let l = leftSplitViewItem {
                        return l.viewController as? LeftViewController
                    }
                    else {
                        return nil
                    }
                }
                
//                var rvc: RightViewController? {
//                    if let r = rightSplitViewItem {
//                        return r.viewController as? RightViewController
//                    }
//                    else {
//                        return nil
//                    }
//                }
                
                //var tlvc: TopLeftViewController! { lvc?.tlvc }
                //var blvc: BottomLeftViewController! { lvc?.blvc }
                //var trvc: TopRightViewController! { rvc?.trvc }
                //var brvc: BottomRightViewController! { rvc?.brvc }
                
                // MARK: - Notification Observer
                // No need to unregister any old observer: by using the observer-propery we take care of this atomatically
                //var docObserver: NSObjectProtocol? // Cookies to later “stop listening” with
                
                // MARK: - LifeCycle
                override func viewDidLoad() {
                    super.viewDidLoad()
                    
                    // Do any additional setup after loading the view.
                }
                
                override func viewWillAppear() {
                    if let content = self.document.content {
                        // Restore the splitview middle divider
                        self.splitView.setPosition(content.middle * self.view.frame.width, ofDividerAt: 0)
                    }
                    NotificationCenter.default.post(name: Notification.Name("XsltStudioDocumentChanged"), object: self)
                }
                
                override var representedObject: Any? {
                    didSet {
                        // Update the view, if already loaded.
                        // Pass down the represented object to all of the child view controllers.
                        // saple code provided tis loop, but we keep all logic in this viewcontoller:
                        for child in children {
                            child.representedObject = representedObject
                        }
                        NotificationCenter.default.post(name: Notification.Name("XsltStudioDocumentChanged"), object: self)
                    }
                }
                
                // MARK: - SplitviewDelegate
                override func splitViewDidResizeSubviews(_ notification: Notification) {
                    // Update the slider-positions in content
                    if lvc != nil && document != nil {
                        document.content?.middle = (lvc?.view.frame.width)! / view.frame.width
                        document.updateChangeCount(.changeDone)
                    }
                }
            }
            
