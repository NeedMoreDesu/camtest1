//
//  UIImageMeta.h
//  camtest1
//
//  Created by dev on 11/29/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "Sync.h"

@interface UIImageMeta : NSObject

@property UIImage *image;
@property NSDictionary *metadata;
@property CLLocation *location;
@property Sync *sync;

- (void) saveImageWithName:(NSString*)name quality:(float)quality;

@end
