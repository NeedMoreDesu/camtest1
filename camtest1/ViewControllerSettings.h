//
//  ViewControllerSettings.h
//  camtest1
//
//  Created by dev on 12/4/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsDelegate <NSObject>

-(void) setName:(NSString*) name;
-(void) setEmail:(NSString*) email;
-(NSString*) name;
-(NSString*) email;

@end

@interface ViewControllerSettings : UITableViewController
<UITextFieldDelegate>

@property id<SettingsDelegate> delegate;

@end
