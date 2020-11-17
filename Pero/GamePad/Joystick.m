//
//  Joystick.m
//  JoystickHIDTest
//
//  Created by John Stringham on 12-05-01.
//  Copyright 2012 We Get Signal. All rights reserved.
//

#import "Joystick.h"
#import "JoystickHatswitch.h"

@implementation Joystick

@synthesize device;

- (id)initWithDevice:(IOHIDDeviceRef)theDevice
{
    self = [super init];
    if (self) {
        device = theDevice;
        
        delegates = [[NSMutableArray alloc] initWithCapacity:0];
        
        elements = (NSArray *)CFBridgingRelease(IOHIDDeviceCopyMatchingElements(theDevice, NULL, kIOHIDOptionsTypeNone));
        
        NSMutableArray *tempButtons = [NSMutableArray array];
        NSMutableArray *tempAxes = [NSMutableArray array];
        NSMutableArray *tempHats = [NSMutableArray array];
        
        int i;
        for (i=0; i<elements.count; ++i) {
            
            IOHIDElementRef thisElement = (IOHIDElementRef)CFBridgingRetain([elements objectAtIndex:i]);
            
            int elementType = IOHIDElementGetType(thisElement);
            int elementUsage = IOHIDElementGetUsage(thisElement);
            
            if (elementUsage == kHIDUsage_GD_Hatswitch) {
                JoystickHatswitch *hatSwitch = [[JoystickHatswitch alloc] initWithElement:thisElement andOwner:self];
                [tempHats addObject:hatSwitch];
            //    [hatSwitch release];
            } else if (elementType == kIOHIDElementTypeInput_Axis || elementType == kIOHIDElementTypeInput_Misc) {
                [tempAxes addObject:CFBridgingRelease(thisElement)];
            } else {
                [tempButtons addObject:CFBridgingRelease(thisElement)];
            }
        }
        buttons = [NSArray arrayWithArray:tempButtons] ;
        axes = [NSArray arrayWithArray:tempAxes] ;
        hats = [NSArray arrayWithArray:tempHats] ;
        
        NSLog(@"New device address: %p from %p",device,theDevice);
        NSLog(@"found %lu buttons, %lu axes and %lu hats",tempButtons.count,tempAxes.count,tempHats.count);
        // For more detailed info there are Usage tables
        // eg: kHIDUsage_GD_X
        // declared in IOHIDUsageTables.h
        // could use to determine major axes

		/*
         Get the vendor ID (which is a 32-bit integer)
		 */
		CFNumberRef vendor, product;
		CFStringRef manufacturer;
		CFStringRef productName_;
		char string_buffer[1024];

		if ((vendor = (CFNumberRef)IOHIDDeviceGetProperty(device, CFSTR(kIOHIDVendorIDKey))) != NULL)
			CFNumberGetValue(vendor, kCFNumberSInt32Type, &vendorID);
		printf("vendorID: %04lX ", vendorID);

		/*
         Get the product ID (which is a 32-bit integer)
		 */
		if ((product = (CFNumberRef)IOHIDDeviceGetProperty(device, CFSTR(kIOHIDProductIDKey))) != NULL)
			CFNumberGetValue((CFNumberRef)product, kCFNumberSInt32Type, &productID);
		printf("productID: %04lX\n", productID);

		/*
         Get the manufacturer name (which is a string)
		 */
		if ((manufacturer = (CFStringRef)IOHIDDeviceGetProperty(device, CFSTR(kIOHIDManufacturerKey)))!= NULL)
		{
			CFStringGetCString(manufacturer, string_buffer, sizeof(string_buffer), kCFStringEncodingUTF8);
			printf("Manufacturer: %s\n", string_buffer);
			manufacturerName = [NSString stringWithUTF8String:string_buffer];
		}

		/*
         Get the product name (which is a string)
		 */
		if ((productName_ = (CFStringRef)IOHIDDeviceGetProperty(device, CFSTR(kIOHIDProductKey))) != NULL)
		{
			CFStringGetCString(productName_, string_buffer, sizeof(string_buffer), kCFStringEncodingUTF8);
			printf("Product Name: %s\n", string_buffer);
			productName = [NSString stringWithUTF8String:string_buffer];
		}

    }

    return self;
}

- (void)elementReportedChange:(IOHIDElementRef)theElement {

    int elementType = IOHIDElementGetType(theElement);
    IOHIDValueRef pValue;
    IOHIDDeviceGetValue(device, theElement, &pValue);
    
    int elementUsage = IOHIDElementGetUsage(theElement);
    int value = IOHIDValueGetIntegerValue(pValue);
    int i;
    
   
    
    if (elementType != kIOHIDElementTypeInput_Axis && elementType == kIOHIDElementTypeInput_Button) {
        
        
        for (i=0; i<1; ++i) {
       //     id <JoystickNotificationDelegate> delegate = [delegates objectAtIndex:i];
            
            if (value==1)
            {
             //   [delegate joystickButtonPushed:[self getElementIndex:theElement] onJoystick:self];
                
                if(elementUsage == 5)
                {
                    // 상
                    NSLog(@"Gesture up");
                   
                }
                else if(elementUsage == 6)
                {
                    // 하
                    NSLog(@"Gesture down");
               }
                else if(elementUsage == 7)
                {
                    // 좌
                    NSLog(@"Gesture Left");
                }
                else if(elementUsage == 8)
                {
                    // 우
                    NSLog(@"Gesture Right");
     
                }
                else if(elementUsage >= 9)
                {
                    NSLog(@"Gesture %d", elementUsage);
                }
             
            }
            else
            {
             //   [delegate joystickButtonReleased:[self getElementIndex:theElement] onJoystick:self];
            }
        }
        
        return;
    }
    
    
    
  //  NSLog(@"Axis reported value of %d",value);
    
    for (i=0; i<delegates.count; ++i) {
        id <JoystickNotificationDelegate> delegate = [delegates objectAtIndex:i];
        
        [delegate joystickStateChanged:self];
    }
}

- (void)registerForNotications:(id <JoystickNotificationDelegate>)delegate {
    [delegates addObject:delegate];
}

- (void)deregister:(id<JoystickNotificationDelegate>)delegate {
    [delegates removeObject:delegate];
}

- (int)getElementIndex:(IOHIDElementRef)theElement {
    int elementType = IOHIDElementGetType(theElement);
    
    NSArray *searchArray;
    NSString *returnString = @"";
    
    if (elementType == kIOHIDElementTypeInput_Button) {
        searchArray = buttons;
        returnString = @"Button";
    } else {
        searchArray = axes;
        returnString = @"Axis";
    }
    
    int i;
    
    for (i=0; i<searchArray.count; ++i) {
        if ([searchArray objectAtIndex:i] == CFBridgingRelease(theElement))
            return i;
            //  returnString = [NSString stringWithFormat:@"%@_%d",returnString,i];
    }
    
    return -1;
}

- (double)getRelativeValueOfAxesIndex:(int)index {
    IOHIDElementRef theElement = (IOHIDElementRef)CFBridgingRetain([axes objectAtIndex:index]);
    
    double value;
    double min = IOHIDElementGetLogicalMin(theElement);
    double max = IOHIDElementGetLogicalMax(theElement);

	NSLog(@"%f %f", min, max);
    IOHIDValueRef pValue;
    IOHIDDeviceGetValue(device, theElement, &pValue);
    
    value = ((double)IOHIDValueGetIntegerValue(pValue)-min) * (1/(max-min));
    
    return value;
}

- (unsigned int)numButtons {
    return (unsigned int)[buttons count];
}

- (unsigned int)numAxes {
    return (unsigned int)[axes count];
}

- (unsigned int)numHats {
    return (unsigned int)[hats count];
}


- (long)vendorID{
	return vendorID;
}

- (long)productID{
	return productID;
}

- (NSString*)productName{
	return productName;
}

- (NSString*)manufacturerName{
	return manufacturerName;
}




@end
