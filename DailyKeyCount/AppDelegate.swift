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
    
    @IBOutlet weak var mainMenu: NSMenu!
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSSquareStatusItemLength)
    let popover = NSPopover()

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        if let menuBarButton = statusItem.button {
            menuBarButton.target = self
            menuBarButton.image = NSImage(named: "menu-bar-icon")
        }
        popover.behavior = NSPopoverBehavior.Transient
        popover.contentViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        statusItem.action = Selector("togglePopups:")
        statusItem.sendActionOn(Int((NSEventMask.LeftMouseDownMask.rawValue | NSEventMask.RightMouseDownMask.rawValue)))
        showPopover(nil)
        closePopover(nil)
    }
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MaxY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopups(sender: AnyObject?) {
        let event:NSEvent! = NSApp.currentEvent!
        if event.type == NSEventType.LeftMouseDown {
            if popover.shown {
                closePopover(sender)
            } else {
                showPopover(sender)
            }
        } else {
            statusItem.popUpStatusItemMenu(self.mainMenu)
        }
    }
    
    @IBAction func quitApp(sender: AnyObject) {
        NSApplication.sharedApplication().terminate(sender)
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}

