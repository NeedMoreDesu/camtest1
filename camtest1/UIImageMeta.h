//
//  UIImageMeta.h
//  camtest1
//
//  Created by dev on 11/29/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MWPhotoBrowser/MWPhoto.h>
#import "State.h"

@interface UIImageMeta : NSObject

@property UIImage *image;
@property float quality;
@property NSMutableDictionary *metadata;
@property MWPhoto *mwPhoto;
@property State *state;

- (void) saveImageWithName:(NSString*)name quality:(float)quality;
- (UIImageMeta*) initWithURL:(NSURL*)url;

@end
