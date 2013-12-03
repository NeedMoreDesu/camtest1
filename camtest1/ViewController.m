//
//  ViewController.m
//  camtest1
//
//  Created by dev on 11/26/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "MWPhotoBrowser.h"
#import "NSArray+Func.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <GPUImage/GPUImage.h>
#import <SDWebImage/SDImageCache.h>
#import "UIImageMeta.h"

@interface ViewController ()
{
    __weak IBOutlet UIImageView *_imageView;
    UIImageMeta *_metaImage;
}

@end

@implementation ViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _metaImage = [[UIImageMeta alloc] init];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Buttons

- (IBAction)savePhoto:(UIButton *)sender {
    [_metaImage saveImageWithName:@"test01" quality:0.9f];
    
//    NSURL *ubiq = [[NSFileManager defaultManager]
//                   URLForUbiquityContainerIdentifier:nil];
//    if (ubiq) {
//        NSLog(@"iCloud access at %@", ubiq);
//        // TODO: Load document...
//    } else {
//        NSLog(@"No iCloud access");
//    }

}

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
                 [_metaImage setMetadata: [[asset defaultRepresentation] metadata]];
             }
            failureBlock:^(NSError *error) {
            }];

    GPUImagePicture *gpuImage = [[GPUImagePicture alloc] initWithImage:image];
    GPUImageFilter *filter2 = [[GPUImageSepiaFilter alloc] init];
    GPUImageFilter *filter1 = [[GPUImageSketchFilter alloc] init];
    [gpuImage addTarget:filter1];
    [filter1 addTarget:filter2];
    
    [gpuImage processImage];

    UIImage *filteredImage = [filter2 imageFromCurrentlyProcessedOutput];
//    UIImage *filteredImage = [filter imageByFilteringImage:image];

    [_metaImage setImage: filteredImage];
    [_imageView setImage: [_metaImage image]];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)viewSaved:(id)sender {
    // Create array of `MWPhoto` objects
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray *imageURLS = [[NSFileManager defaultManager]
                          contentsOfDirectoryAtURL:[NSURL fileURLWithPath:documentsDirectory]
                          includingPropertiesForKeys:nil
                          options:NSDirectoryEnumerationSkipsSubdirectoryDescendants
                          error:nil];
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache cleanDisk];
    self.photos = (NSMutableArray*)
    [imageURLS map:^id(id item) {
        NSLog(@"%@ of class: %@", item, [item class]);
        MWPhoto *photo = [MWPhoto photoWithURL:item];
        photo.caption = [item description];
        return photo;
    }];
    
    // Create & present browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = YES; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)

    // Present
    [self.navigationController pushViewController:browser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}

@end
