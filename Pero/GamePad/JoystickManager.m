//
//  JoystickManager.m
//  JoystickHIDTest
//
//  Created by John Stringham on 12-05-01.
//  Copyright 2012 We Get Signal. All rights reserved.
//

#import "JoystickManager.h"

@implementation JoystickManager

//@synthesize delegate;

static JoystickManager *instance;

- (id)init {
    self = [super init];
    
    if (self) {
        joysticks = [[NSMutableDictionary alloc] init];
        joystickIDIndex = 0;
        [self setupGamepads];
    }
    
    return self;
}

+ (void)initialize
{
    static BOOL initialized = NO;
    
    if (!initialized) {
        initialized = YES;
        instance = [[JoystickManager alloc] init];
        instance.code = [[NSMutableString alloc] init];
       
        instance.codeArray = [[NSMutableArray alloc] init];
        for(int i=0;i<16;i++)
        {
            [instance.codeArray addObject:@"0"];
     
        }
 
    }
}


+ (JoystickManager *)sharedInstance {
    return instance;
}

- (unsigned long)connectedJoysticks {
    return [joysticks count];
}

- (int)deviceIDByReference:(IOHIDDeviceRef)deviceRef {
  //  NSLog(@"Searching for device id by pointer: %p",deviceRef);
    for (id key in joysticks) {
        Joystick *thisJoystick = [joysticks objectForKey:key];
    //    NSLog(@"Comparing to joystick id: %d with device: %p",[(NSNumber *)key intValue],[thisJoystick device]);
        
        if ([thisJoystick device] == deviceRef) {
          //  NSLog(@"Found.");
            return [((NSNumber *)key) intValue];
        }
    }
    
    return -1;
}

- (Joystick *)joystickByID:(int)joystickID {
    return [joysticks objectForKey:[NSNumber numberWithInt:joystickID]];
}

- (void)registerNewJoystick:(Joystick *)joystick {
    [joysticks setObject:joystick forKey:[NSNumber numberWithInt:joystickIDIndex++]];
    NSLog(@"Gamepad was plugged in");
    NSLog(@"Gamepads registered: %lu", joysticks.count);
  // [joystickAddedDelegate joystickAdded:joystick];
    [[JoystickManager sharedInstance].delegate pluged];
}
- (void) unpulg
{
    [self.delegate unpluged:joysticks];
 
}


void gamepadWasRemoved(void* inContext, IOReturn inResult, void* inSender, IOHIDDeviceRef device) {
    NSLog(@"Gamepad was unplugged");
    
    

    [[JoystickManager sharedInstance]  unpulg];
   
}

void gamepadAction(void* inContext, IOReturn inResult, void* inSender, IOHIDValueRef value) {
    
    
  //  NSLog(@"gamepadAction from: %p",inSender);
    
    IOHIDElementRef element = IOHIDValueGetElement(value);
    IOHIDDeviceRef device = IOHIDElementGetDevice(element);
    
    
   // NSLog(@"or is it from: %p",device);
    
    int joystickID = [[JoystickManager sharedInstance] deviceIDByReference:device];
    
    if (joystickID == -1) {
        NSLog(@"Invalid device reported.");
        return;
    }
    
 //   NSLog(@"Device index %d reported",joystickID);
    
    //Joystick *theJoystick = [[JoystickManager sharedInstance] joystickByID:joystickID];
    
   // NSLog(@"%@",[theJoystick giveButtonOrAxesIndex:element]);
  //  [theJoystick elementReportedChange:element];
    
    int elementUsage = IOHIDElementGetUsage(element);
    int value0 = IOHIDValueGetIntegerValue(value);
    
    int elementType = IOHIDElementGetType(element);
 
    
    if (elementType != kIOHIDElementTypeInput_Axis && elementType == kIOHIDElementTypeInput_Button) {
        
      
        BOOL ldown = false;
        if (value0==1)
        {
            [JoystickManager sharedInstance].down ++;
            [JoystickManager sharedInstance].dcode = @"1";
            ldown = true;
            NSMutableString;
     
            /*
            if(elementUsage == 5)
            {
                // 상
           //     NSLog(@"Gesture up");
            
                [JoystickManager sharedInstance].up = 0;
                [JoystickManager sharedInstance].gesture = @"U";
         
               
            }
            else if(elementUsage == 6)
            {
                // 하
             //   NSLog(@"Gesture down");
             
                [JoystickManager sharedInstance].up = 0;
                [JoystickManager sharedInstance].gesture = @"D";
         
           }
            else if(elementUsage == 7)
            {
                // 좌
               // NSLog(@"Gesture Left");
           
                [JoystickManager sharedInstance].up = 0;
                [JoystickManager sharedInstance].gesture = @"L";
         
  
            }
            else if(elementUsage == 8)
            {
                // 우
                //NSLog(@"Gesture Right");
           
                [JoystickManager sharedInstance].up = 0;
                [JoystickManager sharedInstance].gesture = @"R";
         
      
 
            }
          
         
            else if(elementUsage >= 9)
            {
              //  NSLog(@"Gesture %d", elementUsage);
                [JoystickManager sharedInstance].touches ++;
            }
             */
         //   [[JoystickManager sharedInstance].code appendString:@"1"];
            if(elementUsage == 5)
            {
                NSLog(@"test");
            }
            if(elementUsage == 6)
            {
                NSLog(@"test");
            }
            if(elementUsage == 7)
            {
                NSLog(@"test");
            }
            if(elementUsage == 8)
            {
                NSLog(@"test");
            }
            [JoystickManager sharedInstance].codeArray[elementUsage-1] = @"1";
           // [[JoystickManager sharedInstance].code replaceCharactersInRange:NSMakeRange(elementUsage-1, elementUsage-1) withString:@"1" ];


            
            if(elementUsage >= 8)
            {
              //  NSLog(@"Gesture %d", elementUsage);
                [JoystickManager sharedInstance].touches ++;
            }
            
            
        }
        else
        {
           // [JoystickManager sharedInstance].a
     //       [[JoystickManager sharedInstance].code replaceCharactersInRange:NSMakeRange(elementUsage-1, elementUsage-1) withString:@"0" ];

    //        [JoystickManager sharedInstance].codeArray[elementUsage-1] = @"0";
         
            
            
        //    [JoystickManager sharedInstance].code = [JoystickManager sharedInstance].code +  [JoystickManager sharedInstance].dcode
     
            [JoystickManager sharedInstance].up ++;
            //NSLog(@"down:%d",[JoystickManager sharedInstance].down);
            //NSLog(@"up:%d",[JoystickManager sharedInstance].up);
          
            if( [JoystickManager sharedInstance].down ==  [JoystickManager sharedInstance].up )
          //  if(  [JoystickManager sharedInstance].up == 16 )
         
            {
                
                for(int i=0;i<16;i++)
                {
                    [[JoystickManager sharedInstance].code appendString:[JoystickManager sharedInstance].codeArray[i]];
                    
                }
                for(int i=0;i<16;i++)
                {
                    [JoystickManager sharedInstance].codeArray[i] = @"0";
                    
                }
                NSString *gestureCode = [[JoystickManager sharedInstance].code substringToIndex:6];
        
                
               // [[JoystickManager sharedInstance].delegate pressed:[JoystickManager sharedInstance].gesture];
                [[JoystickManager sharedInstance].delegate pressed:gestureCode];
               
                [JoystickManager sharedInstance].code = @"";
                [JoystickManager sharedInstance].down = 0;
         
                [JoystickManager sharedInstance].up = 0;
 /*
                [JoystickManager sharedInstance].gesture = @"";
   
  */

            }
         //   [delegate joystickButtonReleased:[self getElementIndex:theElement] onJoystick:self];
        }
        
        return;
    }
}

void gamepadWasAdded(void* inContext, IOReturn inResult, void* inSender, IOHIDDeviceRef device) {
    IOHIDDeviceOpen(device, kIOHIDOptionsTypeNone);
	IOHIDDeviceRegisterInputValueCallback(device, gamepadAction, inContext);
    
    Joystick *newJoystick = [[Joystick alloc] initWithDevice:device];
    [[JoystickManager sharedInstance] registerNewJoystick:newJoystick];
    
  //  [newJoystick release];
}


-(void) setupGamepads {
    hidManager = IOHIDManagerCreate( kCFAllocatorDefault, kIOHIDOptionsTypeNone);
    
//    IOReturn tIOReturn = IOHIDManagerOpen(hidManager, kIOHIDOptionsTypeNone);

//    IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetMain(), kCFRunLoopDefaultMode);

    int usageKeys[] = { kHIDUsage_GD_GamePad };
    
    int i;
     NSMutableArray *criterionSets = [NSMutableArray arrayWithCapacity:3];
    
    for (i=0; i<1; ++i) {
        int usageKeyConstant = usageKeys[i];
        NSMutableDictionary* criterion = [[NSMutableDictionary alloc] init];
        [criterion setObject: [NSNumber numberWithInt: kHIDPage_GenericDesktop] forKey: (NSString*)CFSTR(kIOHIDDeviceUsagePageKey)];
        [criterion setObject: [NSNumber numberWithInt: usageKeyConstant] forKey: (NSString*)CFSTR(kIOHIDDeviceUsageKey)];
        [criterionSets addObject:criterion];
        //[criterion release];
    }
    
	IOHIDManagerSetDeviceMatchingMultiple(hidManager, (CFArrayRef)criterionSets);
    //IOHIDManagerSetDeviceMatching(hidManager, (CFDictionaryRef)criterion);
    IOHIDManagerRegisterDeviceMatchingCallback(hidManager, gamepadWasAdded, (void*)self);
    IOHIDManagerRegisterDeviceRemovalCallback(hidManager, gamepadWasRemoved, (void*)self);
    IOHIDManagerScheduleWithRunLoop(hidManager, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    IOReturn tIOReturn = IOHIDManagerOpen(hidManager, kIOHIDOptionsTypeNone);
    (void)tIOReturn; // to suppress warnings
   
    
    IOHIDManagerOpen(hidManager, kIOHIDOptionsTypeNone);
}


@end
