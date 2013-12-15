//
//  ViewControllerSave.h
//  camtest1
//
//  Created by dev on 12/4/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "State.h"
#import "ShotImage.h"

@interface ViewControllerSave : UIViewController
<UITextViewDelegate,
UITextFieldDelegate>

//@property ShotImage *metaImage;
@property State *state;

@end
