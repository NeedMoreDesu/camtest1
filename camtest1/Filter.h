//
//  Filter.h
//  camtest1
//
//  Created by dev on 12/4/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef UIImage* (^UIImageBlock)(UIImage* image);

@interface Filter : NSObject

@property NSString *name;
@property NSString *description;
@property Class filterClass;

- (Filter*) initWithName:(NSString*)name
          description:(NSString*)description
                class:(Class)filterClass;
- (UIImage*) applyFilterToImage:(UIImage*)image;

+ (NSArray*) filters;

@end
