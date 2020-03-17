//
//  BottomLeftViewController.swift
//  XSLT Studio
//
//  Created by Freek Jagerman on 02/01/2019.
//  Copyright © 2019 Jagerman Services. All rights reserved.
//

import Cocoa

class BottomLeftViewController: NSViewController {
    
    @IBOutlet weak var xsltInput: NSTextField!
    @IBOutlet weak var whiteSpaceCheckbox: NSButton!
    
    @IBAction func whiteSpaceClicked(_ sender: NSButton) {
        NotificationCenter.default.post(name: Notification.Name("XsltStudioDocumentChanged"), object: self)
    }
    var docObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // Action to create notification or main viewcontroller o update result
    @IBAction func xsltInputAction(_ sender: NSTextFieldCell) {
        NotificationCenter.default.post(name: Notification.Name("XsltStudioDocumentChanged"), object: self)
    }
    
    var document: Document! {
        return representedObject as? Document
    }
    
    override func viewWillAppear() {
        whiteSpaceCheckbox.state = NSControl.StateValue(rawValue: self.document.content!.preserveWhitespace ? 1 : 0)
        xsltInput.stringValue = document.content!.xslt
        
        //Assign observer for XSLT-changes
        docObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name.XsltStudioDocumentChanged, // the name of the radio station
            object: nil, // the broadcaster is the bottomLeftViewController meaning: the XSLT has changed
            queue: OperationQueue.main // the queue on which to dispatch the closure below
        ) { (notification: Notification) -> Void in // closure executed when broadcasts occur
            if let newXslt = self.xsltInput?.stringValue {
                if self.document.content?.xslt != newXslt ||
                    self.document.content?.preserveWhitespace != (self.whiteSpaceCheckbox.state.rawValue == 1)
                {
                    self.document.content!.preserveWhitespace = (self.whiteSpaceCheckbox.state.rawValue == 1)
                    // actual user input: update and notify the document
                    self.document.content!.xslt = newXslt
                    self.document.updateChangeCount(.changeDone)
                }
            }
        }
    }
}
