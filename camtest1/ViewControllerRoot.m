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
#import "Sync.h"

@interface ViewControllerRoot ()
{
    __weak IBOutlet UITableViewCell *_viewCreatedCell;
}
@property NSArray *photos;

@end

@implementation ViewControllerRoot

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"Settings"])
    {
        ViewControllerSettings *viewControllerSettings = [segue destinationViewController];
        viewControllerSettings.delegate = self;
    }
//    if([[segue identifier] isEqualToString:@"TakingPhoto"])
//    {
//        TabBarController *tabBarController = [segue destinationViewController];
//        [tabBarController setMetaImage:_metaImage];
//        [tabBarController setState:_state];
//    }
    if([[segue destinationViewController] respondsToSelector:@selector(setState:)])
        [[segue destinationViewController] setState:self.state];
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
//    _metaImage = [[ShotImage alloc] init];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.state.meta updateOpenDate];
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
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    [imageCache cleanDisk];

    NSArray *metadatas = [ShotMetadata fetchShotMetadataWithContext:self.state.managedObjectContext];

    self.photos =
    [metadatas map:^id(ShotMetadata *item) {
        if(!item.image)
        {
            ShotImage *image = [[ShotImage alloc] initWithShotMetadata:item];
            item.image = image;
        }
        item.image.mwPhoto.caption = item.description;
        return item;
    }];

    self.photos = [self.photos filter:^BOOL(NSUInteger idx, ShotMetadata *item) {
        return item.image.image != nil;
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
    {
        ShotMetadata *meta = [self.photos objectAtIndex:index];
        return [meta.image mwPhoto];
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
    ShotMetadata *meta = [self.photos objectAtIndex:index];
    self.state.meta = meta;
//    [[metaImage state] setLocation:nil];
}


@end
