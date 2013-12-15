//
//  TabBarController.h
//  camtest1
//
//  Created by dev on 12/4/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShotImage.h"
#import "State.h"

@interface TabBarController : UITabBarController
<UITabBarControllerDelegate>

//@property ShotImage *metaImage;
@property State *state;

@end
