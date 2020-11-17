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
        
      
        if (value0==1)
        {
            [JoystickManager sharedInstance].down ++;
     
            
            if(elementUsage == 5)
            {
                // 상
           //     NSLog(@"Gesture up");
            
                [JoystickManager sharedInstance].up = 0;
                [JoystickManager sharedInstance].gesture = @"UP";
         
               
            }
            else if(elementUsage == 6)
            {
                // 하
             //   NSLog(@"Gesture down");
             
                [JoystickManager sharedInstance].up = 0;
                [JoystickManager sharedInstance].gesture = @"DOWN";
         
           }
            else if(elementUsage == 7)
            {
                // 좌
               // NSLog(@"Gesture Left");
           
                [JoystickManager sharedInstance].up = 0;
                [JoystickManager sharedInstance].gesture = @"LEFT";
         
  
            }
            else if(elementUsage == 8)
            {
                // 우
                //NSLog(@"Gesture Right");
           
                [JoystickManager sharedInstance].up = 0;
                [JoystickManager sharedInstance].gesture = @"RIGHT";
         
      
 
            }
            else if(elementUsage >= 9)
            {
              //  NSLog(@"Gesture %d", elementUsage);
                [JoystickManager sharedInstance].touches ++;
            }
         
        }
        else
        {
            [JoystickManager sharedInstance].up ++;
            //NSLog(@"down:%d",[JoystickManager sharedInstance].down);
            //NSLog(@"up:%d",[JoystickManager sharedInstance].up);
          
            if( [JoystickManager sharedInstance].down ==  [JoystickManager sharedInstance].up )
            {
                [[JoystickManager sharedInstance].delegate pressed:[JoystickManager sharedInstance].gesture];
                
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
