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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }    
}
