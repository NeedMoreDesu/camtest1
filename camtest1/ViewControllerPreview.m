//
//  ViewController.m
//  camtest1
//
//  Created by dev on 11/26/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "ViewControllerPreview.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MWPhotoBrowser.h"
#import "NSArray+Func.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import <ImageIO/ImageIO.h>
#import <GPUImage/GPUImage.h>
#import <SDWebImage/SDImageCache.h>
#import "Filter.h"

@interface ViewControllerPreview ()
{
    __weak IBOutlet UIImageView *_imageView;
}

@end

@implementation ViewControllerPreview

#pragma mark - Internals

- (void)simpleAlert:(NSString*)title message:(NSString*)message
{
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [[[UIAlertView alloc]
                         initWithTitle:title
                         message:message
                         delegate:nil
                         cancelButtonTitle:@"Ok"
                         otherButtonTitles:nil]
                        show];
                   });
}

#pragma mark - ViewController delagate

- (void)viewWillAppear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [_imageView setImage:[self.state.meta.image image]];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_imageView setImage:[self.state.meta.image image]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)takePhoto:(UIButton *)sender {
    if([UIImagePickerController
        isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
       == NO)
    {
        [self simpleAlert:@"No camera" message:nil];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Image Picker Controller delegate methods

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    UIImage *originalImage, *editedImage, *image;
    
    editedImage = (UIImage *) [info objectForKey:
                               UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:
                                 UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        image = editedImage;
    } else {
        image = originalImage;
    }
    
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:assetURL
             resultBlock:^(ALAsset *asset) {
                 self.state.meta.unsaved_metadata =
                  [NSMutableDictionary
                   dictionaryWithDictionary:[[asset defaultRepresentation] metadata]];
//                 CLLocation *location = [asset valueForProperty:ALAssetPropertyLocation];
//                 NSLog(@"%@", location);
             }
            failureBlock:^(NSError *error) {
            }];

    [self.state.meta.image setImage: image];
    self.state.meta.unsaved_location = self.state.location;
    [self.state.meta updateUnsavedChangeDate];
    [_imageView setImage: [self.state.meta.image image]];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
