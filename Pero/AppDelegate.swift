//
//  AppDelegate.swift
//  Pero
//
//  Created by Junsung Park on 2020/10/28.
//  Copyright © 2020 Junsung Park. All rights reserved.
//

import Cocoa
import RZBluetooth
import CoreBluetooth

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
 

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)



    var ble:BLEManager!

       
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        if let button = statusItem.button {
            let image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
           button.image = image
         //  button.action = #selector(togglePopover(_:))
         }
        constructMenu()
        
     
        scanBLE()
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
    
    
    
    func constructMenu() {
      let menu = NSMenu()

      
        menu.addItem(NSMenuItem(title: "연결정보 연결알림", action: #selector(AppDelegate.printQuote(_:)), keyEquivalent: ""))
      
    //    menu.addItem(NSMenuItem.separator())
     
  //      menu.addItem(NSMenuItem(title: "로그인 정보 및 로그 오프", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
      
    
   //     menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "버전정보", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))

 //       menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "PERO(제품) 정보 및 업데이트 알림", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))

        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "종료", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

      statusItem.menu = menu
    }
    @objc func printQuote(_ sender: Any?) {
      let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
      let quoteAuthor = "Mark Twain"
      
      print("\(quoteText) — \(quoteAuthor)")
    }
    
    func scanBLE()
    {
       ble = BLEManager()
    }
    
 

}

