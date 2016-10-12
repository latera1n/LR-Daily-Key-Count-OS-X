//
//  MainViewController.swift
//  DailyKeyCount
//
//  Created by DengYuchi on 2/1/16.
//  Copyright © 2016 LateRain. All rights reserved.
//

import Cocoa
import CoreText

class MainViewController: NSViewController {
    
    var isQuitButtonPressedOnce: Bool = false
    
    @IBOutlet weak var keyCountLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        var normalKeyCount: Int64 = 0;
        let specialKeyCount: Int64 = 0;
        
        keyCountLabel.font = NSFont.monospacedDigitSystemFont(ofSize: 32, weight: NSFontWeightThin)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEventMask.keyDown) { (event: NSEvent) -> Void in
            normalKeyCount += 1
            self.keyCountLabel.stringValue = numberFormatter.string(from: NSNumber(value: normalKeyCount + specialKeyCount / 2 as Int64))!
        }
        NSEvent.addLocalMonitorForEvents(matching: NSEventMask.keyDown) { (evet: NSEvent) -> NSEvent? in
            normalKeyCount += 1
            self.keyCountLabel.stringValue = numberFormatter.string(from: NSNumber(value: normalKeyCount + specialKeyCount / 2 as Int64))!
            return nil
        }
        
        NSEvent.addGlobalMonitorForEvents(matching: NSEventMask.flagsChanged) { (event: NSEvent) -> Void in
            normalKeyCount += 1
            self.keyCountLabel.stringValue = numberFormatter.string(from: NSNumber(value: normalKeyCount + (specialKeyCount + 1) / 2 as Int64))!
        }
        NSEvent.addLocalMonitorForEvents(matching: NSEventMask.flagsChanged) { (evet: NSEvent) -> NSEvent? in
            normalKeyCount += 1
            self.keyCountLabel.stringValue = numberFormatter.string(from: NSNumber(value: normalKeyCount + (specialKeyCount + 1) / 2 as Int64))!
            return nil
        }
    }

}
