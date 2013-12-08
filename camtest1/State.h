//
//  State.h
//  camtest1
//
//  Created by dev on 12/8/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sync.h"
#import <CoreLocation/CoreLocation.h>

@interface State : NSObject

@property CLLocation *location;
@property CLLocation *currentLocation;
@property Sync *sync;

- (void) updateLocation;

@end
