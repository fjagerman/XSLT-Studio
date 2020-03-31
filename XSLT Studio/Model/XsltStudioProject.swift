//
//  XsltStudioProject.swift
//  XSLT Studio
//
//  Created by Freek Jagerman on 21/01/2019.
//  Copyright © 2019 Jagerman Services. All rights reserved.
//

import Foundation

struct XsltStudioProject: Codable {
    
    // MARK: - Non-Codable Attributes
    var parseOptions: XMLNode.Options = [.nodePrettyPrint, .documentTidyXML]
    var outputOptions: XMLNode.Options = [.nodePrettyPrint, .nodeCompactEmptyElement]
    var output = ""
    private var parseError = true
    
    // MARK: - Codable Attributes
    // Position of the sliders
    var left:   CGFloat = 0.5
    var middle: CGFloat = 0.5
    var _right:  CGFloat = 0.5
    
    var right: CGFloat {
        set {
            if html {
                _right = newValue
            }
        }
        get {
            html ? _right : 1.0
        }
    }
    
    // Toggle fo preserving whitespace when applying XSLT or reformatting XSLT
    var preserveWhitespace = false {
        didSet {
            // Configure the options accordingly:
            if preserveWhitespace {
                parseOptions.insert(.nodePreserveWhitespace)
                outputOptions.insert(.nodePreserveWhitespace)
            }
            else {
                parseOptions.remove(.nodePreserveWhitespace)
                outputOptions.remove(.nodePreserveWhitespace)
            }
            refreshOutput()
        }
    }
    var html = true
    
    // Generate HTML
    var generateHtml: Bool {
        get {
            if parseError {
                return false
            }
            else {
                return html
            }
        }
        set {
            html = newValue
        }
    }
    // Both XSLT and XML are stored as String to allow for invalid XML
    
    private var xmldoc: XMLDocument?
    var xml: String = """
<?xml version="1.0" encoding="UTF-8"?>
""" {
        didSet {
            do {
                xmldoc = try XMLDocument(xmlString: xml, options: .documentTidyXML)
                // Overwrite xml with PrettyPrinted version
                if let st = xmldoc?.xmlString(options: .nodePrettyPrint ) {
                    if st != oldValue {
                        xml = st
                        refreshOutput()
                    }
                }
            }
            catch {
                print("XML in top left windows is not valid: \(error)")
            }
        }
    }
    
    
    
    // XSLT to be loaded in the botom left window
    var xslt: String = """
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
        <html>
<style>:root { color-scheme: light dark; }table { border-collapse: collapse; } a { color: var(--link);text-decoration: none;} table, td, th { border: 1px solid; }th {background-color: var(--th-color);text-align: left;} th, tr { font-family: Arial }tr:nth-child(even) {background-color: var(--alt-row-color);} @media (prefers-color-scheme: dark) {:root {--link: #6ECDFA; --th-color: #B50000; --alt-row-color: #626262;}} @media (prefers-color-scheme: light) {:root {--link: blue; --th-color: #93DC70; --alt-row-color: #f2f2f2;}}
</style>
            <h1>Hello</h1>
            <table>
                <tr><th>Header</th></tr>
                <tr><td>row1</td></tr>
                <tr><td>row2</td></tr>
            </table>
        </html>
    </xsl:template>
</xsl:stylesheet>
""" {
        didSet {
            do {
                let xsltdoc = try XMLDocument(xmlString: xslt, options: parseOptions )
                // Overwrite xslt with PrettyPrinted version (may cause a cleanup of the xslt)
                let st = xsltdoc.xmlString(options: outputOptions )
                if st != oldValue {
                    xslt = st
                    refreshOutput()
                }
            }
            catch {
                print("XSLT in bottom left windows is not valid: \(error)")
            }
        }
    }
    
    /// This is where all the magic happens:
    /// Applying XSLT on XSL and saving it in the output attribute
    mutating func refreshOutput() {
        do {
            if xmldoc == nil {
                do {
                    xmldoc = try XMLDocument(xmlString: xml, options: .documentTidyXML)
                }
                catch {
                    print("XML in top left windows is not valid: \(error)")
                }
            }
            if let xmlAfterXSLT = try xmldoc?.object(byApplyingXSLTString: xslt, arguments: ["author": "Freek"]) as? XMLDocument {
                // Causing xsl:version: only 1.0 features are supported
                output = xmlAfterXSLT.xmlString(options: outputOptions)
                parseError = false
            }
            else {
                parseError = true
                output = "Error"
            }
        }
        catch {
            print("Object by applying XSLT string failed: \(error)")
            output = "XSLT is not valid: \(error)"
            parseError = true
        }
    }
    
    
    
    
    init() {
        self.refreshOutput()
    }
    
    // MARK: - Codable stuff
    
    // This enum specifies which attributes to encode
    private enum CodingKeys: String, CodingKey {
        case left, middle, _right="right", preserveWhitespace, html, xml, xslt
    }
    
    /// Initialize with JSON
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(XsltStudioProject.self, from: json) {
            self = newValue
            refreshOutput()
        } else {
            return nil
        }
    }
    
    // To produce json
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
