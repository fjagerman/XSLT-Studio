//
//  BottomLeftViewController.swift
//  XSLT Studio
//
//  Created by Freek Jagerman on 02/01/2019.
//  Copyright © 2019 Jagerman Services. All rights reserved.
//

import Cocoa

class BottomLeftViewController: NSViewController {

    var whiteSpace = true
    @IBOutlet weak var xsltInput: NSTextField!
    
    @IBAction func whiteSpaceClicked(_ sender: NSButton) {
        whiteSpace = !whiteSpace
        NotificationCenter.default.post(name: Notification.Name("XsltStudioDocumentChanged"), object: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // Action to create notification or main viewcontroller o update result
    @IBAction func xsltInputAction(_ sender: NSTextFieldCell) {
        NotificationCenter.default.post(name: Notification.Name("XsltStudioDocumentChanged"), object: self)
    }
    
}
