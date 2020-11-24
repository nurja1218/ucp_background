//
//  AppDelegate.swift
//  Pero
//
//  Created by Junsung Park on 2020/10/28.
//  Copyright © 2020 Junsung Park. All rights reserved.
//

import Cocoa
//import RZBluetooth
import CoreBluetooth
import CoreData
import ServiceManagement


@available(OSX 11.0, *)
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
 

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)

 

    var ble:BLEManager!
    let popover = NSPopover()
    @objc func terminate() {
        NSApp.terminate(nil)
    }
       
     lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "Users") // 여기는 파일명을 적어줘요.
          
          let storeURL = URL.storeURL(for: "group.junsoft.data", databaseName: "Users")
          let storeDescription = NSPersistentStoreDescription()
          storeDescription.shouldInferMappingModelAutomatically = true
          storeDescription.shouldMigrateStoreAutomatically = true
          storeDescription.url = storeURL
          container.persistentStoreDescriptions = [storeDescription]
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error {
                   fatalError("Unresolved error, \((error as NSError).userInfo)")
               }
           })
           return container
       }()
    
    
    func fullScreenWindows(fullScreen: Bool) -> [CGWindowID] {
        var winList: [CGWindowID] = []
        //If the you want to get the windows in full screen, you MUST make sure the option excluding 'optionOnScreenOnly'
        let option: CGWindowListOption = fullScreen ? .excludeDesktopElements : [.excludeDesktopElements, .optionOnScreenOnly]
        guard let winArray: CFArray = CGWindowListCopyWindowInfo(option, kCGNullWindowID) else {
            return winList
        }
        for i in 0..<CFArrayGetCount(winArray) {

            //The current window's info
            let winInfo = unsafeBitCast(CFArrayGetValueAtIndex(winArray, i), to: CFDictionary.self)

            //The current window's bounds
            guard let boundsDict = (winInfo as NSDictionary)[kCGWindowBounds],
                let bounds = CGRect.init(dictionaryRepresentation: boundsDict as! CFDictionary) else {
                continue
            }

            //Check the window is in full screen
            guard __CGSizeEqualToSize(NSScreen.main!.frame.size, bounds.size) else {
                continue
            }

            //The current window's id
            guard let winId = (winInfo as NSDictionary)[kCGWindowNumber] as? CGWindowID,
                winId == kCGNullWindowID else {
                continue
            }

            winList.append(winId)
        }
        return winList
    }
    func applicationDidChangeOcclusionState(_ notification: Notification){
        print("hide")
      //  reconstructMenu0(name: "PERO")
     
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
            let image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
           button.image = image
         //  button.action = #selector(togglePopover(_:))
         }
        reconstructMenu0(name: "PERO")
        
     
        scanBLE()
        
        
        let app = NSApplication.shared
        
//        SMLoginItemSetEnabled ("com.junsoft.Pero", true) // NO to cancel launch at login
        let helperBundleId = "com.junsoft.Pero"
           let ret = SMLoginItemSetEnabled(helperBundleId as CFString, true)
          
        //app.addObserver(self, forKeyPath: "currentSystemPresentationOptions", options: NSKeyValueObservingOptions.new, context: nil)
        
     //   NSApp.setActivationPolicy(.prohibited)
        /*
        let mainAppIdentifier = "com.junsoft.Pero"
              let runningApps = NSWorkspace.shared.runningApplications
              let isRunning = !runningApps.filter { $0.bundleIdentifier == mainAppIdentifier }.isEmpty

              if !isRunning {
                  DistributedNotificationCenter.default().addObserver(self, selector: #selector(self.terminate), name: .killLauncher, object: mainAppIdentifier)

                  let path = Bundle.main.bundlePath as NSString
                  var components = path.pathComponents
                  components.removeLast()
                  components.removeLast()
                  components.removeLast()
                  components.append("MacOS")
                  components.append("MainApplication") //main app name

                  let newPath = NSString.path(withComponents: components)

                  NSWorkspace.shared.launchApplication(newPath)
              }
              else {
                  self.terminate()
              }
 */
     }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
/*
     백그라운드 처리는 PC 카카오톡과 같은 형태로 UI창을 닫더라도 Application은 종료되지 않고 계속 실행되어 있는 형태로 요청드립니다.
     백그라운드(UI는 닫혔으나 Application종료되지 않은 상태)에서의 기능은
     1. 연결정보 연결알림
     2. 로그인 정보 및 로그 오프
     3. 버전정보
     4. 종료
     5. PERO(제품) 정보 및 업데이트 알림
     */
    
    
    
  
    func reconstructMenu(name:String)
    {
        let menu = NSMenu()

    
        let title = "연결정보 : " + name + " 연결됨"
    
        menu.addItem(NSMenuItem(title: title, action: #selector(AppDelegate.dummy(_:)), keyEquivalent: ""))
        
        menu.addItem(NSMenuItem(title: "설정", action: #selector(AppDelegate.processSettings(_:)), keyEquivalent: ""))
  
        menu.addItem(NSMenuItem(title: "버전정보", action: #selector(AppDelegate.viewVersion(_:)), keyEquivalent: ""))

          
          menu.addItem(NSMenuItem(title: "업데이트", action: #selector(AppDelegate.dummy(_:)), keyEquivalent: ""))

          menu.addItem(NSMenuItem.separator())
          
          menu.addItem(NSMenuItem(title: "종료", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))


            
            statusItem.menu = menu
    }
    
    func reconstructMenu0(name:String)
    {
        let menu = NSMenu()

    
        let title = "연결정보 : " + name + " 연결안됨"
        
        menu.addItem(NSMenuItem(title: title, action: nil, keyEquivalent: ""))
 
        menu.addItem(NSMenuItem(title: "설정", action: #selector(AppDelegate.processSettings(_:)), keyEquivalent: ""))
  
 
    
        menu.addItem(NSMenuItem(title: "버전정보", action: #selector(AppDelegate.viewVersion(_:)), keyEquivalent: ""))

          
          menu.addItem(NSMenuItem(title: "업데이트", action: #selector(AppDelegate.dummy(_:)), keyEquivalent: ""))

          menu.addItem(NSMenuItem.separator())
          
          menu.addItem(NSMenuItem(title: "종료", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "qf"))

  
        statusItem.menu = menu
    }
    @objc func processSettings(_ sender: Any?) {
    
        NSWorkspace.shared.launchApplication("PalmCat")
         
    }
    @objc func dummy(_ sender: Any?) {
    
   
         
    }
    @objc func viewVersion(_ sender: Any?) -> Bool{
    
        
        let alert = NSAlert()
        alert.messageText = ""
        

        alert.informativeText = "Version 1.0\n\nCopyrightⓒ PalmCat All rights reserved."
        alert.addButton(withTitle: "OK")
        alert.alertStyle = NSAlert.Style.warning

        let con =  ViewController.getController()
        return alert.runModal() == .alertFirstButtonReturn
 /*
        if let button = statusItem.button {
           popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
         }
 */
 
         
    }
    
    func scanBLE()
    {
        if(ble == nil)
        {
            ble = BLEManager()
            DispatchQueue.main.async { [self] in
                                                
                let instance = JoystickManager.sharedInstance()
                instance?.delegate = ble
                                             
            }
          
        
//            JoystickManager().setupGamepads()
       
        }
    }
    
 
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}

public extension URL {

    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

extension ViewController {
    // MARK: Storyboard instantiation
    static func getController() -> ViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("ViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("Why cant i find SampleViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
