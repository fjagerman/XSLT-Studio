//
//  XsltStudioProject.swift
//  XSLT Studio
//
//  Created by Freek Jagerman on 21/01/2019.
//  Copyright © 2019 Jagerman Services. All rights reserved.
//

import Foundation

// Both XSLT and XML are stored in string to allow saving invalid XML
struct XsltStudioProject: Codable {
    // Position of the sliders
    var left:   CGFloat = 0.5
    var middle: CGFloat = 0.5
    var right:  CGFloat = 0.5
    
    // XML to be loaded in the top left window
    var xml: String = """
<?xml version="1.0" encoding="UTF-8"?>
"""
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
"""
    
    init() {}
    
    init?(json: Data) {
        if let newValue = try? JSONDecoder().decode(XsltStudioProject.self, from: json) {
            self = newValue
        } else {
            return nil
        }
    }
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
}
