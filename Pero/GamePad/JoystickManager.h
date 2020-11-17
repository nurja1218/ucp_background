//
//  JoystickManager.h
//  JoystickHIDTest
//
//  Created by John Stringham on 12-05-01.
//  Copyright 2012 We Get Signal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/hid/IOHIDLib.h>
#import "Joystick.h"

@protocol JoySticDelegate <NSObject>

- (void)unpluged:(NSMutableDictionary*)device;
- (void)pressed:(NSString*)gesture;


@end


@interface JoystickManager : NSObject {
   // id      joystickAddedDelegate;
    NSMutableDictionary  *joysticks;
@private
    IOHIDManagerRef hidManager;
    
 
    
    int                 joystickIDIndex;
    
    
}

@property(assign) id joystickAddedDelegate;
@property(assign) id<JoySticDelegate> delegate;
@property(assign) int                 down;
@property(assign) int                 up;
@property(assign) int                 touches;
@property(assign) NSString*           gesture;

+ (JoystickManager *)sharedInstance;
- (unsigned long)connectedJoysticks;
- (void)registerNewJoystick:(Joystick *)joystick;

- (int)deviceIDByReference:(IOHIDDeviceRef)deviceRef;
- (Joystick *)joystickByID:(int)joystickID;
- (void)setupGamepads;
@end

