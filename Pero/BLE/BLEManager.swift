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
@available(OSX 11.0, *)
class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate ,JoySticDelegate{

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
    
    var src:CGEventSource!

    let loc = CGEventTapLocation.cghidEventTap


    func pluged() {
        let appDelegate: AppDelegate? =  NSApp.delegate as! AppDelegate//NSApplication.shared.delegate as! AppDelegate
      
        appDelegate!.reconstructMenu(name:"PERO")
        
  
    }
    
    func unpluged(_ device: NSMutableDictionary!) {
        device.removeAllObjects()
        disconnect()
        let appDelegate: AppDelegate? =  NSApp.delegate as! AppDelegate//NSApplication.shared.delegate as! AppDelegate
    
        appDelegate!.reconstructMenu0(name:"PERO")
 
    }
    
    
    func pressed(_ gesture: String!) {
        print(gesture)
        print(JoystickManager.sharedInstance()?.touches)
 
      
        var touches = "t3"
        if(JoystickManager.sharedInstance()!.touches > 6)
        {
            touches = "t4"
        }
        
        let commands = CoreDataManager.shared.getGesture(name: gesture, touches: touches)
        
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
                Command(shortcut: shortcut!)
       
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

   required override init() {
      super.init()
    manager = CBCentralManager.init(delegate: self, queue: nil)
    pressDummy()
    
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
            if(list[0] == "CTRL" || list[0] == "COMMAND")
            {
                
         //a
              
                cmdd?.post(tap: loc)
                cmdu?.post(tap: loc)
   
            }
            initOne(command: list[1], isCommand: true, isShift: false)

            
            
        }
        else if(list.count == 3)
        {
            
        }


    }
    func  initOne(command:String, isCommand:Bool, isShift:Bool)
    {
        if(command == "DOWN")
        {
            if(isCommand == true && isShift == false)
            {
                downd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                downd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            downd?.post(tap: loc)
            downu?.post(tap: loc)
         
        }
        if(command == "a")
        {
            if(isCommand == true && isShift == false)
            {
                ad?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                ad?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            ad?.post(tap: loc)
            au?.post(tap: loc)
         
        }
        if(command == "b")
        {
            if(isCommand == true && isShift == false)
            {
                bd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                bd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }
            bd?.post(tap: loc)
            bu?.post(tap: loc)

        }
        if(command == "c")
        {
            if(isCommand == true && isShift == false)
            {
                cd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                cd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            cd?.post(tap: loc)
            cu?.post(tap: loc)

        }
        if(command == "d")
        {
            if(isCommand == true && isShift == false)
            {
                dd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                dd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            dd?.post(tap: loc)
            du?.post(tap: loc)

        }
        if(command == "e")
        {
            if(isCommand == true && isShift == false)
            {
                ed?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                ed?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            ed?.post(tap: loc)
            eu?.post(tap: loc)

        }
        if(command == "f")
        {
            if(isCommand == true && isShift == false)
            {
                fd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                fd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            fd?.post(tap: loc)
            fu?.post(tap: loc)

        }
        if(command == "g")
        {
            if(isCommand == true && isShift == false)
            {
                gd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                gd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            gd?.post(tap: loc)
            gu?.post(tap: loc)

        }
        if(command == "h")
        {
            if(isCommand == true && isShift == false)
            {
                hd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                hd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            hd?.post(tap: loc)
            hu?.post(tap: loc)

        }
        if(command == "i")
        {
            if(isCommand == true && isShift == false)
            {
                id?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                id?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            id?.post(tap: loc)
            iu?.post(tap: loc)

        }
        if(command == "j")
        {
            if(isCommand == true && isShift == false)
            {
                jd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                jd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            jd?.post(tap: loc)
            ju?.post(tap: loc)

        }
        if(command == "k")
        {
            if(isCommand == true && isShift == false)
            {
                kd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                kd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            kd?.post(tap: loc)
            ku?.post(tap: loc)

        }
        if(command == "l")
        {
            if(isCommand == true && isShift == false)
            {
                ld?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                ld?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            ld?.post(tap: loc)
            lu?.post(tap: loc)

        }
        if(command == "m")
        {
            if(isCommand == true && isShift == false)
            {
                md?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                md?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            md?.post(tap: loc)
            mu?.post(tap: loc)

        }
        if(command == "n")
        {
            if(isCommand == true && isShift == false)
            {
                nd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                nd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            nd?.post(tap: loc)
            nu?.post(tap: loc)

        }
        if(command == "o")
        {
            if(isCommand == true && isShift == false)
            {
                od?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                od?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            od?.post(tap: loc)
            ou?.post(tap: loc)

        }
        if(command == "p")
        {
            if(isCommand == true && isShift == false)
            {
                pd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                pd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            pd?.post(tap: loc)
            pu?.post(tap: loc)

        }
        if(command == "q")
        {
            if(isCommand == true && isShift == false)
            {
                qd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                qd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            qd?.post(tap: loc)
            qu?.post(tap: loc)

        }
        if(command == "r")
        {
            if(isCommand == true && isShift == false)
            {
                rd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                rd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            rd?.post(tap: loc)
            ru?.post(tap: loc)

        }
        if(command == "w")
        {
            if(isCommand == true && isShift == false)
            {
                wd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                wd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            wd?.post(tap: loc)
            wu?.post(tap: loc)

        }
        if(command == "x")
        {
            if(isCommand == true && isShift == false)
            {
                xd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                xd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            xd?.post(tap: loc)
            xu?.post(tap: loc)

        }
        if(command == "y")
        {
            if(isCommand == true && isShift == false)
            {
                yd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                yd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            yd?.post(tap: loc)
            yu?.post(tap: loc)

        }
        if(command == "z")
        {
            if(isCommand == true && isShift == false)
            {
                zd?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                zd?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            zd?.post(tap: loc)
            zu?.post(tap: loc)

        }
        if(command == "0")
        {
            if(isCommand == true && isShift == false)
            {
                n0d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                n0d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            n0d?.post(tap: loc)
            n0u?.post(tap: loc)

        }
        if(command == "1")
        {
            if(isCommand == true && isShift == false)
            {
                n1d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                n1d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            n1d?.post(tap: loc)
            n1u?.post(tap: loc)
        }
        if(command == "2")
        {
            if(isCommand == true && isShift == false)
            {
                n2d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                n2d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            n2d?.post(tap: loc)
            n2u?.post(tap: loc)
        }
        if(command == "3")
        {
            if(isCommand == true && isShift == false)
            {
                n3d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                n3d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            n3d?.post(tap: loc)
            n3u?.post(tap: loc)
        }
        if(command == "4")
        {
            if(isCommand == true && isShift == false)
            {
                n4d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                n4d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            n4d?.post(tap: loc)
            n4u?.post(tap: loc)
        }
        if(command == "5")
        {
            if(isCommand == true && isShift == false)
            {
                n5d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                n5d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            n5d?.post(tap: loc)
            n5u?.post(tap: loc)
        }
        if(command == "6")
        {
            if(isCommand == true && isShift == false)
            {
                n6d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                n6d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            n6d?.post(tap: loc)
            n6u?.post(tap: loc)
        }
        if(command == "7")
        {
            if(isCommand == true && isShift == false)
            {
                n7d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                n7d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            n7d?.post(tap: loc)
            n7u?.post(tap: loc)
        }
        if(command == "8")
        {
            if(isCommand == true && isShift == false)
            {
                n8d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                n8d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            n8d?.post(tap: loc)
            n8u?.post(tap: loc)
        }
        if(command == "9")
        {
            if(isCommand == true && isShift == false)
            {
                n9d?.flags = CGEventFlags.maskCommand

            }
            if(isCommand == true && isShift == true)
            {
                n9d?.flags = [CGEventFlags.maskCommand, CGEventFlags.maskShift]

            }

            n9d?.post(tap: loc)
            n9u?.post(tap: loc)
        }

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
        optionu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Option), keyDown: true)

        ctrld = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Control), keyDown: true)
        ctrlu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Control), keyDown: true)

        

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

        upd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_DownArrow), keyDown: true)
        upu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_DownArrow), keyDown: false)

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
    func pressDummy()
    {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)

        let spcd = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Option), keyDown: true)
        
        let spcu = CGEvent(keyboardEventSource: src, virtualKey: CGKeyCode(kVK_Option), keyDown: false)

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

    func disconnect() {

 
        if(self.peripheral != nil)
        {
            manager.cancelPeripheralConnection(self.peripheral)
     
        }
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
        
        let appDelegate: AppDelegate? =  NSApp.delegate as! AppDelegate//NSApplication.shared.delegate as! AppDelegate
      
        appDelegate!.reconstructMenu(name:"PERO")
   //     self.peripheral.delegate = self
          
              
        
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
   
       // RunLoop.current.run()


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
