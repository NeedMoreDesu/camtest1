//
//  ViewControllerRoot.h
//  camtest1
//
//  Created by dev on 12/4/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShotImage.h"
#import "MWPhotoBrowser.h"
#import "ViewControllerSettings.h"
#import "State.h"

@interface ViewControllerRoot : UITableViewController
<MWPhotoBrowserDelegate,
UITableViewDelegate,
SettingsDelegate>

@property NSString *name;
@property NSString *email;
//@property ShotImage *metaImage;
@property State *state;

@end
