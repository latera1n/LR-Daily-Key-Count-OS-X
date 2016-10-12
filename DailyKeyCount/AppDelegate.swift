//
//  AppDelegate.swift
//  DailyKeyCount
//
//  Created by DengYuchi on 2/1/16.
//  Copyright © 2016 LateRain. All rights reserved.
//

import Cocoa
import AppKit
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var mainMenu: NSMenu!
    @IBOutlet weak var startAtLoginMenuItem: NSMenuItem!

    let statusItem = NSStatusBar.system().statusItem(withLength: NSSquareStatusItemLength)
    let popover = NSPopover()
    let bundleIdentifierCFString = "io.laterain.DailyKeyCountHelper" as CFString
    let userDefaults = UserDefaults.standard
    let startAtLoginKey = "userDefaultsStartAtLoginKey"

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application

        let isStartAtLogin = userDefaults.bool(forKey: startAtLoginKey)
        startAtLoginMenuItem.state = isStartAtLogin ? NSOnState : NSOffState

        if let menuBarButton = statusItem.button {
            menuBarButton.target = self
            menuBarButton.image = NSImage(named: "menu-bar-icon")
        }
        popover.behavior = NSPopoverBehavior.transient
        popover.contentViewController = MainViewController(nibName: "MainViewController", bundle: nil)
        statusItem.action = #selector(AppDelegate.togglePopups(_:))
        statusItem.sendAction(on: NSEventMask(rawValue: UInt64(Int((NSEventMask.leftMouseUp.rawValue | NSEventMask.rightMouseUp.rawValue)))))
        showPopover(nil)
        closePopover(nil)
    }

    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.maxY)
            print(NSEvent.mouseLocation())
            let cgEvent = CGEvent(mouseEventSource: nil, mouseType: CGEventType.leftMouseDown, mouseCursorPosition: CGPoint(x: NSEvent.mouseLocation().x, y: NSEvent.mouseLocation().y - 40.0), mouseButton: CGMouseButton.left)
            let event = NSEvent(cgEvent: cgEvent!)
            popover.mouseDown(with: event!)
            popover.mouseUp(with: event!)
        }
    }

    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
    }

    func togglePopups(_ sender: AnyObject?) {
        let event: NSEvent! = NSApp.currentEvent!
        if event.type == NSEventType.leftMouseUp {
            if popover.isShown {
                closePopover(sender)
            } else {
                showPopover(sender)
            }
        } else {
            statusItem.popUpMenu(self.mainMenu)
        }
    }

    @IBAction func quitApp(_ sender: AnyObject) {
        NSApplication.shared().terminate(sender)
    }

    @IBAction func startAtLoginClicked(_ sender: AnyObject) {
        toggleLaunchAtStartup()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    // MARK: - Helpers

    func toggleLaunchAtStartup() {
        let itemReferences = itemReferencesInLoginItems()
        let shouldBeToggled = (itemReferences.existingReference == nil)
        if let loginItemsRef = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileList? {
            if shouldBeToggled {
                let appUrl = NSURL.fileURL(withPath: Bundle.main.bundlePath) as CFURL!
                LSSharedFileListInsertItemURL(loginItemsRef, itemReferences.lastReference, nil, nil, appUrl, nil, nil)
                startAtLoginMenuItem.state = NSOnState
                userDefaults.set(true, forKey: startAtLoginKey)
            } else {
                if let itemRef = itemReferences.existingReference {
                    LSSharedFileListItemRemove(loginItemsRef, itemRef);
                    startAtLoginMenuItem.state = NSOffState
                    userDefaults.set(false, forKey: startAtLoginKey)
                }
            }
            userDefaults.synchronize()
        }
    }

    func applicationIsInStartUpItems() -> Bool {
        return (itemReferencesInLoginItems().existingReference != nil)
    }

    func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItem?, lastReference: LSSharedFileListItem?) {
        let appURL = NSURL.fileURL(withPath: Bundle.main.bundlePath)
        if let loginItemsRef = LSSharedFileListCreate(nil, kLSSharedFileListSessionLoginItems.takeRetainedValue(), nil).takeRetainedValue() as LSSharedFileList? {
            let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
            let lastItemRef: LSSharedFileListItem = loginItems.lastObject as! LSSharedFileListItem
            for (index, _) in loginItems.enumerated() {
                let currentItemRef: LSSharedFileListItem = loginItems.object(at: index) as! LSSharedFileListItem
                if let itemURL = LSSharedFileListItemCopyResolvedURL(currentItemRef, 0, nil) {
                    if (itemURL.takeRetainedValue() as NSURL).isEqual(appURL) {
                        return (currentItemRef, lastItemRef)
                    }
                }
            }
            return (nil, lastItemRef)
        }
        return (nil, nil)
    }
}

