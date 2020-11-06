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

class BLEManager: NSObject , CBCentralManagerDelegate, CBPeripheralDelegate {
   private var manager: CBCentralManager!
    
    var peripheral:CBPeripheral!

   required override init() {
      super.init()
      manager = CBCentralManager.init(delegate: self, queue: nil)
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
        
      if peripheral.name! == "Mi Smart Band 4" {
      
        print("Sensor Found!")
        //stopScan
        manager.stopScan()
        
        //connect
        manager.connect(peripheral, options: nil)
        self.peripheral = peripheral
       
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

    }
      
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
     
        if let services = peripheral.services {
        
         //discover characteristics of services
        
            for service in services {
         
                peripheral.discoverCharacteristics(nil, for: service)
       
            }
    
        }
    }
    /*
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
      

        let Digital = CBUUID(string: "0x2A56”)

       if let charac = service.characteristics {
        for characteristic in charac {
          //MARK:- Light Value
          if characteristic.uuid == Digital {
            //self.lighCharacteristics = characteristic
          }
        }
      }
    }
    */
    
    
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
