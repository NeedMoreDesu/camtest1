//
//  UIImageMeta.m
//  camtest1
//
//  Created by dev on 11/29/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "ShotImage.h"
#import <ImageIO/ImageIO.h>
// #import "EXF.h"
// #import "EXFUtils.h"

@implementation ShotImage

@synthesize image = _image;

- (void)saveImageWithQuality:(float)quality
              atDirectory:(NSURL*)directory
{
    [self.metadata acceptChanges];
    if([self image] && directory)
    {
        NSString *docDir = [directory path];
        
        // If you go to the folder below, you will find those pictures
        NSLog(@"%@",docDir);
        
        NSLog(@"saving jpeg");
        NSString *name = self.metadata.filename;
        CLLocation *location = self.metadata.location;
        NSString *jpegFilePath = [NSString stringWithFormat:@"%@/%@.jpeg",docDir,name];
        NSData *data = [NSData dataWithData:UIImageJPEGRepresentation([self image], quality)];
        
        NSMutableData *dest_data = [NSMutableData data];
        CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
        if (!source)
        {
            NSLog(@"***Could not create image source ***");
        }
        CFStringRef UTI = CGImageSourceGetType(source);
        CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data,UTI,1,NULL);
        if(!destination) {
            NSLog(@"***Could not create image destination ***");
        }
        NSDictionary *meta = self.metadata.metadata;
        if(!meta)
            meta =
            [NSMutableDictionary dictionaryWithDictionary:
             (__bridge NSDictionary *)
             CGImageSourceCopyPropertiesAtIndex(source,0,NULL)];
        if(location)
        {
            NSDictionary *gps = [self getGPSDictionaryForLocation:location];
            NSString *key = (NSString*)kCGImagePropertyGPSDictionary;
            [meta
             setValue: gps
             forKey: key];
        }
        CGImageDestinationAddImageFromSource(destination,source,0, (__bridge CFDictionaryRef) meta);
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

- (ShotImage*) initWithShotMetadata:(ShotMetadata*)shotMetadata
{
    NSURL *homeURL = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    NSURL *url;
    if (shotMetadata.filename)
     url = [[homeURL
             URLByAppendingPathComponent:shotMetadata.filename]
            URLByAppendingPathExtension:@"jpeg"];
    if ([super init])
    {
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
//        NSDictionary *dic = nil;
//        CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)(data), NULL);
        
//        if ( NULL == source )
//        {
//#ifdef _DEBUG
//            CGImageSourceStatus status = CGImageSourceGetStatus ( source );
//            NSLog ( @"Error: file name : %@ - Status: %d", file, status );
//#endif
//        }
//        else
//        {
//            CFDictionaryRef metadataRef =
//            CGImageSourceCopyPropertiesAtIndex ( source, 0, NULL );
//            if ( metadataRef )
//            {
//                NSDictionary* immutableMetadata = (__bridge NSDictionary *)metadataRef;
//                if ( immutableMetadata )
//                {
//                    dic =
//                    [ NSDictionary dictionaryWithDictionary : (__bridge NSDictionary *)metadataRef ];
//                }
//                
//                CFRelease ( metadataRef );
//            }
//            
//            CFRelease(source);
//            source = nil;
//        }
        self.image = [[UIImage alloc] initWithData:data];
//        self.metadata.metadata = [NSMutableDictionary dictionaryWithDictionary:dic];
        self.mwPhoto = [[MWPhoto alloc] initWithImage:self.image];
        self.metadata = shotMetadata;
    }
    return self;
}

- (UIImage *)image
{
    return _image;
}
- (void) setImage:(UIImage *)image
{
    _image = image;
    _mwPhoto = [[MWPhoto alloc] initWithImage:self.image];
}

- (NSDictionary *)getGPSDictionaryForLocation:(CLLocation *)location {
    NSMutableDictionary *gps = [NSMutableDictionary dictionary];
    
    // GPS tag version
    [gps setObject:@"2.2.0.0" forKey:(NSString *)kCGImagePropertyGPSVersion];
    
    // Time and date must be provided as strings, not as an NSDate object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss.SSSSSS"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [gps setObject:[formatter stringFromDate:location.timestamp] forKey:(NSString *)kCGImagePropertyGPSTimeStamp];
    [formatter setDateFormat:@"yyyy:MM:dd"];
    [gps setObject:[formatter stringFromDate:location.timestamp] forKey:(NSString *)kCGImagePropertyGPSDateStamp];
    
    // Latitude
    CGFloat latitude = location.coordinate.latitude;
    if (latitude < 0) {
        latitude = -latitude;
        [gps setObject:@"S" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
    } else {
        [gps setObject:@"N" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
    }
    [gps setObject:[NSNumber numberWithFloat:latitude] forKey:(NSString *)kCGImagePropertyGPSLatitude];
    
    // Longitude
    CGFloat longitude = location.coordinate.longitude;
    if (longitude < 0) {
        longitude = -longitude;
        [gps setObject:@"W" forKey:(NSString *)kCGImagePropertyGPSLongitudeRef];
    } else {
        [gps setObject:@"E" forKey:(NSString *)kCGImagePropertyGPSLongitudeRef];
    }
    [gps setObject:[NSNumber numberWithFloat:longitude] forKey:(NSString *)kCGImagePropertyGPSLongitude];
    
    // Altitude
    CGFloat altitude = location.altitude;
    if (!isnan(altitude)){
        if (altitude < 0) {
            altitude = -altitude;
            [gps setObject:@"1" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
        } else {
            [gps setObject:@"0" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
        }
        [gps setObject:[NSNumber numberWithFloat:altitude] forKey:(NSString *)kCGImagePropertyGPSAltitude];
    }
    
    // Speed, must be converted from m/s to km/h
    if (location.speed >= 0){
        [gps setObject:@"K" forKey:(NSString *)kCGImagePropertyGPSSpeedRef];
        [gps setObject:[NSNumber numberWithFloat:location.speed*3.6] forKey:(NSString *)kCGImagePropertyGPSSpeed];
    }
    
    // Heading
    if (location.course >= 0){
        [gps setObject:@"T" forKey:(NSString *)kCGImagePropertyGPSTrackRef];
        [gps setObject:[NSNumber numberWithFloat:location.course] forKey:(NSString *)kCGImagePropertyGPSTrack];
    }
    
    return gps;
}

@end
