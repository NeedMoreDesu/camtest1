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
    if (!self.directory1 ||
        !self.directory2)
    {
        NSLog(@"Sync failed");
        return;
    }
    
    NSFileManager *manager = [[NSFileManager alloc] init];
    
    NSMutableArray *arr1 =
    (NSMutableArray*)
    [[manager
      contentsOfDirectoryAtURL:self.directory1
      includingPropertiesForKeys:nil
      options:NSDirectoryEnumerationSkipsSubdirectoryDescendants
      error:nil]
     map:^id(id item) {
         return [item lastPathComponent];
     }];
    NSMutableArray *arr2 =
    (NSMutableArray*)
    [[manager
      contentsOfDirectoryAtURL:self.directory2
      includingPropertiesForKeys:nil
      options:NSDirectoryEnumerationSkipsSubdirectoryDescendants
      error:nil]
     map:^id(id item) {
         return [item lastPathComponent];
     }];
    {
        NSArray *arr1copy = [arr1 copy];
        [arr1 removeObjectsInArray:arr2];
        [arr2 removeObjectsInArray:arr1copy];
    }
    [arr1 enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        NSError *error = nil;
        [manager
         copyItemAtURL:[self.directory1 URLByAppendingPathComponent:obj]
         toURL:[self.directory2 URLByAppendingPathComponent:obj]
         error:&error];
        if (error)
            NSLog(@"An error occured syncing %@ in %@", obj, self.directory1);
    }];
    [arr2 enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        NSError *error = nil;
        [manager
         copyItemAtURL:[self.directory2 URLByAppendingPathComponent:obj]
         toURL:[self.directory1 URLByAppendingPathComponent:obj]
         error:&error];
        if (error)
            NSLog(@"An error occured syncing %@ in %@", obj, self.directory2);
    }];
}

@end
