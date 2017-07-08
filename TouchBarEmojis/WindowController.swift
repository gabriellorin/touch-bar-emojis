//
//  WindowController.swift
//  TouchBarEmojis
//
//  Created by Gabriel Lorin
//

import Foundation

class WindowController: NSWindowController {
    

    override func windowDidLoad() {
        
        // hide title:
        window?.titleVisibility = .hidden
        
        // hide resize button + make window unresizable:
        window?.styleMask.remove(.resizable)
        
        // make window top transparent:
        window?.titlebarAppearsTransparent = true
        
        // set background color to white:
        window?.backgroundColor = NSColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
}
