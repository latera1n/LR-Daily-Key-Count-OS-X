//
//  AppDelegate.swift
//  DailyKeyCount
//
//  Created by DengYuchi on 2/1/16.
//  Copyright © 2016 LateRain. All rights reserved.
//

import Cocoa
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
    let popover = NSPopover()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        if let menuBarButton = statusItem.button {
            menuBarButton.image = NSImage(named: "menu-bar-icon")
            menuBarButton.action = Selector("togglePopover:")
        }
        popover.contentViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        togglePopover(nil)
        togglePopover(nil)
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MaxY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}

