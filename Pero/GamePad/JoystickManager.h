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
- (void)pluged;

- (void)pressed:(NSString*)gesture;
- (void)pressed1:(NSString*)gesture;
- (void)touchDown:(int)gesture;
- (void)touchUp:(int)gesture;
- (void)errorDown:(int)gesture;
- (BOOL)isSuccess;


- (void)startDownTimer;
- (void)endDownTimer;

-(void)modSet;
-(int)getIndex;

- (void)toggle:(BOOL)mode;

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
@property(assign) int                 tdown;
@property(assign) int                 up;
@property(assign) int                 Gdown;

@property(assign) int                 touches;
@property(assign) BOOL                 mode;
@property(assign) BOOL                 toggle;
@property(assign) BOOL                 error;
@property(assign) BOOL                 timeout;
@property(assign) NSString*           gesture;
@property(nonatomic ,retain) NSMutableString*           code;
@property(nonatomic ,retain) NSMutableString*           gcode;

@property(nonatomic ,retain) NSMutableString*           touch;
@property(nonatomic ,retain) NSMutableArray*           codeArray;
@property(nonatomic ,retain) NSMutableArray*           touchArray;

@property(nonatomic ,retain) NSMutableArray*           dummyArray;
@property(nonatomic ,retain) NSMutableString *nameString ;


@property(assign) NSString*           dcode;
@property(assign) NSString*           ucode;

+ (JoystickManager *)sharedInstance;
- (unsigned long)connectedJoysticks;
- (void)registerNewJoystick:(Joystick *)joystick;

- (int)deviceIDByReference:(IOHIDDeviceRef)deviceRef;
- (Joystick *)joystickByID:(int)joystickID;
- (void)setupGamepads;
@end

