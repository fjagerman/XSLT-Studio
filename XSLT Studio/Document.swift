//
//  Document.swift
//  XSLT Studio
//
//  Created by Freek Jagerman on 27/12/2018.
//  Copyright © 2018 Jagerman Services. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    var content: XsltStudioProject?
    var contentViewController: XSLTStudioViewController?
    
    override init() {
        super.init()
        content = XsltStudioProject()
        // Add your subclass-specific initialization here.
    }
    
    override class var autosavesInPlace: Bool {
        return true
    }
    
    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        
        self.addWindowController(windowController)
        
        // Set the view controller's represented object as your document.
        if let contentVC = windowController.contentViewController as? XSLTStudioViewController {
            contentVC.representedObject = self
            contentViewController = contentVC
        }
    }
    
    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override fileWrapper(ofType:), write(to:ofType:), or write(to:ofType:for:originalContentsURL:) instead.
        
        if content != nil {
            return content!.json ?? Data()
        }
        else {
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override read(from:ofType:) instead.
        // If you do, you should also override isEntireFileLoaded to return false if the contents are lazily loaded.
        //do {
        content = XsltStudioProject(json: data)
        NotificationCenter.default.post(name: Notification.Name("XsltStudioDocumentChanged"), object: self)
        /*}
         catch {
         throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
         }*/
    }
    
    
}

