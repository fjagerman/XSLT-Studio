//
//  RightViewController.swift
//  XSLT Studio
//
//  Created by Freek Jagerman on 16/03/2020.
//  Copyright © 2020 Jagerman Services. All rights reserved.
//

import Cocoa

class RightViewController: NSSplitViewController {
    
    @IBOutlet weak var topSplitViewItem: NSSplitViewItem!
    @IBOutlet weak var bottomSplitViewItem: NSSplitViewItem!
    
    var trvc: TopRightViewController! {
        if let t = topSplitViewItem {
            return t.viewController as? TopRightViewController
        }
        else {
            return nil
        }
    }
    
    var brvc: BottomRightViewController! {
        if let b = bottomSplitViewItem {
            return b.viewController as? BottomRightViewController
        }
        else {
            return nil
        }
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        if let content = self.document.content {
            // Restore HTML checkbox
            trvc.htmlCheckbox.state = NSControl.StateValue(rawValue: self.document.content!.html ? 1 : 0)
            
            // Restore the splitview right divider
            splitView.setPosition(content.right * self.view.frame.height, ofDividerAt: 0)
        }
    }
    
//    func refresh() {
//        if trvc != nil && brvc != nil {
//            if let doc = document.content {
//                //trvc.textView.string = doc.output
//                if doc.html {
//                    brvc.webView.loadHTMLString(doc.html ? doc.output : "", baseURL: nil)
//                }
//                document.updateChangeCount(.changeDone)
//            }
//        }
//    }
    
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
        if trvc != nil && document != nil {
            if trvc.htmlCheckbox.state.rawValue == 1 {
                document.content?.right = trvc.view.frame.height / view.frame.height
            }
            document.updateChangeCount(.changeDone)
        }
    }
}
