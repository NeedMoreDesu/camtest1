//
//  TabBarController.m
//  camtest1
//
//  Created by dev on 12/4/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()
{
    
}

@end

@implementation TabBarController

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
    [self setDelegate:self];
    [self
     tabBarController:self
     didSelectViewController:[[self viewControllers] objectAtIndex:0]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController
shouldSelectViewController:(UIViewController *)viewController
{
    
    return
    ([[viewController title] isEqual: @"View"]) ||
    [[self metaImage] image] != nil;
}

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(id)viewController
{
    if ([viewController respondsToSelector:@selector(setMetaImage:)])
        [viewController setMetaImage: _metaImage];
}

@end
