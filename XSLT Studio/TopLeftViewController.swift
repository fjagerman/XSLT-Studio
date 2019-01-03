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
    
}
