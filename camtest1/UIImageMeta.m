//
//  UIImageMeta.m
//  camtest1
//
//  Created by dev on 11/29/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "UIImageMeta.h"
#import <ImageIO/ImageIO.h>
// #import "EXF.h"
// #import "EXFUtils.h"

@implementation UIImageMeta

- (void)saveImageWithName:(NSString*)name quality:(float)quality
{
    if([self image])
    {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        // If you go to the folder below, you will find those pictures
        NSLog(@"%@",docDir);
        
        NSLog(@"saving jpeg");
        NSString *jpegFilePath = [NSString stringWithFormat:@"%@/%@.jpeg",docDir,name];
        NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation([self image], quality)];
        
        NSMutableData *dest_data = [NSMutableData data];
        CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge CFDataRef)data2, NULL);
        if (!source)
        {
            NSLog(@"***Could not create image source ***");
        }
        CFStringRef UTI = CGImageSourceGetType(source);
        CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data,UTI,1,NULL);
        if(!destination) {
            NSLog(@"***Could not create image destination ***");
        }
        CGImageDestinationAddImageFromSource(destination,source,0, (__bridge CFDictionaryRef) [self metadata]);
        BOOL success = NO;
        success = CGImageDestinationFinalize(destination);
        if(!success) {
            NSLog(@"***Could not create data from image destination ***");
        }
        
        [dest_data writeToFile:jpegFilePath atomically:YES];
        
        CFRelease(destination);
        CFRelease(source);
        
        NSLog(@"saving image done");
    }
}

@end
