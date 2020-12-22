//
//  BLEManager.swift
//  Pero
//
//  Created by Junsung Park on 2020/10/29.
//  Copyright © 2020 Junsung Park. All rights reserved.
//

import Cocoa
import CoreBluetooth
import CoreGraphics
import Carbon.HIToolbox
import GameController
//import RxBluetoothKit
import IOBluetooth


enum Button : Int {
  case a = 0
  case b
  case x
  case y
  case dpadUp
  case dpadDown
  case dpadLeft
  case dpadRight
  case menu
  case options
  case leftThumbstickButton
  case rightThumbstickButton
  case leftShoulder
  case rightShoulder
  case leftTrigger
  case rightTrigger
}

//@available(OSX 11.0, *)
@available(OSX 11.0, *)
class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate ,JoySticDelegate, IOBluetoothDeviceInquiryDelegate{
    func getIndex() -> Int32 {
        let userDefaults = UserDefaults(suiteName: "group.junsoft.data")
       let ret =    userDefaults!.integer(forKey:  "TOUCH_INDEX")
     
        return Int32(ret);
    }
    

    var ad:CGEvent!, au:CGEvent!,bd:CGEvent!,bu:CGEvent!,cd:CGEvent!,cu:CGEvent!,dd:CGEvent!
    ,du:CGEvent!,ed:CGEvent!,eu:CGEvent!,fd:CGEvent!,fu:CGEvent!,gd:CGEvent!,gu:CGEvent!
    ,hd:CGEvent!,hu:CGEvent!,id:CGEvent!,iu:CGEvent!,jd:CGEvent!,ju:CGEvent!,kd:CGEvent!
    ,ku:CGEvent!,ld:CGEvent!,lu:CGEvent!,md:CGEvent!,mu:CGEvent!,nd:CGEvent!,nu:CGEvent!
    ,od:CGEvent!,ou:CGEvent!,pd:CGEvent!,pu:CGEvent!,qd:CGEvent!,qu:CGEvent!,rd:CGEvent!
    ,ru:CGEvent!,sd:CGEvent!,su:CGEvent!,td:CGEvent!,tu:CGEvent!,ud:CGEvent!,uu:CGEvent!
    ,vd:CGEvent!,vu:CGEvent!,wd:CGEvent!,wu:CGEvent!,xd:CGEvent!,xu:CGEvent!,yd:CGEvent!
    ,yu:CGEvent!,zd:CGEvent!,zu:CGEvent!,cmdd:CGEvent!,cmdu:CGEvent!,shiftd:CGEvent!
    ,shiftu:CGEvent!,spcd:CGEvent!,spcu:CGEvent!,optiond:CGEvent!,optionu:CGEvent!,ctrld:CGEvent!
    ,ctrlu:CGEvent!,n0d:CGEvent!,n1d:CGEvent!,n2d:CGEvent!,n3d:CGEvent!,n4d:CGEvent!
    ,n5d:CGEvent!,n6d:CGEvent!,n7d:CGEvent!,n8d:CGEvent!,n9d:CGEvent!
    ,n0u:CGEvent!,n1u:CGEvent!,n2u:CGEvent!,n3u:CGEvent!,n4u:CGEvent!,n5u:CGEvent!
    ,n6u:CGEvent!,n7u:CGEvent!,n8u:CGEvent!,n9u:CGEvent!
        ,plusd:CGEvent!,plusu:CGEvent!,minusd:CGEvent!,minusu:CGEvent!,escd:CGEvent!,escu:CGEvent!
        ,returnd:CGEvent!,returnu:CGEvent!,downd:CGEvent!,downu:CGEvent!, upd:CGEvent!,upu:CGEvent!
        ,leftd:CGEvent!,leftu:CGEvent!,rightd:CGEvent!,rightu:CGEvent!,periodd:CGEvent!,periodu:CGEvent!
        ,commad:CGEvent!,commau:CGEvent!,enterd:CGEvent!,enteru:CGEvent!,equald:CGEvent!,equalu:CGEvent!
        ,lbracketd:CGEvent!,lbracketu:CGEvent!,rbracketd:CGEvent!,rbracketu:CGEvent!,endd:CGEvent!, endu:CGEvent!
        ,homed:CGEvent!,homeu:CGEvent!,spaced:CGEvent!, spaceu:CGEvent!,f1d:CGEvent!,f1u:CGEvent!
       
    
    var src:CGEventSource!

    let loc = CGEventTapLocation.cghidEventTap

 
    var bt = IOBluetoothDevice()
    
    var startDown:Bool!
    var sTimer = Timer()
   
  
    var downSuccess:Bool = false
    
    var downGesture:String = ""
  
    func startDownTimer()
    {
     
        startDown = true
        downGesture = ""

        sTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction0), userInfo: nil, repeats: false)
        
        
    }
    func endDownTimer()
    {
     
       // downGesture = ""
    //    startDown = false
        print("end timer")
    
        sTimer.invalidate()
        sTimer.fire()
  
        
    }
    @objc func timerAction0(){

        if let application = NSWorkspace.shared.frontmostApplication {
              
              
            if(application.localizedName == "Pero" )
            {
           
             
           
                JoystickManager.sharedInstance()?.error = false
     
          
                if(downGesture.count > 0)
                {
                    print("gesture down0:" + downGesture)
                    startDown = false
                    let ret = "palmcat://" + downGesture + "-"
                     NSWorkspace.shared.open(URL(string: ret)!)
         
                }
     
            }
               
        }
       // sTimer.fire()
 
        
    }
    func errorDown()
    {
        endDownTimer()
        print("error down")
  
        if let application = NSWorkspace.shared.frontmostApplication {
        
         
       
            if(application.localizedName == "Pero" )
            {
           
                downGesture =  String(100)
                if(downGesture.count > 0)
                {
                    print("gesture down1:" + downGesture)
              
                    if(startDown == true)
                    {
                        startDown = false
                        let ret = "palmcat://" + downGesture + "-"
                         NSWorkspace.shared.open(URL(string: ret)!)
                    }
                
         
                }
     
            }

      }

    }
    func touchDown(_ gesture: Int32) {
        
        // 16/12/8/2/1 -> Touch
        //15/13/9/2/1  -> Gesture
        if let application = NSWorkspace.shared.frontmostApplication {
          
            let index = getIndex()
            downGesture = String(gesture)
      
            if(index == 1)
            {
                if( gesture <= 10)
                {
                    downSuccess = true
                }
                else
                {
                    downSuccess = false
                    JoystickManager.sharedInstance()?.error = true
                    //[JoystickManager sharedInstance].error = true
                    errorDown()
       
                }
               
            }
            if(index == 2)
            {
                if( gesture >= 10 && gesture <= 13)
                {
                    downSuccess = true
  
                }
                else
                {
                    downSuccess = false
                    JoystickManager.sharedInstance()?.error = true
         
                    errorDown()
                }
                
            }
            if(index == 3)
            {
                if( gesture >= 13 && gesture <= 16)
                {
                    downSuccess = true
 
                }
                else
                {
                    downSuccess = false
                    JoystickManager.sharedInstance()?.error = true
         
                    errorDown()
                }
            }
            
            /*
              
            if(application.localizedName == "Pero" )
            {
           
                let ret = "palmcat://" + String(gesture) + "-"
                 NSWorkspace.shared.open(URL(string: ret)!)
     
            }
            */
               
        }
    }
    func touchUp(_ gesture: Int32) {
        
        // 16/12/8/2/1 -> Touch
        //15/13/9/2/1  -> Gesture
        if let application = NSWorkspace.shared.frontmostApplication {
              
              
            if(application.localizedName == "Pero" )
            {
           /*
                let ret = "palmcat://" + String(gesture) + "+";
              
                NSWorkspace.shared.open(URL(string: ret)!)
 */
                if(JoystickManager.sharedInstance()?.error == false && startDown == false)
                {
                    print("gesture up:" + downGesture)
                    let ret = "palmcat://" + downGesture + "+";
                  
                    NSWorkspace.shared.open(URL(string: ret)!)
                    
                    downGesture = ""
                   
                    sTimer.invalidate()
                    sTimer.fire()
             
                }
                else
                {
                    print("gesture up else :" + downGesture)
                    sTimer.invalidate()
                    sTimer.fire()
                    
                }
               
                
             
            }
               
        }
    
    }
 
    func pluged() {
        let appDelegate: AppDelegate? =  NSApp.delegate as! AppDelegate//NSApplication.shared.delegate as! AppDelegate
      
        appDelegate!.reconstructMenu(name:"PERO")
        
  
     //   JoystickManager.sharedInstance()?.mode = false
        manager.stopScan()
   /*
        if(self.peripheral != nil)
        {
            manager.cancelPeripheralConnection(self.peripheral)
     
        }
 */
        
    
        if(userID.count > 0)
        {
    
        //    CoreDataManager.shared.updateUser(id: userID, touch: false)

        }
    }
    
    func unpluged(_ device: NSMutableDictionary!) {
        device.removeAllObjects()
        disconnect()
        let appDelegate: AppDelegate? =  NSApp.delegate as! AppDelegate//NSApplication.shared.delegate as! AppDelegate
       // JoystickManager.sharedInstance()?.mode = false
        appDelegate!.reconstructMenu0(name:"PERO")
       
     //   let user = CoreDataManager.shared.getUser()

        if(userID.count > 0)
        {
    
       //     CoreDataManager.shared.updateUser(id: userID, touch: false)

        }
 
    }
    /*
     
 
  

   
     else if( num == "15")
     {
         selectedGestureIndex = 15
         selectedGesture = "RDLD"
         selectedCode = ModelManager.shared.RightDownLeftDownCurve()

     }
     */
    func getGesture(code:String) -> String
    {
        let ret = String()
        if(code ==      "001000")
        {
            return "L"
        }
        else if(code == "000100")
        {
            return "R"
 
        }
        else if(code == "100000")
        {
            return "U"
 
        }
        else if(code == "010000")
        {
            return "D"
 
            
        }
        else if(code == "101000")
        {
            return "LU"
 
        }
        else if(code == "100100")
        {
            return "RU"
 
        }
        else if(code == "011000")
        {
            return "LD"
 
        }
        else if(code == "010100")
        {
            return "RD"
 
        }
        else if(code == "101001")
        {
            return "LUC"
 
        }
        else if(code == "100101")
        {
            return "RUC"
 
        }
        else if(code == "011010")
        {
            return "LDC"
 
        }
        else if(code == "010110")
        {
            return "RDC"
 
        }
        else if(code == "101010")
        {
            return "LURU"
 
        }
        else if(code == "011001")
        {
            return "LDRD"
 
        }
        else if(code == "100101")
        {
            return "RULU"
 
        }
        else if(code == "010101")
        {
            return "RDLD"
 
        }
        else if(code == "000000")
        {
            return "TOUCH"
 
        }
        //
        return ret
    }
  
    func toggle(_ mode: Bool) {
    
      //  let user = CoreDataManager.shared.getUser()

        
        
         if(mode == true) // TouchMode
        {
          //  JoystickManager.sharedInstance()?.mode = true
            
      
            if(userID.count > 0)
            {
        
      //          CoreDataManager.shared.updateUser(id: userID, touch: true)

            }
 
            return
            
        }
        else
         {
         //   JoystickManager.sharedInstance()?.mode = false
            
            if(userID.count > 0)
            {
        
     //           CoreDataManager.shared.updateUser(id: userID, touch: false)

            }
 
            return
         }
    }
    func modSet()
    {
        
        let userDefaults = UserDefaults(suiteName: "group.junsoft.data")
       
        JoystickManager.sharedInstance()?.mode = userDefaults!.bool(forKey: "TOUCH_MODE")
   
        /*
        
        CoreDataManager.shared.getMode { ( success) in
            
            JoystickManager.sharedInstance()?.mode = success
   
           
        }
 */
        
    
       
    }
    
    func processCommand(shortcut:String, name:String)
    {
        if let app = NSWorkspace.shared.frontmostApplication{
   
      
              if(app.bundleIdentifier == "com.apple.Safari" || app.bundleIdentifier == "com.google.Chrome"
                    || app.bundleIdentifier == "org.mozilla.firefox"
                       
                 //
              )
            {
             //   print(app.activeTabTitle)
            
                if((app.activeTabTitle?.lowercased().contains(find:"netflix"))! && name == "Netflix")
                {
                    // Netflix 실행
                    //
                    Command(shortcut: shortcut)
                    return
           
                }
                else if(app.bundleIdentifier == "com.apple.safari"  && name == "Safari")
                {
                    Command(shortcut: shortcut)
                    return
     
                }
                else if(app.bundleIdentifier == "com.google.Chrome"  && name == "Chrome" && ((app.activeTabURL?.contains("youtube")) == false))
                {
                    Command(shortcut: shortcut)
                    return
     
                }
                else if(app.bundleIdentifier == "org.mozilla.firefox"  && name == "Firefox")
                {
                    Command(shortcut: shortcut)
                    return
     
                }
                else if((app.activeTabTitle?.lowercased().contains(find:"evernote"))! && name == "Evernote")
                {
                    // Netflix 실행
                    //
                    Command(shortcut: shortcut)
                    return
           
                }
                else if((app.activeTabTitle?.contains(find:"Google 문서") == true) && name == "Google docs")
                {
                    // Netflix 실행
                    //
                    Command(shortcut: shortcut)
                    return
           
                }
                else if((app.activeTabTitle?.contains(find:"Google 스프레드시트"))! && name == "Google spreadsheet")
                {
                    // Netflix 실행
                    //
                    Command(shortcut: shortcut)
                    return
           
                }
                else if((app.activeTabTitle?.contains(find:"Google 프리젠테이션"))! && name == "Google slides")
                {
                    // Netflix 실행
                    //
                    Command(shortcut: shortcut)
                    return
           
                }
                else if( name == "Youtube"
               
                            && app.activeTabTitle?.lowercased().contains(find:"evernote") == false
                            && app.activeTabTitle?.lowercased().contains(find:"netflix") == false
                             && app.activeTabTitle?.contains(find:"Google 프리젠테이션") == false
                            && app.activeTabTitle?.contains(find:"Google 스프레드시트") == false
                            && app.activeTabTitle?.contains(find:"Google 문서") == false
               
           )
                {
                    // Netflix 실행
                    //
                    print("Youtube")
            
                    Command(shortcut: shortcut)
                    return
           
                }
           }
            else
            {
                print("app.activeTabURL else", app.activeTabURL)
         
                Command(shortcut: shortcut)

            }
           
        }
    }
    
    func pressed(_ gesture: String!) {
        print(gesture)
        print(JoystickManager.sharedInstance()?.touches)
 
        // 16/12/8/2/1 -> Touch
        //15/13/9/2/1  -> Gesture
 
     
    
     //   let user = CoreDataManager.shared.getUser()
   
        let userDefaults = UserDefaults(suiteName: "group.junsoft.data")
      
        userID = userDefaults!.string(forKey: "USER_ID")!
        if(userID == nil || userID.count == 0)
        {
            return
        }
      

        var touches = "t3"
        
        let Gesture = gesture.prefix(6)
       // JoystickManager.sharedInstance()?.mode = false
  
        if(gesture == "0000000000000010" || gesture == "0000000000000001")
        {
      //      CoreDataManager.shared.updateUser(id: userID, touch: true)
            JoystickManager.sharedInstance()?.mode = true
            //"0000000000000010"
        //    CoreDataManager.shared.updateUser(id: userID, touch: true)
     
            return

        }
        else if(gesture == "1100000000000010")
        {
            // Gesture mode 변경
            //"1100000000000010"
           // CoreDataManager.shared.updateUser(id: userID, touch: false)
            JoystickManager.sharedInstance()?.mode = false
            return
        }
        let Touch = gesture.suffix(8)
        
      
        if(touches == "t4")
        {
            print("t4")
        }
        let touch = gesture.suffix(8)
        
        var cnt:Int = 0
       
        var flag:Bool = false
        /*
        for (index, char) in touch.enumerated() {
            print("index = \(index), character = \(char)")
            if((index == 0 || index == 1 ) && char == "1")
            {
                flag = true
            }
            if(char == "1")
            {
                cnt = cnt + 1
            }
        }
        print(touch)
 */
        if(cnt > 4 && flag == true)
        {
          //  touches = "t4"
        }
        print(touches)
      
        if let application = NSWorkspace.shared.frontmostApplication {
              
              
            if(application.localizedName == "Pero" && Gesture == "000000")
            {
           
                /*
                NSLog("localizedName: \(String(describing: application.localizedName)), processIdentifier: \(application.processIdentifier)")
          //      let ret = "palmcat://" + String(JoystickManager.sharedInstance()!.touches)
                let ret = "palmcat://" + String(Touch)
              
                NSWorkspace.shared.open(URL(string: ret)!)
                
                JoystickManager.sharedInstance()?.gesture = ""
                JoystickManager.sharedInstance().down = 0
                JoystickManager.sharedInstance().up = 0
                JoystickManager.sharedInstance()?.touches = 0
                */

                return
            }
               
        }
        let gesureCode = getGesture(code: String(Gesture))
        
        let commands = CoreDataManager.shared.getGesture(name: gesureCode, touches: touches,id:userID)
        
        print(gesureCode)
        
        var bMac:Bool = false
        
        for command in commands
        {
            let name = command.name
            let shortcut = command.shortcut
            let enable = command.enable
         
            if(name == "MacOS")
            {
                if(enable == true)
                {
                    bMac =  true
                    Command(shortcut: shortcut!)
             
                }
                
                return
   
       
            }
        }
     
        for command in commands
        {
            let shortcut = command.shortcut
            let name = command.name
            let c = command.command
            let gesture = command.gesture
            let enable = command.enable
         
            print(name)
            print(c)
            print(shortcut)
            print(gesture)
            if(enable == true)
            {
              
               
                processCommand(shortcut: shortcut!, name: name!)
         
                
               
       
            }
    
        }
        
 
        JoystickManager.sharedInstance()?.gesture = ""
        JoystickManager.sharedInstance().down = 0
        JoystickManager.sharedInstance().up = 0
        JoystickManager.sharedInstance()?.touches = 0

        
    }
    
   
    func pressed1(_ gesture: String!) {
        print(gesture)
        print(JoystickManager.sharedInstance()?.touches)
 
        // 16/12/8/2/1 -> Touch
        //15/13/9/2/1  -> Gesture
 
        let userDefaults = UserDefaults(suiteName: "group.junsoft.data")
      
        userID = userDefaults!.string(forKey: "USER_ID")!
        if(userID == nil || userID.count == 0)
        {
            return
        }
    
     //   let user = CoreDataManager.shared.getUser()
   
       

        var touches = "t4"
        
        let Gesture = gesture.prefix(6)
       // JoystickManager.sharedInstance()?.mode = false
  
        if(gesture == "0000000000000010" || gesture == "0000000000000001")
        {
      //      CoreDataManager.shared.updateUser(id: userID, touch: true)
            JoystickManager.sharedInstance()?.mode = true
            //"0000000000000010"
        //    CoreDataManager.shared.updateUser(id: userID, touch: true)
     
            return

        }
        else if(gesture == "1100000000000010")
        {
            // Gesture mode 변경
            //"1100000000000010"
           // CoreDataManager.shared.updateUser(id: userID, touch: false)
            JoystickManager.sharedInstance()?.mode = false
            return
        }
        let Touch = gesture.suffix(8)
        
      
        if(touches == "t4")
        {
            print("t4")
        }
        let touch = gesture.suffix(8)
        
        var cnt:Int = 0
       /*
        var flag:Bool = false
        for (index, char) in touch.enumerated() {
            print("index = \(index), character = \(char)")
            if((index == 0 || index == 1 ) && char == "1")
            {
                flag = true
            }
            if(char == "1")
            {
                cnt = cnt + 1
            }
        }
        print(touch)
 */
      
        if let application = NSWorkspace.shared.frontmostApplication {
              
              
            if(application.localizedName == "Pero" && Gesture == "000000")
            {
           
                /*
                NSLog("localizedName: \(String(describing: application.localizedName)), processIdentifier: \(application.processIdentifier)")
          //      let ret = "palmcat://" + String(JoystickManager.sharedInstance()!.touches)
                let ret = "palmcat://" + String(Touch)
              
                NSWorkspace.shared.open(URL(string: ret)!)
                
                JoystickManager.sharedInstance()?.gesture = ""
                JoystickManager.sharedInstance().down = 0
                JoystickManager.sharedInstance().up = 0
                JoystickManager.sharedInstance()?.touches = 0
                */

                return
            }
               
        }
        let gesureCode = getGesture(code: String(Gesture))
        
        let commands = CoreDataManager.shared.getGesture(name: gesureCode, touches: touches,id:userID)
        
        print(gesureCode)
     
        var bMac:Bool = false
        
        for command in commands
        {
            let name = command.name
            let shortcut = command.shortcut
            let enable = command.enable
         
            if(name == "MacOS")
            {
                if(enable == true)
                {
                    bMac =  true
                    Command(shortcut: shortcut!)
                    return
       
                }
                
            
       
            }
        }
        
        
        for command in commands
        {
            let shortcut = command.shortcut
            let name = command.name
            let c = command.command
            let gesture = command.gesture
            let enable = command.enable
         
            print(name)
            print(c)
            print(shortcut)
            print(gesture)
            if(enable == true)
            {
               
                /*
                if(name == "Chrome")
                {
                    if let application = NSWorkspace.shared.frontmostApplication {
                     
                       print(application.localizedName)
                        if(application.localizedName != "Google Chrome")
                        {
                           
                            continue
                        }
                    }
                }
                */
                processCommand(shortcut: shortcut!, name: name!)
         
                
               
               
            
           
            }
    
        }
        
 
        JoystickManager.sharedInstance()?.gesture = ""
        JoystickManager.sharedInstance().down = 0
        JoystickManager.sharedInstance().up = 0
        JoystickManager.sharedInstance()?.touches = 0

        
    }
    
    
   
    
   private var manager: CBCentralManager!
    
    var peripheral:CBPeripheral!
    
    var gamepad:GCMicroGamepad!
    
    
    var hidManager:IOHIDManager!
    var userID:String = ""

    func deviceInquiryStarted(_ sender: IOBluetoothDeviceInquiry) {
        print("Inquiry Started...")
    }
    func deviceInquiryDeviceFound(_ sender: IOBluetoothDeviceInquiry, device: IOBluetoothDevice) {
        print("\(device.name!)")
    }
    func deviceInquiryComplete(_ sender: IOBluetoothDeviceInquiry!, error: IOReturn, aborted: Bool) {
    //optional, but can notify you once the inquiry is completed.
        print("Inquiry completed...")
        let devices = sender.foundDevices()
              for device : Any? in devices! {
                  if let thingy = device as? IOBluetoothDevice {
                      thingy.getAddress()
                  }
              }
    }
        


   required override init() {
      super.init()
    manager = CBCentralManager.init(delegate: self, queue: DispatchQueue.main)
    
   
     
        /*
    var ibdi = IOBluetoothDeviceInquiry(delegate: self)
    ibdi?.updateNewDeviceNames = true

    //ibdi?.updateNewDeviceNames = true
   // ibdi?.searchType = IOBluetoothDeviceSearchTypes

    ibdi?.start()
    
    
    for i in IOBluetoothDevice.pairedDevices() {
               let device = i as! IOBluetoothDevice
               print("device: ", device.name)
          
    }
 */
  //  GCController.startWirelessControllerDiscovery(completionHandler: {})
    
    /*
    let state: BluetoothState = centralManager.state
    let disposable = centralManager.observeState()
         .startWith(state)
         .filter { $0 == .poweredOn }
    
    let AutomationIO = CBUUID(string:"504618FC-2F17-431C-BBB2-27E7F0DD34D3")
   
    centralManager.scanForPeripherals(withServices:[ AutomationIO])
        .subscribe(onNext: { scannedPeripheral in
            let advertisementData = scannedPeripheral.advertisementData
            
            
            print(scannedPeripheral.peripheral.name)
  
            if(scannedPeripheral.peripheral.name == "PERO2")
            {
                scannedPeripheral.peripheral.establishConnection()
                print("PERO2 connect")
            }
        })
    */
    let user = CoreDataManager.shared.getUser()
    
    let userDefaults = UserDefaults(suiteName: "group.junsoft.data")
  
    userID = userDefaults!.string(forKey: "USER_ID")!
  
 
  // userID = user.userid!
    
    /*
    if( user.touch == true)
    {
        JoystickManager.sharedInstance()?.mode = true
   
    }
    else
    {
        JoystickManager.sharedInstance()?.mode = false
   
    }
    */
    pressDummy()
    
   // simulEmoji2()
    
    initKey()
    
    
    if let application = NSWorkspace.shared.frontmostApplication {
          
        NSLog("localizedName: \(String(describing: application.localizedName)), processIdentifier: \(application.processIdentifier)")
          
           
    }
    
    
   
    
    
   }
    
   func downShortcut()
   {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

        /// ㅅ크린캡쳐 시뮬레이션  /////////////////////
       
        let downd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_DownArrow), keyDown: true)
        let downu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_DownArrow), keyDown: false)
      

        let loc = CGEventTapLocation.cghidEventTap

        downd?.post(tap: loc)
      
        downu?.post(tap: loc)
   }
   func centralManagerDidUpdateState(_ central: CBCentralManager) {
      var consoleLog = ""

      switch central.state {
      case .poweredOff:
          consoleLog = "BLE is powered off"
      case .poweredOn:
          consoleLog = "BLE is poweredOn"
          central.scanForPeripherals(withServices: nil, options: nil)
        //  gestureTest()
          //0x78
          print("Scanning...")
        
      //  let user = CoreDataManager.shared.getUser(query: "jimmy@junsoft.org")
      //   let name = user.name
       //  getFucusedApplication()
         print("test")
            
       // initGamePad()
    
      case .resetting:
          consoleLog = "BLE is resetting"
      case .unauthorized:
          consoleLog = "BLE is unauthorized"
      case .unknown:
          consoleLog = "BLE is unknown"
      case .unsupported:
          consoleLog = "BLE is unsupported"
      default:
          consoleLog = "default"
      }
      print(consoleLog)
   }
    

    func Command(shortcut:String)
    {
        
        var temp = ""//shortcut
        
        temp = shortcut
        
        let list = temp.components(separatedBy:  "+")
                
      
        if(list.count == 1) // 단일명령문
        {
            
            initOne(command: shortcut,isCommand: false, isShift: false)
  
        }
        else if(list.count == 2)
        {
            var isCmd:Bool = false
            
            var isOption:Bool = false
         
            
            var isShift:Bool = false
            var isCtrl:Bool = false
         
           
         /*
            if((list[0] == "CTRL" || list[0] == "COMMAND" || list[0] == "CMD"))
            {
                isCmd = true
            }
            if(list[1] == "OPTION" )
            {
                isOption = true
            }
            */
            for i in 0...list.count - 1 {
                //print(n)
                if(list[i] == "CMD"  || list[i] == "COMMAND" )
                {
                    isCmd = true
                }
                if(list[i] == "CTRL"  )
                {
                    isCtrl = true
                }
                else if(list[i] == "OPTION"  )
                {
                    isOption = true
                }
                else if(list[i] == "SHIFT"  )
                {
                    isShift = true
                }
                else
                {
                    initOne(command: list[i], isCommand: isCmd, isShift: isShift, isOption: isOption, isCtrl: isCtrl)

                }
            }
            
            
        }
        else if(list.count == 3)
        {
            var isCmd:Bool = false
            
            var isOption:Bool = false
         
            
            var isShift:Bool = false
            
           
         
            if((list[0] == "CTRL" || list[0] == "COMMAND" || list[0] == "CMD"))
            {
                isCmd = true
            }
            if(list[1] == "OPTION" )
            {
                isOption = true
            }
            
            for i in 0...list.count - 1 {
                //print(n)
                if(list[i] == "CMD" || list[i] == "CTRL" || list[i] == "COMMAND" )
                {
                    isCmd = true
                }
                else if(list[i] == "OPTION"  )
                {
                    isOption = true
                }
                else if(list[i] == "SHIFT"  )
                {
                    isShift = true
                }
                else
                {
                    initOne(command: list[i], isCommand: isCmd, isShift: isShift, isOption: isOption)

                }
            }

            
            /*
            if((list[0] == "CTRL" || list[0] == "COMMAND" || list[0] == "CMD"))
       
                
                initOne(command: list[1], isCommand: true, isShift: false)

            }
            if(list[0] == "SHIFT")
            {
                print("SHIFT command0")
                initOne(command: list[1], isCommand: false, isShift: true)

            }
 */
        
        }


    }
    func  initOne(command:String, isCommand:Bool, isShift:Bool, isOption:Bool = false, isCtrl:Bool = false)
    {
        if(command == "DOWN")
        {
            if(isCommand == true && isShift == false && isShift == false && isCtrl == false)
            {
                downd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true && isShift == false && isCtrl == false)
            {
                downd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true && isShift == false && isCtrl == false)
            {
                downd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true && isShift == false && isCtrl == false)
            {
                downd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                downd?.flags = CGEventFlags.maskSecondaryFn

            }
            downd?.post(tap: loc)
            downu?.post(tap: loc)
         
        }
        if(command == "UP")
        {
            if(isCommand == true && isShift == false && isOption == false && isCtrl == false)
            {
                upd?.flags = CGEventFlags.maskCommand
                upd?.post(tap: loc)
                upu?.post(tap: loc)
            
            }
            if(isCommand == false && isShift == true && isOption == false && isCtrl == false)
            {
                upd?.flags = CGEventFlags.maskShift
                upd?.post(tap: loc)
                upu?.post(tap: loc)
            
            }
            if(isCommand == false && isShift == false && isOption == false && isCtrl == true)
            {
                NSWorkspace.shared.launchApplication("Mission Control")

  
            }
            if(isCommand == true && isShift == true && isOption == false && isCtrl == false)
            {
                upd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]
                upd?.post(tap: loc)
                upu?.post(tap: loc)
            
            }
            if(isCommand == true &&  isOption == true  && isCtrl == false)
            {
                upd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]
                upd?.post(tap: loc)
                upu?.post(tap: loc)
            
            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                upu?.flags = CGEventFlags.maskSecondaryFn
                upd?.post(tap: loc)
                upu?.post(tap: loc)
     
            }
        }
        if(command == "LEFT")
        {
            if(isCommand == true && isShift == false && isOption == false && isCtrl == false)
            {
                leftd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true && isOption == false && isCtrl == false)
            {
                leftd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == false && isShift == false && isOption == false && isCtrl == true)
            {
               // rightd?.flags = CGEventFlags.maskControl
               // rightu?.flags = CGEventFlags.maskControl
              //  ctrld?.post(tap: loc)
               // ctrlu?.post(tap: loc)
                leftd?.flags = [CGEventFlags.maskControl, CGEventFlags.maskSecondaryFn]

            }
            if(isCommand == true && isShift == true && isOption == false && isCtrl == false)
            {
                leftd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true  && isCtrl == false && isShift == false)
            {
                leftd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                leftd?.flags = CGEventFlags.maskSecondaryFn

            }
 
            leftd?.post(tap: loc)
            leftu?.post(tap: loc)
         
        }
        if(command == "RIGHT")
        {
            if(isCommand == true && isShift == false && isOption == false && isCtrl == false)
            {
                rightd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true && isOption == false && isCtrl == false)
            {
                rightd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == false && isShift == false && isOption == false && isCtrl == true)
            {
               // rightd?.flags = CGEventFlags.maskControl
               // rightu?.flags = CGEventFlags.maskControl
              //  ctrld?.post(tap: loc)
               // ctrlu?.post(tap: loc)
                rightd?.flags = [CGEventFlags.maskControl, CGEventFlags.maskSecondaryFn]

            }
            if(isCommand == true && isShift == true && isOption == false && isCtrl == false)
            {
                rightd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true && isCtrl == false)
            {
                rightd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                rightd?.flags = CGEventFlags.maskSecondaryFn

            }
 
            rightd?.post(tap: loc)
            rightu?.post(tap: loc)
         
        }
        if(command == "ESC")
        {
            var flagRaw : UInt64 = 0

            if(isCommand == true && isShift == false && isOption == false && isCtrl == false)
            {
                escd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false )
            {
                escd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&   isOption == false && isCtrl == false )
            {
                escd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true && isShift == false && isCtrl == false)
            {
              //  flagRaw = CGEventFlags.maskCommand.rawValue
                escd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate,  CGEventFlags.maskSecondaryFn]
          //      escd?.flags =  CGEventFlags(rawValue:CGEventFlags.maskAlternate.rawValue | flagRaw)

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                escd?.flags = CGEventFlags.maskSecondaryFn

            }
            escd?.post(tap: loc)
            escu?.post(tap: loc)
         
        }
        if(command == "a")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                ad?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                ad?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                ad?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                ad?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                ad?.flags = CGEventFlags.maskSecondaryFn

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                ad?.flags = CGEventFlags.maskSecondaryFn

            }
            ad?.post(tap: loc)
            au?.post(tap: loc)
         
        }
        if(command == "b")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                bd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                bd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                bd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                bd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                bd?.flags = CGEventFlags.maskSecondaryFn

            }
            bd?.post(tap: loc)
            bu?.post(tap: loc)

        }
        if(command == "c")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                cd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                cd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                cd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                cd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                cd?.flags = CGEventFlags.maskSecondaryFn

            }

            cd?.post(tap: loc)
            cu?.post(tap: loc)

        }
        if(command == "d")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                dd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                dd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                dd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                dd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                dd?.flags = CGEventFlags.maskSecondaryFn

            }

            dd?.post(tap: loc)
            du?.post(tap: loc)

        }
        if(command == "e")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                ed?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                ed?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                ed?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                ed?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                ed?.flags = CGEventFlags.maskSecondaryFn

            }

            ed?.post(tap: loc)
            eu?.post(tap: loc)

        }
        if(command == "f")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                fd?.flags = CGEventFlags.maskCommand
                print("f0")

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                fd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                fd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]
                print("f1")

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                fd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                fd?.flags = CGEventFlags.maskSecondaryFn

            }

            print("f2")

            fd?.post(tap: loc)
            fu?.post(tap: loc)

        }
        if(command == "g")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                gd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                gd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                gd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                gd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                gd?.flags = CGEventFlags.maskSecondaryFn

            }

            gd?.post(tap: loc)
            gu?.post(tap: loc)

        }
        if(command == "h")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                hd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                hd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                hd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                hd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                hd?.flags = CGEventFlags.maskSecondaryFn

            }

            hd?.post(tap: loc)
            hu?.post(tap: loc)

        }
        if(command == "i")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                id?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                id?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                id?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                id?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                id?.flags = CGEventFlags.maskSecondaryFn

            }

            id?.post(tap: loc)
            iu?.post(tap: loc)

        }
        if(command == "j")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                jd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                jd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                jd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                jd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                jd?.flags = CGEventFlags.maskSecondaryFn

            }
            jd?.post(tap: loc)
            ju?.post(tap: loc)

        }
        if(command == "k")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                kd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                kd?.flags = CGEventFlags.maskShift
       
            }
             if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                kd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                kd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                kd?.flags = CGEventFlags.maskSecondaryFn

            }


            kd?.post(tap: loc)
            ku?.post(tap: loc)

        }
        if(command == "l")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                ld?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                ld?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                ld?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                ld?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                ld?.flags = CGEventFlags.maskSecondaryFn

            }
            ld?.post(tap: loc)
            lu?.post(tap: loc)

        }
        if(command == "m")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                md?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                md?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                md?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                md?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                md?.flags = CGEventFlags.maskSecondaryFn

            }

            md?.post(tap: loc)
            mu?.post(tap: loc)

        }
        if(command == "n")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                nd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                nd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                nd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                nd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                nd?.flags = CGEventFlags.maskSecondaryFn

            }

            nd?.post(tap: loc)
            nu?.post(tap: loc)

        }
        if(command == "o")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                od?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                od?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                od?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                od?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                od?.flags = CGEventFlags.maskSecondaryFn

            }

            od?.post(tap: loc)
            ou?.post(tap: loc)

        }
        if(command == "p")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                pd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                pd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                pd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                pd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                pd?.flags = CGEventFlags.maskSecondaryFn

            }

            pd?.post(tap: loc)
            pu?.post(tap: loc)

        }
        if(command == "q")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                qd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                qd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                qd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                qd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                qd?.flags = CGEventFlags.maskSecondaryFn

            }

            qd?.post(tap: loc)
            qu?.post(tap: loc)

        }
        if(command == "r")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                rd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                rd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                rd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                rd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                rd?.flags = CGEventFlags.maskSecondaryFn

            }

            rd?.post(tap: loc)
            ru?.post(tap: loc)

        }
        if(command == "s")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                sd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                sd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                sd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                sd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                sd?.flags = CGEventFlags.maskSecondaryFn

            }

            sd?.post(tap: loc)
            su?.post(tap: loc)

        }
        if(command == "t")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                td?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                td?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                td?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                td?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                td?.flags = CGEventFlags.maskSecondaryFn

            }

            td?.post(tap: loc)
            tu?.post(tap: loc)

        }
        if(command == "u")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                ud?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                ud?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                ud?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                ud?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                ud?.flags = CGEventFlags.maskSecondaryFn

            }

            ud?.post(tap: loc)
            uu?.post(tap: loc)

        }
        if(command == "v")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                vd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                vd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                vd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                vd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                vd?.flags = CGEventFlags.maskSecondaryFn

            }

            vd?.post(tap: loc)
            vu?.post(tap: loc)

        }
        if(command == "w")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                wd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                wd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                wd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                wd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                wd?.flags = CGEventFlags.maskSecondaryFn

            }

            wd?.post(tap: loc)
            wu?.post(tap: loc)

        }
        if(command == "x")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                xd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                xd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                xd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                xd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                xd?.flags = CGEventFlags.maskSecondaryFn

            }

            xd?.post(tap: loc)
            xu?.post(tap: loc)

        }
        if(command == "y")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                yd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                yd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                yd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                yd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                yd?.flags = CGEventFlags.maskSecondaryFn

            }

            yd?.post(tap: loc)
            yu?.post(tap: loc)

        }
        if(command == "z")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                zd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                zd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                zd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                zd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                zd?.flags = CGEventFlags.maskSecondaryFn

            }

            zd?.post(tap: loc)
            zu?.post(tap: loc)

        }
        if(command == "0")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                n0d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                n0d?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                n0d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                n0d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                n0d?.flags = CGEventFlags.maskSecondaryFn

            }

            n0d?.post(tap: loc)
            n0u?.post(tap: loc)

        }
        if(command == "1")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                n1d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                n1d?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                n1d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                n1d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                n1d?.flags = CGEventFlags.maskSecondaryFn

            }

            n1d?.post(tap: loc)
            n1u?.post(tap: loc)
        }
        if(command == "2")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                n2d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                n2d?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                n2d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                n2d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                n2d?.flags = CGEventFlags.maskSecondaryFn

            }

            n2d?.post(tap: loc)
            n2u?.post(tap: loc)
        }
        if(command == "3")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                n3d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                n3d?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                n3d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                n3d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                n3d?.flags = CGEventFlags.maskSecondaryFn

            }

            n3d?.post(tap: loc)
            n3u?.post(tap: loc)
        }
        if(command == "4")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                n4d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                n4d?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                n4d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                n4d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                n4d?.flags = CGEventFlags.maskSecondaryFn

            }

            n4d?.post(tap: loc)
            n4u?.post(tap: loc)
        }
        if(command == "5")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                n5d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                n5d?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                n5d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                n5d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                n5d?.flags = CGEventFlags.maskSecondaryFn

            }

            n5d?.post(tap: loc)
            n5u?.post(tap: loc)
        }
        if(command == "6")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                n6d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                n6d?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                n6d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                n6d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                n6d?.flags = CGEventFlags.maskSecondaryFn

            }
            n6d?.post(tap: loc)
            n6u?.post(tap: loc)
        }
        if(command == "7")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                n7d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                n7d?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                n7d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                n7d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                n7d?.flags = CGEventFlags.maskSecondaryFn

            }

            n7d?.post(tap: loc)
            n7u?.post(tap: loc)
        }
        if(command == "8")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                n8d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                n8d?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                n8d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                n8d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                n8d?.flags = CGEventFlags.maskSecondaryFn

            }

            n8d?.post(tap: loc)
            n8u?.post(tap: loc)
        }
        if(command == "9")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                n9d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                n9d?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                n9d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                n9d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                n9d?.flags = CGEventFlags.maskSecondaryFn

            }

            n9d?.post(tap: loc)
            n9u?.post(tap: loc)
        }
        if(command == ".")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                periodd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                periodd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                periodd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                periodd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                periodd?.flags = CGEventFlags.maskSecondaryFn

            }
            periodd?.post(tap: loc)
            periodu?.post(tap: loc)
        }
        if(command == ",")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                commad?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                commad?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                commad?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                commad?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                commad?.flags = CGEventFlags.maskSecondaryFn

            }
            commad?.post(tap: loc)
            commau?.post(tap: loc)


        }
        if(command == "SPACE")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                spcd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                spcd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                spcd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                spcd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                spcd?.flags = CGEventFlags.maskSecondaryFn

            }
            spcd?.post(tap: loc)
            spcu?.post(tap: loc)


        }
        if(command == "ENTER")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                enterd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                enterd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                enterd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                enterd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                enterd?.flags = CGEventFlags.maskSecondaryFn

            }
            enterd?.post(tap: loc)
            enteru?.post(tap: loc)


        }
        if(command == "]")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                rbracketd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                rbracketd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                rbracketd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                rbracketd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                rbracketd?.flags = CGEventFlags.maskSecondaryFn

            }
            rbracketd?.post(tap: loc)
            rbracketu?.post(tap: loc)


        }
        if(command == "[")
        {
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                lbracketd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                lbracketd?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                lbracketd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                lbracketd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                lbracketd?.flags = CGEventFlags.maskSecondaryFn

            }
            lbracketd?.post(tap: loc)
            lbracketu?.post(tap: loc)


        }
        if(command == "F1")
        {
            //
            if(isCommand == true && isShift == false &&  isOption == false && isCtrl == false)
            {
                f1d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == false && isShift == true &&  isOption == false && isCtrl == false)
            {
                f1d?.flags = CGEventFlags.maskShift
       
            }
            if(isCommand == true && isShift == true &&  isOption == false && isCtrl == false)
            {
                f1d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            if(isCommand == true &&  isOption == true &&  isShift == false && isCtrl == false)
            {
                f1d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskAlternate]

            }
            if(isCommand == false &&  isOption == false && isShift == false && isCtrl == false)
            {
                f1d?.flags = CGEventFlags.maskSecondaryFn

            }
            
            f1d?.post(tap: loc)
            f1u?.post(tap: loc)


        }
        //

    }
    func simulEmoji()
    {
        let commandControlMask = (CGEventFlags.maskCommand.rawValue | CGEventFlags.maskControl.rawValue)
        let commandControlMaskFlags = CGEventFlags(rawValue: commandControlMask)

              // Press Space key once
        let space = CGEventSource(stateID: .hidSystemState)
        let keyDown = CGEvent(keyboardEventSource: space, virtualKey: 49 as CGKeyCode, keyDown: true)
        keyDown!.flags = commandControlMaskFlags
        keyDown!.post(tap: .cghidEventTap)
        let keyUp = CGEvent(keyboardEventSource: space, virtualKey: 49 as CGKeyCode, keyDown: false)
        keyUp!.flags = commandControlMaskFlags
        keyUp!.post(tap: .cghidEventTap)
    }
    func simulEmoji1()
    {
        let commandControlMask = (CGEventFlags.maskControl.rawValue)
        let commandControlMaskFlags = CGEventFlags(rawValue: commandControlMask)

              // Press Space key once
        let space = CGEventSource(stateID: .hidSystemState)
        
     //   cmdd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Command), keyDown: true)
      
        let keyDown = CGEvent(keyboardEventSource: space, virtualKey: CGKeyCode(kVK_RightArrow), keyDown: true)//CGEvent(keyboardEventSource: space, virtualKey: 49 as CGKeyCode, keyDown: true)
        keyDown!.flags = commandControlMaskFlags
        keyDown!.post(tap: .cghidEventTap)
        let keyUp = CGEvent(keyboardEventSource: space, virtualKey: CGKeyCode(kVK_RightArrow), keyDown: false)//CGEvent(keyboardEventSource: space, virtualKey: 49 as CGKeyCode, keyDown: false)
        keyUp!.flags = commandControlMaskFlags
        keyUp!.post(tap: .cghidEventTap)
    }
    func CtrlWithKey(keyCode:UInt) {
        // 0x3b is Ctrl key
        let controlKeyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(0x3B), keyDown: true)
        controlKeyDownEvent?.flags = CGEventFlags.maskControl
        controlKeyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)

        let letterKeyDownEvent = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(keyCode), keyDown: true)
        letterKeyDownEvent?.flags = CGEventFlags.maskControl
        letterKeyDownEvent?.post(tap: CGEventTapLocation.cghidEventTap)

        let letterKeyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(keyCode), keyDown: false)
        letterKeyUpEvent?.flags = CGEventFlags.maskControl
        letterKeyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)

        let controlKeyUpEvent = CGEvent(keyboardEventSource: nil, virtualKey: CGKeyCode(0x3B), keyDown: false)
        controlKeyUpEvent?.flags = CGEventFlags.maskControl
        controlKeyUpEvent?.post(tap: CGEventTapLocation.cghidEventTap)
    }
    func simulEmoji2()
    {
        /*
        if let info = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID) as? [[ String : Any]] {
            for dict in info {
                // ...
             
                let appName = unsafeBitCast(CFDictionaryGetValue(dict as CFDictionary, unsafeBitCast(kCGWindowOwnerName, to: UnsafeRawPointer.self)), to: CFString.self)
                    
                
            }
        }
 */
        
   //     system("osascript -l JavaScript -e \"Application('System Events').processes['Finder'].menuBars[0].menus['Apple'].menuItems['Force Quit…'].click()\"");
       // NSWorkspace.shared.launchApplication("loginwindow")
     
        /*
        var str:String = " tell application \"System Events\" " +
        "set appList to the name of (every application process whose background only is false and name is not \"Force Quit Application\") " +
        "end tell"

      
        let script = NSAppleScript(source: str)!
        var errorDict : NSDictionary?
        script.executeAndReturnError(&errorDict)
        if errorDict != nil {
            print(errorDict!)
            
        }
 */
           //return
       
        let commandControlMask = (CGEventFlags.maskCommand.rawValue | CGEventFlags.maskAlternate.rawValue | CGEventFlags.maskSecondaryFn.rawValue)
        let commandControlMaskFlags = CGEventFlags(rawValue: commandControlMask)

              // Press Space key once
        let space = CGEventSource(stateID: .hidSystemState)
        
     //   cmdd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Command), keyDown: true)
      
        let keyDown = CGEvent(keyboardEventSource: space, virtualKey: CGKeyCode(kVK_Escape), keyDown: true)//CGEvent(keyboardEventSource: space, virtualKey: 49 as CGKeyCode, keyDown: true)
        keyDown!.flags = commandControlMaskFlags
        keyDown!.post(tap: .cghidEventTap)
        let keyUp = CGEvent(keyboardEventSource: space, virtualKey: CGKeyCode(kVK_Escape), keyDown: false)//CGEvent(keyboardEventSource: space, virtualKey: 49 as CGKeyCode, keyDown: false)
        keyUp!.flags = commandControlMaskFlags
        keyUp!.post(tap: .cghidEventTap)
    }
    
    
    func initKey()
    {
        src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        
        cmdd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Command), keyDown: true)
        cmdu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Command), keyDown: false)
       
        shiftd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Shift), keyDown: true)
        shiftu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Shift), keyDown: false)
  
        spcd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Space), keyDown: true)
        spcu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Space), keyDown: false)

      
        optiond = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Option), keyDown: true)
        optionu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Option), keyDown: false)

        ctrld = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Control), keyDown: true)
        ctrlu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Control), keyDown: false)

        

        ad = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_A), keyDown: true)
        bd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_B), keyDown: true)
        cd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_C), keyDown: true)
        dd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_D), keyDown: true)
        ed = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_E), keyDown: true)
        fd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_F), keyDown: true)
        gd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_G), keyDown: true)
        hd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_H), keyDown: true)
        id = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_I), keyDown: true)
        jd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_J), keyDown: true)
        kd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_K), keyDown: true)
        ld = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_L), keyDown: true)
        md = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_M), keyDown: true)
        nd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_N), keyDown: true)
        od = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_O), keyDown: true)
        pd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_P), keyDown: true)
        qd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_Q), keyDown: true)
        rd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_R), keyDown: true)
        sd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_S), keyDown: true)
        td = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_T), keyDown: true)
        ud = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_U), keyDown: true)
        vd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_V), keyDown: true)
        wd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_W), keyDown: true)
        xd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_X), keyDown: true)
        yd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_Y), keyDown: true)
        zd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_Z), keyDown: true)

        
        au = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_A), keyDown: false)
        bu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_B), keyDown: false)
        cu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_C), keyDown: false)
        du = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_D), keyDown: false)
        eu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_E), keyDown: false)
        fu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_F), keyDown: false)
        gu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_G), keyDown: false)
        hu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_H), keyDown: false)
        iu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_I), keyDown: false)
        ju = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_J), keyDown: false)
        ku = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_K), keyDown: false)
        lu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_L), keyDown: false)
        mu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_M), keyDown: false)
        nu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_N), keyDown: false)
        ou = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_O), keyDown: false)
        pu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_P), keyDown: false)
        qu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_Q), keyDown: false)
        ru = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_R), keyDown: false)
        su = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_S), keyDown: false)
        tu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_T), keyDown: false)
        uu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_U), keyDown: false)
        vu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_V), keyDown: false)
        wu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_W), keyDown: false)
        xu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_X), keyDown: false)
        yu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_Y), keyDown: false)
        zu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_Z), keyDown: false)

        
        n0d = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_0), keyDown: true)
        n1d = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_1), keyDown: true)
        n2d = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_2), keyDown: true)
        n3d = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_3), keyDown: true)
        n4d = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_4), keyDown: true)
        n5d = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_5), keyDown: true)
        n6d = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_6), keyDown: true)
        n7d = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_7), keyDown: true)
        n8d = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_8), keyDown: true)
        n9d = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_9), keyDown: true)

        n0u = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_0), keyDown: false)
        n1u = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_1), keyDown: false)
        n2u = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_2), keyDown: false)
        n3u = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_3), keyDown: false)
        n4u = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_4), keyDown: false)
        n5u = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_5), keyDown: false)
        n6u = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_6), keyDown: false)
        n7u = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_7), keyDown: false)
        n8u = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_8), keyDown: false)
        n9u = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_9), keyDown: false)

        plusd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_KeypadPlus), keyDown: true)
        plusu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_KeypadPlus), keyDown: false)

        minusd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_KeypadMinus), keyDown: true)
        minusu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_KeypadMinus), keyDown: false)
        
        escd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Escape), keyDown: true)
        escu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Escape), keyDown: false)
 
        returnd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Return), keyDown: true)
        returnu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Return), keyDown: false)

        downd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_DownArrow), keyDown: true)
        downu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_DownArrow), keyDown: false)

        upd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_UpArrow), keyDown: true)
        upu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_UpArrow), keyDown: false)

        leftd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_LeftArrow), keyDown: true)
        leftu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_LeftArrow), keyDown: false)
        rightd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_RightArrow), keyDown: true)
        rightu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_RightArrow), keyDown: false)

        commad = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_Comma), keyDown: true)
        commau = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_Comma), keyDown: false)

        periodd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_Period), keyDown: true)
        periodu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_Period), keyDown: false)

        enterd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_KeypadEnter), keyDown: true)
        enteru = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_KeypadEnter), keyDown: false)

        equald = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_Equal), keyDown: true)
        equalu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_Equal), keyDown: false)

        lbracketd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_LeftBracket), keyDown: true)
        lbracketu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_LeftBracket), keyDown: false)

        rbracketd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_RightBracket), keyDown: true)
        rbracketu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_RightBracket), keyDown: false)

        endd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_End), keyDown: true)
        endu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_End), keyDown: false)

        homed = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Home), keyDown: true)
        homeu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Home), keyDown: false)

    }
   
 
    func pressDummy()
    {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

        let spcd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Option), keyDown: true)
        
        let spcu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Option), keyDown: false)

        let loc = CGEventTapLocation.cghidEventTap
        spcd?.post(tap: loc)
          
        spcu?.post(tap: loc)
            
    }
    func pressDummy2()
    {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

        let spcd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Option), keyDown: true)
        
        let spcu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Option), keyDown: false)

        let loc = CGEventTapLocation.cghidEventTap
        spcd?.post(tap: loc)
          
        spcu?.post(tap: loc)
            
    }
 
   

    func disconnect() {

 
        if(self.peripheral != nil)
        {
            manager.cancelPeripheralConnection(self.peripheral)
     
        }
    }
   
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
     
        guard peripheral.name != nil else {return}
          
        if(peripheral.identifier != nil)
        {
            print(peripheral.identifier)
            print(peripheral.name)

        }
        /*
         tell application "System Events" to set frontApp to name of first process whose frontmost is true

         if (frontapp starts with "Google Chrome") or (frontApp starts with "Chromium") or (frontApp starts with "Opera") or (frontApp starts with "Vivaldi") or (frontApp starts with "Brave Browser") or (frontApp starts with "Microsoft Edge") then
           using terms from application "Google Chrome"
             tell application frontApp to set currentTabTitle to title of active tab of front window
             tell application frontApp to set currentTabUrl to URL of active tab of front window
           end using terms from
         else if (frontApp starts with "Safari") or (frontApp starts with "Webkit") then
           using terms from application "Safari"
             tell application frontApp to set currentTabTitle to name of front document
             tell application frontApp to set currentTabUrl to URL of front document
           end using terms from
         else
           return "You need a supported browser as your frontmost app"
         end if

         return currentTabUrl & "\n" & currentTabTitle
         */
        
        
        
      if peripheral.name! == "DC_032CTI0" {
      
        print("Sensor Found!")
        //stopScan
        
        
        manager.stopScan()
     
        //connect
      self.peripheral = peripheral
        
       //
     //kkkkkk   manager.connect(peripheral, options: nil)
     //   self.peripheral.delegate = self
         
        
       // startWatchingForControllers()
          
        //   initGamepad()
        
        //pressSpace()
      //  NSWorkspace.shared.launchApplication("Movist")
        
       
       }
        
        
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
   
     
        print("Sensor connect!")
        
        peripheral.discoverServices(nil)

    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?)
    {
        print("didFailToConnect")
 
    }
     func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?)
     {
        print(characteristic)
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
     
        if let services = peripheral.services {
        
         //discover characteristics of services
        
            for service in services {
         
                peripheral.discoverCharacteristics(nil, for: service)
       
            }
    
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
      

        let Digital = CBUUID(string: "0x2A56" )

        
        if let charac = service.characteristics
        {
            for characteristic in charac {
              //MARK:- Light Value
             //   peripheral.replaceValue(at: <#T##Int#>, inPropertyWithKey: <#T##String#>, withValue: <#T##Any#>)(for:characteristic)
           
            
               let ret =  characteristic.isNotifying
                let desc =  characteristic.description
                         let value =  characteristic.value
                                       
              //peripheral.delegate = self
                peripheral.setNotifyValue(true, for: characteristic)
            //    peripheral.readValue(for: characteristic)
                          
            }
             // startWatchingForControllers()
        }
       
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
      // Perform any error handling if one occurred
      if let error = error {
        print("Characteristic value update failed: \(error.localizedDescription)")
        return
      }

      // Retrieve the data from the characteristic
      guard let data = characteristic.value else { return }

      // Decode/Parse the data here
      let message = String(decoding: data, as: UTF8.self)
        
        print(message)
        
      //  manager.connect(self.peripheral, options: nil)
     
       //   initGamepad()
    
            
    }
    
  

}

extension NSRunningApplication{

    var activeTabURL: String?{
        guard self.isActive, let bundleIdentifier = self.bundleIdentifier else {
            return nil
        }

        let code: String? = {
            switch(bundleIdentifier){
            case "org.chromium.Chromium":
                return "tell application \"Chromium\" to return URL of active tab of front window"
            case "com.google.Chrome.canary":
                return "tell application \"Google Chrome Canary\" to return URL of active tab of front window"
            case "com.google.Chrome":
                return "tell application \"Google Chrome\" to return URL of active tab of front window"
            case "com.apple.Safari":
                return "tell application \"Safari\" to return URL of front document"
            case "org.mozilla.firefox":
                return      "tell application \"Firefox\" to return name of window 1 as string"
    
       
            default:
                return nil
            }
        }()

        var errorInfo: NSDictionary?
      
        if(code == nil)
        {
            return nil
        }
        let scriptObject = NSAppleScript(source: code!)
        if let output: NSAppleEventDescriptor = scriptObject?.executeAndReturnError(&errorInfo) {
            let urlString = output.stringValue!
            return output.stringValue
            
        } else if (errorInfo != nil) {
            print("error: \(errorInfo)")
        }
        /*
        if let code = code, let script = NSAppleScript(source: code), let out: NSAppleEventDescriptor = script.executeAndReturnError(&errorInfo){
            if let errorInfo = errorInfo{
                print(errorInfo)

            } else if let urlString = out.stringValue{
                return NSURL(string: urlString)
            }
        }
        */
        return nil
    }


    var activeTabTitle: String?{
        guard self.isActive, let bundleIdentifier = self.bundleIdentifier else {
            return nil
        }

        let code: String? = {
            switch(bundleIdentifier){
            case "org.chromium.Chromium":
                return "tell application \"Chromium\" to return title of active tab of front window"
            case "com.google.Chrome.canary":
                return "tell application \"Google Chrome Canary\" to return title of active tab of front window"
            case "com.google.Chrome":
                return "tell application \"Google Chrome\" to return title of active tab of front window"
            case "com.apple.Safari":
                return "tell application \"Safari\" to return name of front document"
            case "org.mozilla.firefox":
                return   "tell application \"Firefox\" to return name of window 1 as string"
            default:
                return nil
            }
        }()

        /*
        if let code = code, let script = NSAppleScript(source: code),
           let out: NSAppleEventDescriptor = script.executeAndReturnError(&errorInfo){
            if let errorInfo = errorInfo{
                print(errorInfo)

            } else {
                return out.stringValue
            }
        }
        */
        var errorInfo: NSDictionary?
   
        if(code == nil)
        {
            return nil
        }
        let scriptObject = NSAppleScript(source: code!)
        if let output: NSAppleEventDescriptor = scriptObject?.executeAndReturnError(&errorInfo) {
            let urlString = output.stringValue!
            return output.stringValue
        } else if (errorInfo != nil) {
            print("error: \(errorInfo)")
        }
        return nil
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
