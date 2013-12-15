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
#import <CoreLocation/CoreLocation.h>
#import "ShotMetadata.h"

@interface ShotImage : NSObject

@property UIImage *image;
@property MWPhoto *mwPhoto;
@property ShotMetadata *metadata;

- (void)saveImageWithQuality:(float)quality
                 atDirectory:(NSURL*)directory;
- (ShotImage*) initWithShotMetadata:(ShotMetadata*)shotMetadata;

@end
