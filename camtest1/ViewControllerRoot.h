//
//  ViewControllerRoot.h
//  camtest1
//
//  Created by dev on 12/4/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageMeta.h"
#import "MWPhotoBrowser.h"
#import "ViewControllerSettings.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewControllerRoot : UITableViewController
<MWPhotoBrowserDelegate,
UITableViewDelegate,
SettingsDelegate,
CLLocationManagerDelegate>

@property NSString *name;
@property NSString *email;
@property UIImageMeta *metaImage;
@property CLLocationManager *locationManager;

@end
