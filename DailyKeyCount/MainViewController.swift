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
        var specialKeyCount: Int64 = 0;
        
        keyCountLabel.font = NSFont.monospacedDigitSystemFontOfSize(32, weight: NSFontWeightThin)
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        
        NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.KeyDownMask) { (event: NSEvent) -> Void in
            self.keyCountLabel.stringValue = numberFormatter.stringFromNumber(NSNumber(longLong: ++normalKeyCount + specialKeyCount / 2))!
        }
        NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.KeyDownMask) { (evet: NSEvent) -> NSEvent? in
            self.keyCountLabel.stringValue = numberFormatter.stringFromNumber(NSNumber(longLong: ++normalKeyCount + specialKeyCount / 2))!
            return nil
        }
        
        NSEvent.addGlobalMonitorForEventsMatchingMask(NSEventMask.FlagsChangedMask) { (event: NSEvent) -> Void in
            self.keyCountLabel.stringValue = numberFormatter.stringFromNumber(NSNumber(longLong: normalKeyCount + (++specialKeyCount + 1) / 2))!
        }
        NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.FlagsChangedMask) { (evet: NSEvent) -> NSEvent? in
            self.keyCountLabel.stringValue = numberFormatter.stringFromNumber(NSNumber(longLong: normalKeyCount + (++specialKeyCount + 1) / 2))!
            return nil
        }
    }

}
