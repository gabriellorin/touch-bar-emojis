//
//  Scrubber.swift
//  TouchBarEmojis
//
//  Created by Gabriel Lorin
//

import Cocoa

@available(OSX 10.12.2, *)
class Scrubber: NSCustomTouchBarItem, NSScrubberDelegate, NSScrubberDataSource, NSScrubberFlowLayoutDelegate {
    
    private let itemViewIdentifier = "EmojiScrubber"
    // width for each emoji:
    private let scrubberItemWidth = 40
    

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(identifier: NSTouchBarItemIdentifier) {
        super.init(identifier: identifier)
        
        let scrubber = NSScrubber()
        scrubber.scrubberLayout = NSScrubberFlowLayout()
        scrubber.register(NSScrubberTextItemView.self, forItemIdentifier: self.itemViewIdentifier)
        // .free makes the Scrubber scrollable:
        scrubber.mode = .free
        scrubber.selectionBackgroundStyle = .roundedBackground
        scrubber.delegate = self
        scrubber.dataSource = self
        view = scrubber
    }
    
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        return Emojis.arrayEmojis.count
    }
    
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        
        // if the array is empty, get frequently used emojis:
        if(Emojis.arrayEmojis.count == 0) {
            Emojis.arrayEmojis = Emojis.getFrequentlyUsedEmojis()
        }
        
        let itemView = scrubber.makeItem(withIdentifier: self.itemViewIdentifier,
                                         owner: nil) as! NSScrubberTextItemView
        
        // (scrubber iterates depending on value returned by numberOfItems)
        itemView.textField.stringValue = Emojis.arrayEmojis[index]
        
        // change emoji font size:
        itemView.textField.font = NSFont.systemFont(ofSize: 28)
        
        return itemView
    }
    
    func scrubber(_ scrubber: NSScrubber, layout: NSScrubberFlowLayout, sizeForItemAt itemIndex: Int) -> NSSize {
        
        // set the distance between emojis (the height Touch Bar is 30 points):
        return NSSize(width: scrubberItemWidth, height: 30)
    }

    func scrubber(_ scrubber: NSScrubber, didSelectItemAt index: Int) {
        
        // get the emoji that has been selected:
        let emojiToType = Emojis.arrayEmojis[index]
        
        // type the emoji:
        KeyEvent.typeEmoji(emoji: emojiToType)
        
        // deselect the selected emoji:
        scrubber.selectedIndex = -1
    }
}
