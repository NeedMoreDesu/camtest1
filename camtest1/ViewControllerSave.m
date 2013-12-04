//
//  ViewControllerSave.m
//  camtest1
//
//  Created by dev on 12/4/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "ViewControllerSave.h"

@interface ViewControllerSave ()
{
    __weak IBOutlet UITextField *_text;
    __weak IBOutlet UISlider *_scroll;
}

@end

@implementation ViewControllerSave

-(NSString*) generateFilename
{
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *prefix = @"pic";
    NSString *filename;
    int i;
    for (i = 1; true; i++) {
        filename = [[NSString alloc] initWithFormat:@"%@%d", prefix, i];
        if(![fileManager
             fileExistsAtPath: [[docDir
                                 stringByAppendingPathComponent:filename]
                                stringByAppendingPathExtension:@"jpeg"]])
            break;
    }
    return filename;
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
    _text.text = [self generateFilename];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePhoto:(UIButton *)sender {
    [_metaImage
     saveImageWithName:[_text text]
     quality:[_scroll value]];
    _text.text = [self generateFilename];
}



@end
