//
//  Sync.m
//  camtest1
//
//  Created by dev on 12/6/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "Sync.h"
#import "NSArray+Func.h"

@implementation Sync

- (void)simpleSync {
    if (!self.targetDirectory ||
        !self.homeDirectory)
    {
        NSLog(@"Sync failed");
        return;
    }
    
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    NSMutableArray *arr1 =
    (NSMutableArray*)
    [[manager
      contentsOfDirectoryAtURL:self.targetDirectory
      includingPropertiesForKeys:nil
      options:NSDirectoryEnumerationSkipsSubdirectoryDescendants
      error:nil]
     map:^id(id item) {
         return [item lastPathComponent];
     }];
    NSMutableArray *arr2 =
    (NSMutableArray*)
    [[manager
      contentsOfDirectoryAtURL:self.homeDirectory
      includingPropertiesForKeys:nil
      options:NSDirectoryEnumerationSkipsSubdirectoryDescendants
      error:nil]
     map:^id(id item) {
         return [item lastPathComponent];
     }];

    [arr1 enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        NSURL *from = [self.targetDirectory URLByAppendingPathComponent:obj];
        NSURL *to = [self.homeDirectory URLByAppendingPathComponent:obj];
        NSError *error = nil;
        BOOL exists = [manager fileExistsAtPath:to.path];
        NSDate *fromDate = [[manager attributesOfItemAtPath:from.path error:nil]
                            objectForKey:NSFileCreationDate];
        NSDate *toDate = [[manager attributesOfItemAtPath:to.path error:nil]
                          objectForKey:NSFileCreationDate];
        BOOL newer = [fromDate compare:toDate] == NSOrderedDescending;
        if(!exists || newer)
        {
            [manager
             copyItemAtURL:from
             toURL:to
             error:&error];
            if (error)
                NSLog(@"An error occured syncing %@ in %@", obj, self.targetDirectory);
        }
    }];
    [arr2 enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        NSURL *from = [self.homeDirectory URLByAppendingPathComponent:obj];
        NSURL *to = [self.targetDirectory URLByAppendingPathComponent:obj];
        NSError *error = nil;
        BOOL exists = [manager fileExistsAtPath:to.path];
        NSDate *fromDate = [[manager attributesOfItemAtPath:from.path error:nil]
                            objectForKey:NSFileCreationDate];
        NSDate *toDate = [[manager attributesOfItemAtPath:to.path error:nil]
                          objectForKey:NSFileCreationDate];
        BOOL newer = [fromDate compare:toDate] == NSOrderedDescending;
        if(!exists || newer)
        {
            [manager
             copyItemAtURL:from
             toURL:to
             error:&error];
            if (error)
                NSLog(@"An error occured syncing %@ in %@", obj, self.targetDirectory);
        }
    }];
}

@end
