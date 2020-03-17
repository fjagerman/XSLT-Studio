//
//  TopLeftViewController.swift
//  XSLT Studio
//
//  Created by Freek Jagerman on 02/01/2019.
//  Copyright © 2019 Jagerman Services. All rights reserved.
//

import Cocoa

class TopLeftViewController: NSViewController {

    @IBOutlet weak var xmlInput: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    @IBAction func xmlInputAction(_ sender: NSTextFieldCell) {
        NotificationCenter.default.post(name: Notification.Name("XsltStudioDocumentChanged"), object: self)
    }
    var docObserver: NSObjectProtocol?
    
    override func viewWillAppear() {
        xmlInput.stringValue = document.content!.xml

        docObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name.XsltStudioDocumentChanged, // the name of the radio station
            object: nil, // the broadcaster is the topLeftViewController. This means the XML has changed
            queue: OperationQueue.main // the queue on which to dispatch the closure below
        ) { (notification: Notification) -> Void in // closure executed when broadcasts occur
            if let newXml = self.xmlInput?.stringValue {
                if self.document.content?.xml != newXml {
                    // actual user input: update and notify the document
                    self.document.content?.xml = newXml
                    self.xmlInput.stringValue = self.document.content!.xml
                    self.document.updateChangeCount(.changeDone)
                }
            }
        }
    }
    
    var document: Document! {
        return representedObject as? Document
    }
    
}
