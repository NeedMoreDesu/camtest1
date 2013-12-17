//
//  ShotMetadata.m
//  camtest1
//
//  Created by dev on 12/13/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "ShotMetadata.h"


@implementation ShotMetadata

@dynamic metadata_data;
@dynamic desc;
@dynamic location_data;
@dynamic filename;
@dynamic open_date;
@dynamic change_date;

@synthesize image = _image;
@synthesize unsaved_change_date = _unsaved_change_date;
@synthesize unsaved_location = _unsaved_location;
@synthesize unsaved_metadata = _unsaved_metadata;
@synthesize unsaved_desc = _unsaved_desc;

+ (ShotMetadata*) shotMetadataWithContext:(NSManagedObjectContext*)context
{
    ShotMetadata * result = [NSEntityDescription
                             insertNewObjectForEntityForName:NSStringFromClass([self class])
                             inManagedObjectContext:context];
    [result updateOpenDate];
    return result;
}

+ (ShotMetadata*) shotMetadataWithContext:(NSManagedObjectContext *)context filename:(NSString*)filename
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription entityForName:@"ShotMetadata"
                                      inManagedObjectContext:context];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"filename = %@", filename]];
    [fetchRequest setFetchLimit:1];
    NSArray *result = [context executeFetchRequest:fetchRequest
                                              error:nil];
    if(result.count > 0)
    {
        ShotMetadata *res = result[0];
        [res updateOpenDate];
        return res;
    }
    else
    {
        ShotMetadata *res = [self shotMetadataWithContext:context];
        res.filename = filename;
        return res;
    }
}

+ (ShotMetadata*) lastShotMetadataWithContext:(NSManagedObjectContext*)context
{
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    fetchRequest.entity = [NSEntityDescription
                           entityForName:@"ShotMetadata"
                           inManagedObjectContext:context];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"open_date"
                                        ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    [fetchRequest setFetchLimit:1];
    NSArray *result = [context executeFetchRequest:fetchRequest error:nil];
    if(result.count > 0)
    {
        ShotMetadata *res = result[0];
        [res updateOpenDate];
        return res;
    }
    else
        return [self shotMetadataWithContext:context filename:nil];
}

- (ShotMetadata*) shotMetadataWithContext:(NSManagedObjectContext *)context filename:(NSString *)filename
{
    ShotMetadata * result = [ShotMetadata shotMetadataWithContext:context filename:filename];
    result.metadata_data = self.metadata_data;
    result.location_data = self.location_data;
    result.change_date = self.change_date;
    result.desc = self.desc;
    
    result.unsaved_change_date = self.unsaved_change_date;
    result.unsaved_metadata = self.unsaved_metadata;
    result.unsaved_location = self.unsaved_location;
    result.unsaved_desc = self.unsaved_desc;
    
    return result;
}

+ (NSArray*) fetchShotMetadataWithContext:(NSManagedObjectContext*)context
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:NSStringFromClass([self class])
                                   inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"open_date"
                                        ascending:NO];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        NSLog(@"Fetch error: %@", error);
        return nil;
    }
    return result;
}

- (void) setMetadata:(NSDictionary *)metadata
{
    [self setMetadata_data: [NSKeyedArchiver archivedDataWithRootObject:metadata]];
}
- (NSDictionary*) metadata
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.metadata_data];
}

- (void) setLocation:(CLLocation *)location
{
    [self setLocation_data: [NSKeyedArchiver archivedDataWithRootObject:location]];
}
- (CLLocation*) location
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.location_data];
}

- (void) updateOpenDate
{
    self.open_date = [NSDate date];
}

- (void) acceptChanges
{
    self.change_date = self.unsaved_change_date?self.unsaved_change_date:self.change_date;
    self.metadata = self.unsaved_metadata?self.unsaved_metadata:self.metadata;
    self.location = self.unsaved_location?self.unsaved_location:self.location;
    self.desc = self.unsaved_desc?self.unsaved_desc:self.desc;
    [self dumpChanges];
}

- (void) dumpChanges
{
    self.unsaved_change_date = nil;
    self.unsaved_location = nil;
    self.unsaved_metadata = nil;
    self.unsaved_desc = nil;
}

- (void) updateUnsavedChangeDate
{
    self.unsaved_change_date = [NSDate date];
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"%@ %@\n%@\n%@\n%@",
            self.filename?self.filename:@"*no-filename*",
            self.unsaved_change_date?@"(unsaved changes)":@"",
            self.change_date,
            self.desc,
            self.location_data?self.location:@""];
}

@end
