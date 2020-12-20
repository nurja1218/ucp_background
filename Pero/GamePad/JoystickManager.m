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
        instance.code = [[NSMutableString alloc] initWithCapacity:16];
        instance.gcode = [[NSMutableString alloc] initWithCapacity:16];
       instance.touch = [[NSMutableString alloc] initWithCapacity:16];
        
        
        [instance.code setString: @"0000000000000000"];
        [instance.gcode setString: @"0000000000000000"];
  
        instance.codeArray = [[NSMutableArray alloc] init];
        for(int i=0;i<16;i++)
        {
            [instance.codeArray addObject:@"0"];
     
        }
        instance.dummyArray = [[NSMutableArray alloc] init];
        instance.toggle = false;
        for(int i=0;i<16;i++)
        {
            [instance.dummyArray addObject:@"0"];
     
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
void commonFinalize()
{
    
    for(int i=0;i<16;i++)
    {
      
     //   [[JoystickManager sharedInstance].code  appendString:[JoystickManager sharedInstance].codeArray[i]];
        
    }
    
    for(int i=0;i<16;i++)
    {
        [JoystickManager sharedInstance].codeArray[i] = @"0";
        
        [JoystickManager sharedInstance].dummyArray[i] = @"0";
    }


     [[JoystickManager sharedInstance].delegate pressed:[JoystickManager sharedInstance].code ];
 //   [[JoystickManager sharedInstance].code removeAllObjects ];
    for(int i=0;i<16;i++)
    {
  //      [[JoystickManager sharedInstance].codeArray addObject:@"0"];
    }
    
 
    [JoystickManager sharedInstance].toggle = false;

  //  [JoystickManager sharedInstance].code = [[NSMutableString alloc] init];
    [JoystickManager sharedInstance].code = [[NSMutableString alloc] initWithCapacity:16];
 
    [[JoystickManager sharedInstance].code  setString:@"0000000000000000"];
    [JoystickManager sharedInstance].down = 0;
    [JoystickManager sharedInstance].Gdown = 0;
    [JoystickManager sharedInstance].tdown = 0;

    [JoystickManager sharedInstance].up = 0;
}
void commonFinalize1()
{
    
    for(int i=0;i<16;i++)
    {
      
       // [[JoystickManager sharedInstance].code  appendString:[JoystickManager sharedInstance].codeArray[i]];
        
    }
    
    for(int i=0;i<16;i++)
    {
        [JoystickManager sharedInstance].codeArray[i] = @"0";
        
        [JoystickManager sharedInstance].dummyArray[i] = @"0";
    }


     [[JoystickManager sharedInstance].delegate pressed1:[JoystickManager sharedInstance].code ];
 //   [[JoystickManager sharedInstance].code removeAllObjects ];
    for(int i=0;i<16;i++)
    {
  //      [[JoystickManager sharedInstance].codeArray addObject:@"0"];
    }
    
 
    [JoystickManager sharedInstance].toggle = false;
    [JoystickManager sharedInstance].code = [[NSMutableString alloc] initWithCapacity:16];
 
  //  [JoystickManager sharedInstance].code = [[NSMutableString alloc] init];
    [[JoystickManager sharedInstance].code  setString:@"0000000000000000"];
    [JoystickManager sharedInstance].down = 0;
    [JoystickManager sharedInstance].Gdown = 0;
    [JoystickManager sharedInstance].tdown = 0;

    [JoystickManager sharedInstance].up = 0;
}
void modeFinalize(BOOL mode)
{
    
    for(int i=0;i<16;i++)
    {
      
   //     [[JoystickManager sharedInstance].code  appendString:[JoystickManager sharedInstance].dummyArray[i]];
        
    }
    
    for(int i=0;i<16;i++)
    {
        [JoystickManager sharedInstance].codeArray[i] = @"0";
        
        [JoystickManager sharedInstance].dummyArray[i] = @"0";

        
    }


    [[JoystickManager sharedInstance].delegate toggle:mode];
 //   [[JoystickManager sharedInstance].delegate pressed:[JoystickManager sharedInstance].code ];
    [[JoystickManager sharedInstance].codeArray removeAllObjects ];
  
    for(int i=0;i<16;i++)
    {
        [[JoystickManager sharedInstance].codeArray addObject:@"0"];
    }
    
    [JoystickManager sharedInstance].code = [[NSMutableString alloc] initWithCapacity:16];
 
   
    [[JoystickManager sharedInstance].code  setString:@"0000000000000000"];
     [JoystickManager sharedInstance].down = 0;

    [JoystickManager sharedInstance].up = 0;
    [JoystickManager sharedInstance].toggle = false;
    [JoystickManager sharedInstance].Gdown = 0;
    [JoystickManager sharedInstance].tdown = 0;

}

int Gdown0 = 0;
int oldIndex = 0;

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
 
    int page = IOHIDElementGetReportCount(element);
    if (elementType != kIOHIDElementTypeInput_Axis && elementType == kIOHIDElementTypeInput_Button) {
        
      
        BOOL ldown = false;
       //  [JoystickManager sharedInstance].dummyArray[elementUsage-1] = @"1";
      //  NSLog(@"Gesture %d / %d", elementUsage, value0);
        
  
 
        [[JoystickManager sharedInstance].delegate modSet];
        if([JoystickManager sharedInstance].mode == true)
        {
           
            // tocuh mode
           
          //  [JoystickManager sharedInstance].gdown = 0;
 
        
            if(elementUsage >= 8)
            {
              
                if (value0==1)
                {
                 //   [JoystickManager sharedInstance].down ++;
                    [JoystickManager sharedInstance].tdown++;

                    int index = [[JoystickManager sharedInstance].delegate getIndex];
                    /*
                    if([JoystickManager sharedInstance].toggle == false)
                    {
                        [JoystickManager sharedInstance].toggle = true;
                        
                        [[JoystickManager sharedInstance].delegate touchDown:elementUsage];
                        
                   }
                    oldIndex = index;
                     */
                    if([JoystickManager sharedInstance].toggle == false)
                    {
                        [JoystickManager sharedInstance].toggle = true;
      
                        [[JoystickManager sharedInstance].delegate startDownTimer];
                        oldIndex = index;
             
                    }
                    if(oldIndex == index)
                    {
                        [[JoystickManager sharedInstance].delegate touchDown:elementUsage];
                        
                    }
               
                }
                else
                {
                  //  [JoystickManager sharedInstance].up ++;
                  
                 //   if( [JoystickManager sharedInstance].down ==  [JoystickManager sharedInstance].up )
                    
                 //   if([JoystickManager sharedInstance].toggle != nil && [JoystickManager sharedInstance].toggle == true)
                    if(
                       [JoystickManager sharedInstance].error == false &&
                       [JoystickManager sharedInstance].toggle != nil &&
                       [JoystickManager sharedInstance].toggle == true
                       )
                 
                    {
                    //    [[JoystickManager sharedInstance].delegate endDownTimer];
                
                        [[JoystickManager sharedInstance].delegate touchUp:elementUsage];
          
                        
              
                        
               
              
                    }
                     
                    
                    [JoystickManager sharedInstance].toggle = false;
          
               
                }
           
            
            }
            
        }
        else
        {
            // Gesture
            
         
            [JoystickManager sharedInstance].toggle = false;

            if (value0==1)
            {
                    
                [JoystickManager sharedInstance].down ++;
                ldown = true;
         
            
                [JoystickManager sharedInstance].codeArray[elementUsage-1] = @"1";
                
                // 16/12/8/2/1 -> Touch
                //15/13/9/2/1  -> Gesture
             
    
                
           
         
                if(elementUsage >= 8)
                {
                    [JoystickManager sharedInstance].touches ++;
                    
                    
                //    [[JoystickManager sharedInstance].code replaceCharactersInRange:NSMakeRange(elementUsage - 1,elementUsage - 1) withString:@"1"];

                   // [JoystickManager sharedInstance].code = [[NSMutableString alloc] initWithCapacity:16];
                 
                    [[JoystickManager sharedInstance].code  setString:@"0000000000000000"];
                 
             //       Gdown0 = 0;
              //      [JoystickManager sharedInstance].Gdown = 0;
                }
                else
                {
                        
                    if(elementUsage > 16)
                    {
                        return;
                    }
                    [[JoystickManager sharedInstance].code replaceCharactersInRange:NSMakeRange(elementUsage - 1,elementUsage - 1) withString:@"1"];

                    [JoystickManager sharedInstance].codeArray[elementUsage-1] = @"1";
                    [JoystickManager sharedInstance].Gdown ++;
                    NSLog(@"elementUsage %d / %d /%d", elementUsage, [JoystickManager sharedInstance].Gdown,[JoystickManager sharedInstance].touches);
                
                    // 0100000000000000
                    // 00010000000000
                    if( [JoystickManager sharedInstance].Gdown == 1)
                    {
                        // 1 2 3 4
                     //   str = [[JoystickManager sharedInstance].code stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:@"A"];

                        //
                        if(
                            [ [JoystickManager sharedInstance].codeArray[0] isEqual:@"1" ]  ||
                            [[JoystickManager sharedInstance].codeArray[1] isEqual:@"1" ] ||
                            [[JoystickManager sharedInstance].codeArray[2] isEqual:@"1" ] ||
                            [[JoystickManager sharedInstance].codeArray[3] isEqual:@"1" ]
                           )
                        {
                            if([JoystickManager sharedInstance].touches > 7)
                            {
                                [JoystickManager sharedInstance].Gdown = 0;
                                [JoystickManager sharedInstance].touches = 0;
                     
                                commonFinalize1();
                    
                            }
                            else if([JoystickManager sharedInstance].touches <=7 )
                            {
                                [JoystickManager sharedInstance].Gdown = 0;
                                [JoystickManager sharedInstance].touches = 0;
                                  commonFinalize();
                    
                            }
                           // [JoystickManager sharedInstance].Gdown = 0;
                        
                  
                        }
                    }
                    else if( [JoystickManager sharedInstance].Gdown == 2)
                    {
                        // (2, 5) ( 1,5) (4,5) (3,5) ( 2,4) ( 1,3) (1,4) ( 2,3)
                        
                        if(
                       ( [ [JoystickManager sharedInstance].codeArray[1] isEqual:@"1" ]  && [[JoystickManager sharedInstance].codeArray[4] isEqual:@"4" ] ) ||
                           ( [ [JoystickManager sharedInstance].codeArray[1] isEqual:@"0" ]  && [[JoystickManager sharedInstance].codeArray[4] isEqual:@"4" ] ) ||
                           ( [ [JoystickManager sharedInstance].codeArray[3] isEqual:@"1" ]  && [[JoystickManager sharedInstance].codeArray[4] isEqual:@"4" ] ) ||
                           ( [ [JoystickManager sharedInstance].codeArray[2] isEqual:@"1" ]  && [[JoystickManager sharedInstance].codeArray[4] isEqual:@"4" ] ) ||
                           ( [ [JoystickManager sharedInstance].codeArray[1] isEqual:@"1" ]  && [[JoystickManager sharedInstance].codeArray[3] isEqual:@"4" ] ) ||
                           ( [ [JoystickManager sharedInstance].codeArray[0] isEqual:@"1" ]  && [[JoystickManager sharedInstance].codeArray[2] isEqual:@"4" ] ) ||
                           ( [ [JoystickManager sharedInstance].codeArray[0] isEqual:@"1" ]  && [[JoystickManager sharedInstance].codeArray[3] isEqual:@"4" ] ) ||
                           ( [ [JoystickManager sharedInstance].codeArray[1] isEqual:@"1" ]  && [[JoystickManager sharedInstance].codeArray[2] isEqual:@"4" ] )

                           )
                        {
                            if([JoystickManager sharedInstance].touches > 7)
                            {
                                [JoystickManager sharedInstance].Gdown = 0;
                                [JoystickManager sharedInstance].touches = 0;
                     
                                commonFinalize1();
                    
                            }
                            else if([JoystickManager sharedInstance].touches <=5 )
                            {
                                [JoystickManager sharedInstance].Gdown = 0;
                                [JoystickManager sharedInstance].touches = 0;
                              commonFinalize();
                    
                            }
                          //  [JoystickManager sharedInstance].gdown = 0;
                        
                        }
                    }
                    else if( [JoystickManager sharedInstance].Gdown == 3)
                    {
                        // (2,3,5) (2,4,5) (1,3,5) (1,4,5)
                        if(
                       
                       ( [ [JoystickManager sharedInstance].codeArray[1] isEqual:@"1" ]  && [[JoystickManager sharedInstance].codeArray[2] isEqual:@"4" ]  && [[JoystickManager sharedInstance].codeArray[4] isEqual:@"4" ] ) ||
                           
                         (  [ [JoystickManager sharedInstance].codeArray[1] isEqual:@"1" ]  && [[JoystickManager sharedInstance].codeArray[3] isEqual:@"4" ]  && [[JoystickManager sharedInstance].codeArray[4] isEqual:@"4" ] )||
                         (  [ [JoystickManager sharedInstance].codeArray[0] isEqual:@"1" ]  && [[JoystickManager sharedInstance].codeArray[2] isEqual:@"4" ]  && [[JoystickManager sharedInstance].codeArray[4] isEqual:@"4" ] ) ||
                         (  [ [JoystickManager sharedInstance].codeArray[0] isEqual:@"1" ]  && [[JoystickManager sharedInstance].codeArray[3] isEqual:@"4" ]  && [[JoystickManager sharedInstance].codeArray[4] isEqual:@"4" ] )
                     
                        )
                        {
                            if([JoystickManager sharedInstance].touches > 7)
                            {
                                [JoystickManager sharedInstance].Gdown = 0;
                                [JoystickManager sharedInstance].touches = 0;
                     
                                commonFinalize1();
                    
                            }
                            else if([JoystickManager sharedInstance].touches <= 7 )
                            {
                                [JoystickManager sharedInstance].Gdown = 0;
                                [JoystickManager sharedInstance].touches = 0;
                                commonFinalize();
                    
                            }
                           // [JoystickManager sharedInstance].gdown = 0;
                        
                        }
                      //0100000000000000
                    }
                    else
                    {
                        [JoystickManager sharedInstance].gdown = 0;
                        [JoystickManager sharedInstance].touches = 0;
                    }
                    [JoystickManager sharedInstance].touches = 0;
         
                //    [[JoystickManager sharedInstance].code  insertString:@"1" atIndex:elementUsage - 1];
      
                  
                    NSLog(@"code %@ ",  [JoystickManager sharedInstance].code);
                     
                   
                }
                
                
            }
        
           
           
            
        }
        
       
   
 
        
       // return;
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
