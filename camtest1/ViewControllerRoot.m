//
//  ViewControllerRoot.m
//  camtest1
//
//  Created by dev on 12/4/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "ViewControllerRoot.h"
#import "TabBarController.h"
#import <SDWebImage/SDImageCache.h>
#import "NSArray+Func.h"
#import <GPUImage/GPUImage.h>

@interface ViewControllerRoot ()
{
    __weak IBOutlet UITableViewCell *_viewCreatedCell;
}
@property NSMutableArray *photos;

@end

@implementation ViewControllerRoot

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"Settings"])
    {
        ViewControllerSettings *viewControllerSettings = [segue destinationViewController];
        viewControllerSettings.delegate = self;
    }
    if([[segue identifier] isEqualToString:@"TakingPhoto"])
    {
        TabBarController *tabBarController = [segue destinationViewController];
        [tabBarController setMetaImage:_metaImage];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _metaImage = [[UIImageMeta alloc] init];
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

	// Do any additional setup after loading the view.
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    _metaImage.location = newLocation;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
    UITableViewCell *cell=(UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell == _viewCreatedCell)
    {
        [self viewCreatedShots];
    }
}


- (void)viewCreatedShots {
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

#pragma mark - PhotoBrowser delegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return self.photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < self.photos.count)
        return [self.photos objectAtIndex:index];
    return nil;
}



@end
