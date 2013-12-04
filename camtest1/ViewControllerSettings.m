//
//  ViewControllerSettings.m
//  camtest1
//
//  Created by dev on 12/4/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "ViewControllerSettings.h"

@interface ViewControllerSettings ()
{
    __weak IBOutlet UITextField *_nameTextField;
    __weak IBOutlet UITextField *_emailTextField;
}

@end

@implementation ViewControllerSettings

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.delegate respondsToSelector:@selector(name)])
        _nameTextField.text = [self.delegate name];
    if ([self.delegate respondsToSelector:@selector(email)])
        _emailTextField.text = [self.delegate email];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _nameTextField)
    {
        if ([self.delegate respondsToSelector:@selector(setName:)])
            [self.delegate setName:[textField text]];
    }
    if (textField == _emailTextField)
    {
        if ([self.delegate respondsToSelector:@selector(setEmail:)])
            [self.delegate setEmail:[textField text]];
    }
    
    [textField resignFirstResponder];
    return YES;
}

@end
