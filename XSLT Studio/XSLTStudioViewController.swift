            //
            //  ViewController.swift
            //  XSLT Studio
            //
            //  Created by Freek Jagerman on 27/12/2018.
            //  Copyright © 2018 Jagerman Services. All rights reserved.
            //

            import Cocoa
            import WebKit

            class XSLTStudioViewController: NSSplitViewController {
                var tlvc: TopLeftViewController!
                var blvc: BottomLeftViewController!
                var trvc: TopRightViewController!
                var brvc: BottomRightViewController!
                
                // MARK: - Outlets
                @IBOutlet weak var LeftSplitview: NSSplitView!
                
                // MARK: - LifeCycle
                override func viewDidLoad() {
                    super.viewDidLoad()

                    // Do any additional setup after loading the view.
                }

                override func viewWillAppear() {
                    // Input files:
                    let url = URL(fileReferenceLiteralResourceName: "w3schools.xml")
                    
                    let xslt = URL(fileReferenceLiteralResourceName: "w3schools.xslt")
                    
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
                        do {
                            let o = try docje.object(byApplyingXSLTString: blvc.xsltInput.stringValue, arguments: ["author": "Freek"]) as? XMLDocument
                            print("html:")
                            
                            
                            print(o?.canonicalXMLStringPreservingComments(true) ?? "niks" )
                            //trvc.textView.string = "dit is al heel wat!" //o?.xmlString(options: .documentTidyHTML) {
                                //webView.loadHTMLString(st, baseURL: nil)
                            if let st = o?.xmlString(options: .documentTidyHTML) {
                                brvc.webView.loadHTMLString(st, baseURL: nil)
                            }
                        }
                        catch {
                            print("Translation failed: \(error)")
                            }
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

