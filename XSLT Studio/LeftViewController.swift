//
//  LeftViewController.swift
//  XSLT Studio
//
//  Created by Freek Jagerman on 16/03/2020.
//  Copyright © 2020 Jagerman Services. All rights reserved.
//

import Cocoa

class LeftViewController: NSSplitViewController {
    
    
    @IBOutlet weak var topSplitViewItem: NSSplitViewItem!
    
    var tlvc: TopLeftViewController! {
        if let t = topSplitViewItem {
            return t.viewController as? TopLeftViewController
        }
        else {
            return nil
        }
    }

    
    // MARK: - Notification Observer
    // No need to unregister any old observer: by using the observer-propery we take care of this atomatically
    var docObserver: NSObjectProtocol? // Cookies to later “stop listening” with
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        // Restore the splitview sliders
        splitView.setPosition(self.document.content!.left * self.view.frame.height, ofDividerAt: 0)
    }
    
    var document: Document! {
        return representedObject as? Document
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
        if tlvc != nil && document != nil {
            document.content?.left = tlvc.view.frame.height / view.frame.height
            document.updateChangeCount(.changeDone)
        }
    }
}
