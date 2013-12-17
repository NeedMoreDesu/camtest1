//
//  ShotMetadata.h
//  camtest1
//
//  Created by dev on 12/13/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
//#import "ShotImage.h"

@class ShotImage;

@interface ShotMetadata : NSManagedObject

@property (nonatomic, retain) NSData * metadata_data;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSData * location_data;
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSDate * open_date;
@property (nonatomic, retain) NSDate * change_date;

@property (nonatomic, strong) ShotImage *image;

@property (nonatomic, strong) NSDate *unsaved_change_date;
@property (nonatomic, strong) NSDictionary *unsaved_metadata;
@property (nonatomic, strong) CLLocation *unsaved_location;
@property (nonatomic, strong) NSString *unsaved_desc;

+ (ShotMetadata*) shotMetadataWithContext:(NSManagedObjectContext*)context;
+ (ShotMetadata*) shotMetadataWithContext:(NSManagedObjectContext *)context filename:(NSString*)filename;
+ (ShotMetadata*) lastShotMetadataWithContext:(NSManagedObjectContext*)context;
- (ShotMetadata*) shotMetadataWithContext:(NSManagedObjectContext *)context filename:(NSString *)filename;

+ (NSArray*) fetchShotMetadataWithContext:(NSManagedObjectContext*)context;

- (void) setMetadata:(NSDictionary *)metadata;
- (NSDictionary*) metadata;

- (void) setLocation:(CLLocation *)location;
- (CLLocation*) location;

- (void) updateOpenDate;
- (void) acceptChanges;
- (void) dumpChanges;
- (void) updateUnsavedChangeDate;

@end
