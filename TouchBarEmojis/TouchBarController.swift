//
//  TouchBarController.swift
//  TouchBarEmojis
//
//  Created by Gabriel Lorin
//

import Foundation

@available(OSX 10.12.2, *)
class TouchBarController: NSObject, NSTouchBarDelegate {
    
    // the identifiers for the Touch Bar modal and items:
    let emojiSystemModal = NSTouchBarItemIdentifier("in.lor.EmojiSystemModal")
    let emojiScrubberIdentifier = NSTouchBarItemIdentifier("in.lor.EmojiScrubber")
    let emojiButtonIdentifier = NSTouchBarItemIdentifier("in.lor.EmojiButton")
    
    // the scrubber we use to display the emojis:
    var scrubber = NSScrubber()
    
    // we keep track of a single Touch Bar object:
    private var singleSystemModalTouchBar: NSTouchBar?
    
    var systemModalTouchBar: NSTouchBar? {
        // if the Touch Bar object is not set:
        if (singleSystemModalTouchBar == nil) {
                let touchBar = NSTouchBar()
                // the Touch Bar will contain the scrubber and the button:
                touchBar.defaultItemIdentifiers = [emojiScrubberIdentifier,emojiButtonIdentifier]
                touchBar.delegate = self
                singleSystemModalTouchBar = touchBar
        }
        return singleSystemModalTouchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        // the Touch Bar is initializing:
        if (identifier == emojiScrubberIdentifier) {
            
            // setting up the emoji Scrubber:
            let scrubberItem: NSCustomTouchBarItem
            scrubberItem = Scrubber(identifier: identifier)
            scrubber = scrubberItem.view as! NSScrubber
            
            return scrubberItem
            
        } else if(identifier == emojiButtonIdentifier) {
            // setting up the emoji Button:
            let emojiButton = NSCustomTouchBarItem(identifier: emojiButtonIdentifier)
            emojiButton.view = NSButton(title: "Emojis", target: self, action: #selector(self.emojiButtonTapped))
            
            return emojiButton
        } else {
            
            return nil
        }
    }
    
    func emojiButtonTapped(_ sender: Any) {
        
        // display the Emoji Viewer:
        KeyEvent.openEmojiViewer()

    }
    
    

}
