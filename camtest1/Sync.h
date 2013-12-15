//
//  Sync.h
//  camtest1
//
//  Created by dev on 12/6/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sync : NSObject

@property NSURL *targetDirectory;
@property NSURL *homeDirectory;

- (void)simpleSync;

@end
