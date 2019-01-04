//
//  AppDelegate.swift
//  XSLT Studio
//
//  Created by Freek Jagerman on 27/12/2018.
//  Copyright © 2018 Jagerman Services. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        UserDefaults.standard.set("YES", forKey: "NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

