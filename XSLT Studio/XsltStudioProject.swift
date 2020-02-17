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
    var xml: String = """
<?xml version="1.0" encoding="UTF-8"?>
"""
    var xslt: String = """
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
        <html>
            <style>:root { color-scheme: light dark; }</style>
            <h1>Hello</h1>
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
