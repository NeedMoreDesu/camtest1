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
#import "ShotMetadata.h"

@interface State : NSObject

@property CLLocation *location;
@property Sync *sync;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property ShotMetadata *meta;
@property NSString *tumblrBlogName;

@end
