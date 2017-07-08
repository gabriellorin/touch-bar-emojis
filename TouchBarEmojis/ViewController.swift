//
//  ViewController.swift
//  TouchBarEmojis
//
//  Created by Gabriel Lorin
//

import Cocoa

@available(OSX 10.12.2, *)
class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    // help button:
    @IBAction func helpButtonClicked(_ sender: Any) {
        openGitHubLink()
    }
    
    // button with blue URL to GitHub:
    @IBOutlet weak var linkButton: NSButton!
    @IBAction func linkButtonClicked(_ sender: Any) {
        openGitHubLink()
    }
    
    // when update available:
    @IBAction func buttonLinkNewVersion(_ sender: Any) {
        openGitHubLink()
    }
    
    // menu action help:
    @IBAction func showHelp(_ sender: Any) {
        openGitHubLink()
    }
    
    // when update available, view:
    @IBOutlet weak var viewUpdateMessage: NSView!
    
    // table:
    @IBOutlet weak var appsTable: NSTableView!
    
    // table button remove:
    @IBOutlet weak var buttonRemove: NSButton!
    
    // table button remove clicked:
    @IBAction func buttonRemove(_ sender: Any) {
        buttonRemoveClicked()
    }
    
    // table button add clicked:
    @IBAction func buttonAdd(_ sender: Any) {
        buttonAddClicked()
    }
    
    // URL for GitHub:
    private let gitHubUrl = "https://github.com/gabriellorin/touch-bar-emojis"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // in case we want to reset the preferences settings:
        //UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
        
        // get saved apps list from app's preferences:
        if let loadedEmojisForApp = UserDefaults.standard.array(forKey: "SavedAppsForEmojis") as? [[String: String]] {
            // set the dic array:
            AppDelegate.emojisForApp = loadedEmojisForApp
        }
        
        // if no apps in list:
        if(AppDelegate.emojisForApp.count == 0) {
            
            // add default list:
            for oneApp in AppDelegate.defaultApps {
                // (addBundleAtPath will only add apps which exist)
                self.addBundleAtPath(path: oneApp)
            }
            
            
        }
        
        // setting up table:
        self.appsTable.delegate = self
        self.appsTable.dataSource = self
        self.appsTable.reloadData()
        
        // blue link to GitHub:
        let blueLinkTitle = linkButton.title
        linkButton.attributedTitle = NSAttributedString(string: blueLinkTitle, attributes: [ NSForegroundColorAttributeName : NSColor.blue, NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue, NSFontAttributeName: NSFont.systemFont(ofSize: 13)])
        
        
        
        // check if the app has an update:
        checkForUpdate()

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        // if at least one item is selected:
        if(self.appsTable.selectedRow < 0) {
            // activate remove button:
            buttonRemove.isEnabled = false
        } else {
            buttonRemove.isEnabled = true
        }
    }
    
    func addBundleAtPath(path: String) {
        // from a path, we get the app's name and bundle id:
        if let bundle = Bundle(path: path) {
            if let ident = bundle.bundleIdentifier {
                
                if let bundleAppName = NSURL(fileURLWithPath: path).lastPathComponent {
                    
                    // if the app has bundle id and name, we add it to our list of apps:
                    AppDelegate.emojisForApp.append(["name":bundleAppName, "bundle":ident])
                    
                    // store the new list to preferences file:
                    let defaults = UserDefaults.standard
                    defaults.set(AppDelegate.emojisForApp, forKey: "SavedAppsForEmojis")
                }
                
            } else {
                //bundle has no id
            }
        } else {
            // bundle not found
        }
    }
    
    func buttonRemoveClicked() {
        // clicked button to remove from table
        
        // multiple elements can be selected, stating from the end:
        for oneRow in self.appsTable.selectedRowIndexes.reversed() {
            
            // if element actually selected:
            if(oneRow > -1) {
                // removed starting from the end:
                AppDelegate.emojisForApp.remove(at: oneRow)
                
                // reload table:
                self.appsTable.reloadData()
                
                // store new table:
                let defaults = UserDefaults.standard
                defaults.set(AppDelegate.emojisForApp, forKey: "SavedAppsForEmojis")
                
                // disable remove button:
                buttonRemove.isEnabled = false
            }
        }
    }
    
    func buttonAddClicked() {
        // clicked button to add to table
        
        let dialog = NSOpenPanel();
        dialog.title                   = "Choose an app";
        dialog.showsResizeIndicator    = true;
        dialog.directoryURL = NSURL.fileURL(withPath: "/Applications/", isDirectory: true)
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["app"];
        dialog.beginSheetModal(for: self.view.window!, completionHandler: { num in
            if num == NSModalResponseOK {
                // get path:
                if let path = dialog.url?.path {
                    // add bundle at path:
                    self.addBundleAtPath(path: path)
                    // reload table:
                    self.appsTable.reloadData()
                    
                }
            } else {
                // user cancelled
            }
        })
    }
    
    func checkForUpdate() {
        let url = URL(string: "https://momoji.io/touchmoji/version.html")
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                        
                        if let strVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                            if let currentVersion = Float(strVersion) {
                                
                                if let webVersion = Float(stringData) {
                                    
                                    if(currentVersion < webVersion) {
                                        // new version, show update message in main qeue:
                                        DispatchQueue.main.async {
                                            () -> Void in
                                            self.viewUpdateMessage.isHidden = false
                                        }
                                        
                                    } else {
                                        // no new version
                                    }
                                }
                            }
                            
                        }
                        
                    }
                }
            })
            task.resume()
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return AppDelegate.emojisForApp.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        var result:NSTableCellView
        result  = tableView.make(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        // for each row, get the data:
        let rowAppIdentifier = AppDelegate.emojisForApp[row]
        
        // make sure we have a matching name for the app:
        if let appsName = rowAppIdentifier["name"] {
            // if we have, we display name:
            result.textField?.stringValue = appsName
        } else if let bundleName = rowAppIdentifier["bundle"] {
            // otherwise we display the bundle name
            result.textField?.stringValue = bundleName
        } else {
            // and default:
            result.textField?.stringValue = "unknown app name"
        }
        
        return result
    }
    
    func openGitHubLink() {
        let url = URL(string: gitHubUrl)!
        NSWorkspace.shared().open(url)
    }


}
