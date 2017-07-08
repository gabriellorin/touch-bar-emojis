//
//  KeyEvent.swift
//  TouchBarEmojis
//
//  Created by Gabriel Lorin
//

import Foundation

struct KeyEvent {
    static func typeEmoji (emoji: String) {
        
        let source = CGEventSource(stateID: .hidSystemState)
        // event for key down event:
        let eventKey = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true)
        // event for key up event:
        let eventKeyUp = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: false)
        
        // split the emoji into an array:
        var utf16array = Array(emoji.utf16)
        
        // set the emoji for the key down event:
        eventKey?.keyboardSetUnicodeString(stringLength: utf16array.count, unicodeString: &utf16array)
        // set the emoji for the key up event:
        eventKeyUp?.keyboardSetUnicodeString(stringLength: utf16array.count, unicodeString: &utf16array)
        // post key down event:
        eventKey?.post(tap: CGEventTapLocation.cghidEventTap)
        // post key up event:
        eventKeyUp?.post(tap: CGEventTapLocation.cghidEventTap)
        
    }
    
    static func openEmojiViewer () {
        // to open the Emoji Viewer, we need to simulate control + command + space:
        
        let source = CGEventSource(stateID: .hidSystemState)
        // set the key to space:
        let eventKeySpace = CGEvent(keyboardEventSource: source, virtualKey: 0x31, keyDown: true)
        // set the key up to space:
        let eventKeySpaceUp = CGEvent(keyboardEventSource: source, virtualKey: 0x31, keyDown: false)
        
        // add the flags control and command
        eventKeySpace?.flags = [.maskCommand,.maskControl]
        eventKeySpaceUp?.flags = [.maskCommand,.maskControl]
        
        // post key down and up events:
        eventKeySpace?.post(tap: CGEventTapLocation.cghidEventTap)
        eventKeySpaceUp?.post(tap: CGEventTapLocation.cghidEventTap)
    }
}
