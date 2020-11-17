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
class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate ,JoySticDelegate{
    func unpluged(_ device: NSMutableDictionary!) {
        device.removeAllObjects()
    }
    
    
    func pressed(_ gesture: String!) {
        print(gesture)
        print(JoystickManager.sharedInstance()?.touches)
 
        //   print(JoystickManager.sharedInstance().down)
        JoystickManager.sharedInstance()?.gesture = ""
        JoystickManager.sharedInstance().down = 0
        JoystickManager.sharedInstance().up = 0
        JoystickManager.sharedInstance()?.touches = 0
//        [JoystickManager sharedInstance].gesture = @"";
//        [JoystickManager sharedInstance].down = 0;
 
//        [JoystickManager sharedInstance].up = 0;

        
    }
    
   
   
    
   
    
   private var manager: CBCentralManager!
    
    var peripheral:CBPeripheral!
    
    var gamepad:GCMicroGamepad!
    
    
    var hidManager:IOHIDManager!

   required override init() {
      super.init()
    manager = CBCentralManager.init(delegate: self, queue: nil)
    
 
    
   }
    
   
    
    
    func startWatchingForControllers() {
         // Subscribe for the notes
        let ctr = NotificationCenter.default
        
        ctr.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) { note in
            if let ctrl = note.object as? GCController {
                self.add(ctrl)
            }
        }
        ctr.addObserver(forName: .GCControllerDidDisconnect, object: nil, queue: .main) { note in
            if let ctrl = note.object as? GCController {
                self.remove(ctrl)
            }
        }
 
        // and kick off discovery
        GCController.startWirelessControllerDiscovery(completionHandler: {})
 /*
      NotificationCenter.default.addObserver(self, selector: #selector(handleControllerDidConnectNotification(_:)), name: .GCControllerDidConnect, object: nil)

        if GCController.controllers().count == 0 {
            GCController.startWirelessControllerDiscovery(completionHandler: {})
        }

       // GCController.startWirelessControllerDiscovery(completionHandler: nil)
*/
    }
    @objc func handleControllerDidConnectNotification(_ notification: NSNotification) {
        let gameController = notification.object as! GCController
       // registerCharacterMovementEvents(gameController)
    }
    func readData()
    {
      
    }
    
    
    func stopWatchingForControllers() {
        // Same as the first, 'cept in reverse!
        GCController.stopWirelessControllerDiscovery()

        let ctr = NotificationCenter.default
        ctr.removeObserver(self, name: .GCControllerDidConnect, object: nil)
        ctr.removeObserver(self, name: .GCControllerDidDisconnect, object: nil)
    }

    func add(_ controller: GCController) {
        
        let name = String(describing:controller.vendorName)
        if let gamepad = controller.extendedGamepad {
            print("connect extended (name)")
        } else if let gamepad = controller.microGamepad {
            print("connect micro (name)")
        } else {
            print("Huh? (name)")
        }
        gamepad = controller.microGamepad
   //     guard let gamepad = gamepad as? GCMicroGamepad else { return }

        // method
        /*
        gamepad.valueChangedHandler = { (gamepad, element) in
            if let dpad = element as? GCControllerDirectionPad {
                print("CTRL : ( dpad )")
            } else {
                print("element :")
                print(element)
                
            }
        }
        
        for button in gamepad.allButtons
        {
            print("button :")
            print(button)
            button.pressedChangedHandler = { (gamepad, value,pressed) in
                           
                print("pressed button")
                print(value)
                
            }
   
        }
 */
        /*
        gamepad.dpad.valueChangedHandler = { (dpad, xValue, yValue) in
            print("DPAD : ( dpad )")
        }
        gamepad.dpad.xAxis.valueChangedHandler = { (axis, value) in
            print("AXIS: ( axis ) -> ( value ) ")
        }
        gamepad.dpad.yAxis.valueChangedHandler = { (axis, value) in
            print("AXIS: ( axis ) -> ( value ) ")
        }
     
       
        gamepad.buttonA.pressedChangedHandler = { (gamepad, value,pressed) in
                   
                   
                    
                   print("pressed buttonA")
               
              
        }
        //GCControllerTouchpad
        gamepad.buttonMenu.pressedChangedHandler = { (gamepad, value,pressed) in
                         
                         
                          
                         print("pressed buttonMenu")
                     
                    
             
        }
        gamepad.buttonX.pressedChangedHandler = { (gamepad, value,pressed) in
                                
                                
                                 
                                print("pressed buttonX")
                            
                           
                    
               }
        gamepad.dpad.down.pressedChangedHandler = { (gamepad, value,pressed) in
            
            
             
            print("pressed down")
        
        }
        gamepad.dpad.up.pressedChangedHandler = { (gamepad, value,pressed) in
                     
               
            print("pressed up")
          
          }
        gamepad.dpad.left.pressedChangedHandler = { (gamepad, value,pressed) in
                      
                  
            print("pressed left")
           
           }
        gamepad.dpad.right.pressedChangedHandler = { (gamepad, value,pressed) in
                             
                          
            print("pressed left")
                  
        }
        /
        gamepad.dpad.xAxis.valueChangedHandler = { (gamepad, value,value1) in
                            
                            print("pressed xAxis")
                 
                 }
        gamepad.dpad.yAxis.valueChangedHandler = { (gamepad, value,valuevalue1) in
                                
                                print("pressed yAxis")
                     
                     }
 
        gamepad.dpad.left.valueChangedHandler = { (gamepad, value,pressed) in
                                   
                                   print("pressed right")
                        
                        }
        
        gamepad.buttonX.valueChangedHandler = { (gamepad, value,pressed) in
                   
                   print("pressed buttonX")
        
        }
        gamepad.buttonA.valueChangedHandler = { (gamepad, value,pressed) in
                   
                   print("pressed buttonA")
        
        }
 */
    }

    func remove(_ controller: GCController) {

    }
    func getFucusedApplication()
    {
        /*
        NSArray *apps = [[NSWorkspace sharedWorkspace] runningApplications];

        for (NSRunningApplication *app in apps) {
            if([app.bundleIdentifier.lowercaseString isEqualToString:@"com.apple.finder"]) {
                [app activateWithOptions:NSApplicationActivateAllWindows|NSApplicationActivateIgnoringOtherApps];
                break;
            }
        }
        */
        DispatchQueue.global(qos: .background).async {
            
            while true
            {
                let apps = NSWorkspace.shared.runningApplications
                      for app in apps
                      {
                          if(app.isActive)
                          {
                              print(app.bundleIdentifier)

                          }
                      }
            }
        }
        
        
      
    }
  //(int type, int page, int usage, int value))
    let callback : @convention(c) ( _ type : Int32,
        _ page : Int32,
        _ usage : Int32, _ value:Int32 ) -> Void =

    { (type, page, usage, value) in

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
   
    func pressSpace()
    {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

        let spcd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Space), keyDown: true)
        
        let spcu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Space), keyDown: false)

        let loc = CGEventTapLocation.cghidEventTap
        spcd?.post(tap: loc)
          
        spcu?.post(tap: loc)
            
    }
    
    func takeScreenShot()
    {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

        /// ㅅ크린캡쳐 시뮬레이션  /////////////////////
        let cmdd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Command), keyDown: true)
        let cmdu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Command), keyDown: false)
       
        let shiftd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Shift), keyDown: true)
         
        let shiftu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Shift), keyDown: false)
  
        let spcd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_3), keyDown: true)
        let spcu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_3), keyDown: false)

         spcd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift];

        let loc = CGEventTapLocation.cghidEventTap

        cmdd?.post(tap: loc)
        spcd?.post(tap: loc)
        shiftd?.post(tap: loc)
        spcu?.post(tap: loc)
        cmdu?.post(tap: loc)
        shiftu?.post(tap: loc)
        
    }
    func screenZoom()
    {
   
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

        /// ㅅ크린캡쳐 시뮬레이션  /////////////////////
       
        let cmdd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Command), keyDown: true)
        let cmdu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Command), keyDown: false)
      
   
        let plusd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_KeypadPlus), keyDown: true)
        let plusu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_KeypadPlus), keyDown: false)

        plusd?.flags = CGEventFlags.maskCommand;

        let loc = CGEventTapLocation.cghidEventTap

        cmdd?.post(tap: loc)
        plusd?.post(tap: loc)
        cmdu?.post(tap: loc)
        plusu?.post(tap: loc)
    
    }

     func Print()
     {
    
         let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

         /// ㅅ크린캡쳐 시뮬레이션  /////////////////////
       
      
        let cmdd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Command), keyDown: true)
        let cmdu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Command), keyDown: false)
        
         let func1d = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_P), keyDown: true)
         let func1u = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_P), keyDown: false)
       
    
     //    let plusd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_KeypadPlus), keyDown: true)
      //   let plusu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_ANSI_KeypadPlus), keyDown: false)

         func1d?.flags = CGEventFlags.maskCommand;

         let loc = CGEventTapLocation.cghidEventTap

         cmdd?.post(tap: loc)
         func1d?.post(tap: loc)
         func1u?.post(tap: loc)
         cmdu?.post(tap: loc)
     
     }

    func testShortcut() {

 
    }
   
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber)
    {
     //
        
       // keyboardKeyDown(key: 0x7A)
        //keyboardKeyUp(key: 0x7A)
        //takeScreenShot()
    
        //screenㅠBright()
       // screenBright()
     
          
          guard peripheral.name != nil else {return}
          
        if(peripheral.identifier != nil)
        {
            print(peripheral.identifier)
            print(peripheral.name)

        }
        
      if peripheral.name! == "PERO2" {
      
        print("Sensor Found!")
        //stopScan
        
        
        manager.stopScan()
        
        //connect
        manager.connect(peripheral, options: nil)
        self.peripheral = peripheral
        self.peripheral.delegate = self
          
              
        
       // startWatchingForControllers()
          
        //   initGamepad()
        
        //pressSpace()
      //  NSWorkspace.shared.launchApplication("Movist")
        
       
       }
        
        
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
      //discover all service
      /*
         let AutomationIO = CBUUID(string: “0x1815”)
         peripheral.discoverServices([AutomationIO])
         
         */
      
        
     
        peripheral.discoverServices(nil)
      
        peripheral.delegate = self
        
     //   startWatchingForControllers()
     //   initGamePad()
   
        RunLoop.current.run()


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
                //peripheral.setNotifyValue(true, for: characteristic)
             //   peripheral.readValue(for: characteristic)
                          
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
       //   initGamepad()
    
            
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager,
                          didReceiveWrite requests: [CBATTRequest]) {
      guard let request = requests.first, let data = request.value else { return }
      let message = String(decoding: data, as: UTF8.self)
    }
    func execute()
    {
 // Hold the Command key
        let source0 = CGEventSource(stateID: .hidSystemState)
        let event = CGEvent(keyboardEventSource: source0, virtualKey: 55 as CGKeyCode, keyDown: true)
        event!.setIntegerValueField(.keyboardEventAutorepeat, value: 1)
        event!.post(tap: .cghidEventTap)

        // Press Tab key once
        let source1 = CGEventSource(stateID: .hidSystemState)
        let keyDown = CGEvent(keyboardEventSource: source1, virtualKey: 48 as CGKeyCode, keyDown: true)
        keyDown!.flags = .maskCommand
        keyDown!.post(tap: .cghidEventTap)
        let keyUp = CGEvent(keyboardEventSource: source1, virtualKey: 48 as CGKeyCode, keyDown: false)
        keyUp!.post(tap: .cghidEventTap)
    }
    func gestureTest()
    {
        let eventSource = CGEventSource (stateID: .combinedSessionState)
        let event = CGEvent(source: eventSource);
        event?.type = .scrollWheel

    }
    
    
    
    // press the button
    func keyboardKeyDown(key: CGKeyCode) {

            let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
            let event = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: true)
            event?.post(tap: CGEventTapLocation.cghidEventTap)
            print("key \(key) is down")
        }

    // release the button
    func keyboardKeyUp(key: CGKeyCode) {
            let source = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
            let event = CGEvent(keyboardEventSource: source, virtualKey: key, keyDown: false)
            event?.post(tap: CGEventTapLocation.cghidEventTap)
            print("key \(key) is released")
        }
    
    func newDoc()
    {
        let cmd_c_D = CGEvent(keyboardEventSource: nil, virtualKey: 0x2D, keyDown: true); // 0x08 is C cmd-c down key code
        cmd_c_D!.flags = CGEventFlags.maskCommand;
     //   CGEventPost(CGEventTapLocation.CGHIDEventTap, cmd-c-D);

        cmd_c_D!.post(tap: CGEventTapLocation.cghidEventTap)
        
        
        
        let cmd_c_U = CGEvent(keyboardEventSource: nil, virtualKey: 0x2D, keyDown: false); // cmd-c up
        cmd_c_U!.flags = CGEventFlags.maskCommand;
        cmd_c_U!.post(tap: CGEventTapLocation.cghidEventTap);
    }
}
