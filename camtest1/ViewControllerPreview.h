//
//  ViewController.h
//  camtest1
//
//  Created by dev on 11/26/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "ShotImage.h"
#import "State.h"

@interface ViewControllerPreview : UIViewController
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

//@property ShotImage *metaImage;
@property State *state;

@end
