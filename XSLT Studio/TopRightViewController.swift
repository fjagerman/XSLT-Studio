//
//  TopRighViewController.swift
//  XSLT Studio
//
//  Created by Freek Jagerman on 02/01/2019.
//  Copyright © 2019 Jagerman Services. All rights reserved.
//

import Cocoa

class TopRightViewController: NSViewController {
    
    @IBOutlet weak var textView: NSTextView!
    @IBOutlet weak var htmlCheckbox: NSButton!
    
    @IBAction func htmlClicked(_ sender: NSButton?) {
        NotificationCenter.default.post(name: Notification.Name("XsltStudioDocumentChanged"), object: self)
    }
    // MARK: - Notification Observer
    // No need to unregister any old observer: by using the observer-propery we take care of this automatically
    var docObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewWillAppear() {
        // Restore HTML checkbox
        htmlCheckbox.state = NSControl.StateValue(rawValue: self.document.content!.html ? 1 : 0)
        textView.string = document.content!.output
        
        docObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name.XsltStudioDocumentChanged, // the name of the radio station
            object: nil, // the broadcaster is the topRightViewController meaning the HTML checkbox has changed
            queue: OperationQueue.main // the queue on which to dispatch the closure below
        ) { (notification: Notification) -> Void in // closure executed when broadcasts occur
            self.textView.string = self.document.content!.output
            self.document.content!.html = (self.htmlCheckbox.state.rawValue == 1)
            self.document.updateChangeCount(.changeDone)
        }
    }
    
    var document: Document! {
        return representedObject as? Document
    }
}
