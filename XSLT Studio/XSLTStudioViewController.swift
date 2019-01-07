            //
            //  ViewController.swift
            //  XSLT Studio
            //
            //  Created by Freek Jagerman on 27/12/2018.
            //  Copyright © 2018 Jagerman Services. All rights reserved.
            //
            
            import Cocoa
            import WebKit
            
            extension Notification.Name {
                static var XsltStudioDocumentChanged = Notification.Name("XsltStudioDocumentChanged")
            }
            
            class XSLTStudioViewController: NSSplitViewController {
                var document: Document?
                var tlvc: TopLeftViewController!
                var blvc: BottomLeftViewController!
                var trvc: TopRightViewController!
                var brvc: BottomRightViewController!
                
                // MARK: - Outlets
                @IBOutlet weak var leftSplitview: NSSplitView!
                @IBOutlet weak var rightSplitview: NSSplitViewItem!
                
                // MARK: - LifeCycle
                override func viewDidLoad() {
                    super.viewDidLoad()
                    
                    // Do any additional setup after loading the view.
                }
                // MARK: - Notification Observer
                var observer: NSObjectProtocol? // a cookie to later “stop listening” with
                
                override func viewWillAppear() {
                    // Input files:
                    let url = URL(fileReferenceLiteralResourceName: "w3schools.xml")
                    
                    let xslt = URL(fileReferenceLiteralResourceName: "w3schools.xslt")
                    print("loaded XML:")
                    print(document?.xml?.canonicalXMLStringPreservingComments(true) ?? "niks" )
                    observer = NotificationCenter.default.addObserver(
                        forName: Notification.Name.XsltStudioDocumentChanged, // the name of the radio station
                        object: nil, // the broadcaster (or nil for “anyone”)
                        queue: OperationQueue.main // the queue on which to dispatch the closure below
                    ) { (notification: Notification) -> Void in // closure executed when broadcasts occur
                        //let info: Any? = notification.userInfo
                        // info is usually a dictionary of notification-specific information
                        do {
                            let xmlXml = try XMLDocument(xmlString: self.tlvc.xmlInput.stringValue, options: .documentTidyXML)
                            do {
                                let _ = try XMLDocument(xmlString: self.blvc.xsltInput.stringValue, options: .documentTidyXML )
                                
                                do {
                                    let o = try xmlXml.object(byApplyingXSLTString: self.blvc.xsltInput.stringValue, arguments: ["author": "Freek"]) as? XMLDocument
                                    //print("html:")
                                    //print(o?.canonicalXMLStringPreservingComments(true) ?? "niks" )
                                    self.trvc.textView.string = o?.xmlString(options: .nodePrettyPrint ) ?? "No result"
                                    //webView.loadHTMLString(st, baseURL: nil)
                                    if let st = o?.xmlString(options: .documentTidyHTML) {
                                        self.brvc.webView.loadHTMLString(st, baseURL: nil)
                                    }
                                }
                                catch {
                                    print("XSLT translation failed: \(error)")
                                }
                            }
                            catch {
                                print("XSLT is not valid: \(error)")
                            }
                        }
                        catch {
                            print("XML is not valid: \(error)")
                        }
                    }
                    
                    
                    //var xsltObservation = blvc.observe(
                    
                    // Hook-up the four viewconrollers
                    
                    if let lvc = splitViewItems[0].viewController as? NSSplitViewController {
                        tlvc = lvc.splitViewItems[0].viewController as? TopLeftViewController
                        blvc = lvc.splitViewItems[1].viewController as? BottomLeftViewController
                    }
                    
                    if let rightViewController = splitViewItems[1].viewController as? NSSplitViewController {
                        trvc = rightViewController.splitViewItems[0].viewController as? TopRightViewController
                        brvc = rightViewController.splitViewItems[1].viewController as? BottomRightViewController
                    }
                    
                    // Step 1: Read the XML into the first view
                    do {
                        let docje = try XMLDocument(contentsOf: url, options: .documentTidyXML)
                        //print("docje.rootElement(): \(docje.rootElement()?.xPath ?? "niks")")
                        
                        tlvc.xmlInput.stringValue = docje.rootElement()?.xmlString(options: .nodePrettyPrint) ?? "No XML found"
                        
                        //print("docje.xmlString(.rootElement()?.nodePrettyPrint): \(docje.rootElement()?.xmlString(options: .nodePrettyPrint) ?? "niks")")
                        
                        //print("docje.: \(String(describing: try? docje.nodes(forXPath: "/gpx/wpt").description ))")
                        
                        //: XSLT translatie naar HTMLX
                        //  <tr align="right"><td>hoi</td><td><xsl:value-of select="@lat"/></td><td><xsl:value-of select="@lon"/></td>
                        
                        // Step 2: Load XSLT
                        
                        do {
                            let docje2 = try XMLDocument(contentsOf: xslt, options: .documentTidyXML)
                            //print("docje.rootElement(): \(docje.rootElement()?.xPath ?? "niks")")
                            
                            blvc.xsltInput.stringValue = docje2.rootElement()?.xmlString(options: .nodePrettyPrint) ?? "No XSLT found"
                            
                            // Step3 : Run translation and generate output
                            NotificationCenter.default.post(name: Notification.Name("XsltStudioDocumentChanged"), object: self)
                        }
                        catch {
                            print("Loading XSLT failed: \(error)")
                        }
                    }
                    catch {
                        print("Loading XML failed: \(error)")
                    }
                }
                
                override var representedObject: Any? {
                    didSet {
                        // Update the view, if already loaded.
                    }
                }
            }
            
