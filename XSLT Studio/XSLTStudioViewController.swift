            //
            //  ViewController.swift
            //  XSLT Studio
            //
            //  Created by Freek Jagerman on 27/12/2018.
            //  Copyright © 2018 Jagerman Services. All rights reserved.
            //
            
            import Cocoa
            
            extension Notification.Name {
                static var XsltStudioDocumentChanged = Notification.Name("XsltStudioDocumentChanged")
            }
            
            class XSLTStudioViewController: NSSplitViewController {
                
                @IBOutlet weak var leftSplitViewItem: NSSplitViewItem!
                
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
                }
                
                override var representedObject: Any? {
                    didSet {
                        // Update the view, if already loaded.
                        // Pass down the represented object to all of the child view controllers.
                        // saple code provided tis loop, but we keep all logic in this viewcontoller:
                        for child in children {
                            child.representedObject = representedObject
                        }
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
            
