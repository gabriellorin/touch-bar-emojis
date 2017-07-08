//
//  AppDelegate.swift
//  TouchBarEmojis
//
//  Created by Gabriel Lorin
//

import Cocoa

@available(OSX 10.12.2, *)
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTouchBarDelegate {
    
    // dic array containing the list of apps which should have the permanent emoji bar:
    static var emojisForApp: [[String: String]] = []
    
    // array of path for default apps:
    static let defaultApps = ["/Applications/Google Chrome.app","/Applications/Messages.app","/Applications/Notes.app","/Applications/Safari.app","/Applications/TextEdit.app","/Applications/Adobe Photoshop CC 2017/Adobe Photoshop CC 2017.app","/Applications/Skype.app","/Applications/GitHub.app","/Applications/Slack.app","/Applications/Twitter.app","/Applications/WhatsApp.app","/Applications/Firefox.app"]
    
    // the Touch Bar
    let touchBar = TouchBarController()
    
    // we check for file changed in the preferences files containing the latest used emojis
    // starting in 10.13, most frequent emojis are stored in the EmojiPreferences.plist file: it also contains the number of times each emoji was used
    let fileWatcher = SwiftFSWatcher([NSHomeDirectory()+"/Library/Preferences/com.apple.EmojiPreferences.plist", NSHomeDirectory()+"/Library/Preferences/com.apple.CharacterPicker.plist"])
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // set the frequently used emojis:
        Emojis.arrayEmojis = Emojis.getFrequentlyUsedEmojis()
        
        // add notification for App change event
        let notificationCenter = NSWorkspace.shared().notificationCenter
        notificationCenter.addObserver(self, selector: #selector(AppDelegate.currentAppChanged), name: NSNotification.Name.NSWorkspaceDidActivateApplication, object: nil)
        
        // we show the permanent emoji Touch Bar:
        NSTouchBar.presentSystemModalFunctionBar(touchBar.systemModalTouchBar, systemTrayItemIdentifier: touchBar.emojiSystemModal.rawValue)

        // in case of a preferences files change:
        fileWatcher.watch { changeEvents in
            for _ in changeEvents {
                
                // update array containing recently used emojis:
                Emojis.arrayEmojis = Emojis.getFrequentlyUsedEmojis()
                
                // reload the data of the Touch Bar:
                self.touchBar.scrubber.reloadData()
                
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        // we close the app if the window gets closed:
        return true
    }

    func currentAppChanged() {
        // if we get the app changed event
        
        // get the list of active apps:
        let arrayActiveApps = NSWorkspace.shared().runningApplications
        for oneApp in arrayActiveApps {
            
            // for each one, we check if it's active:
            if(oneApp.isActive) {
                
                // get the bundle id of the active app:
                if let bundleIdentifier = oneApp.bundleIdentifier {
                    
                    // compare it to the list of apps that should have the permanent emoji bar:
                    let bundles = AppDelegate.emojisForApp.map({$0["bundle"]!})
                    
                    // if the current app is in the list, or if it's our own app:
                    if (bundles.contains(bundleIdentifier) || oneApp.bundleIdentifier == Bundle.main.bundleIdentifier) {
                        
                        // show the permanent emoji bar:
                        NSTouchBar.presentSystemModalFunctionBar(touchBar.systemModalTouchBar, systemTrayItemIdentifier: touchBar.emojiSystemModal.rawValue)
                        
                    } else {
                        
                        // if not in the list, hide the permanent emoji bar:
                        NSTouchBar.dismissSystemModalFunctionBar(touchBar.systemModalTouchBar)
                    }
                }
                
                // there should be only one:
                break
            }
        }
    }
    
    
    
}

