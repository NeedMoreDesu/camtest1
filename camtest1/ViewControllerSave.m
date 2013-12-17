//
//  ViewControllerSave.m
//  camtest1
//
//  Created by dev on 12/4/13.
//  Copyright (c) 2013 dev. All rights reserved.
//

#import "ViewControllerSave.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "TumblrUploadr.h"
#import <TMAPIClient.h>

@interface ViewControllerSave ()
{
    __weak IBOutlet UILabel *_topLabel;
    __weak IBOutlet UITextField *_text;
    __weak IBOutlet UISlider *_scroll;
    __weak IBOutlet UITextView *_textView;
}
@property (weak, nonatomic) IBOutlet UIButton *saveAsNewButton;
@property (weak, nonatomic) IBOutlet UIButton *saveAsRewriteButton;

@property (nonatomic, strong) ACAccountStore *accountStore;

@end

@implementation ViewControllerSave

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed.
{
    [self.saveAsNewButton
     setTitle:[NSString stringWithFormat:@"Save as %@ (new)", _text.text]
     forState:UIControlStateNormal];
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *anotherButton =
    [[UIBarButtonItem alloc]
     initWithTitle:@"Done editing"
     style:UIBarButtonItemStylePlain
     target:_textView
     action:@selector(resignFirstResponder)];
    
    [self.tabBarController.navigationItem setRightBarButtonItem:anotherButton];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
    self.state.meta.unsaved_desc = _textView.text;
    NSError *error = nil;
    [self.state.managedObjectContext save:&error];
    if (error)
        NSLog(@"Error during metadata saving: %@", error);
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
 
    _accountStore = [[ACAccountStore alloc] init];

	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self updateFilename];
    if(self.state.meta.unsaved_desc)
        [_textView setText:self.state.meta.unsaved_desc];
    else if(self.state.meta.desc)
        [_textView setText:self.state.meta.desc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - save to document folder

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

- (void) updateFilename
{
    _text.text = [self generateFilename];
    [self.saveAsNewButton
     setTitle:[NSString stringWithFormat:@"Save as %@ (new)", _text.text]
     forState:UIControlStateNormal];
    if(self.state.meta.filename)
    {
        [self.saveAsRewriteButton
         setTitle:[NSString stringWithFormat:@"Save as %@ (rewrite)", self.state.meta.filename]
         forState:UIControlStateNormal];
        self.saveAsRewriteButton.enabled = YES;
    }
    else
        self.saveAsRewriteButton.enabled = NO;
}

- (IBAction)rewritePhoto:(UIButton *)sender {
    [self.state.meta.image
     saveImageWithQuality:_scroll.value
     atDirectory:self.state.sync.homeDirectory];
    [self.state.sync simpleSync];
    
    NSError *error = nil;
    [self.state.managedObjectContext save:&error];
    if(error)
        NSLog(@"Error during metadata saving: %@", error);
    
    _topLabel.text = [NSString stringWithFormat:@"Saved as %@", self.state.meta.filename];
    
    [self updateFilename];
}

- (IBAction)savePhoto:(UIButton *)sender {
    ShotMetadata *old = self.state.meta;
    ShotImage *image = old.image;
    old.image = nil;
    self.state.meta = [old
     shotMetadataWithContext:self.state.managedObjectContext
     filename:_text.text];
    self.state.meta.image = image;
    [old dumpChanges];
    image.metadata = self.state.meta;

    
    [self.state.meta.image
     saveImageWithQuality:_scroll.value
     atDirectory:self.state.sync.homeDirectory];
    [self.state.sync simpleSync];
    
    NSError *error = nil;
    [self.state.managedObjectContext save:&error];
    if(error)
        NSLog(@"Error during metadata saving: %@", error);
    
    _topLabel.text = [NSString stringWithFormat:@"Saved as %@", self.state.meta.filename];
    
    [self updateFilename];
}

#pragma mark - twitter

- (IBAction)tweetPhoto:(id)sender {
    [self
     postImageToTwitter:[self.state.meta.image image]
     withStatus:[_textView text]];
    _topLabel.text = @"Tweeted";
}

- (void)postImageToTwitter:(UIImage *)image withStatus:(NSString *)status
{
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update_with_media.json"];
            NSDictionary *params = @{@"status" : status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
            [request addMultipartData:imageData
                             withName:@"media[]"
                                 type:@"image/jpeg"
                             filename:@"image.jpg"];
            [request setAccount:[accounts lastObject]];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
}

#pragma mark - tumblr

- (IBAction)tumblrPhoto:(id)sender {
    NSData *picData = [NSData dataWithData:UIImagePNGRepresentation([self.state.meta.image image])];
    void (^block) (void) = ^{
        TumblrUploadr *tu = [[TumblrUploadr alloc]
                             initWithNSDataForPhotos:@[picData]
                             andBlogName:self.state.tumblrBlogName
                             andDelegate:nil
                             andCaption:[_textView text]];
        dispatch_async( dispatch_get_main_queue(), ^{
            [tu
             signAndSendWithTokenKey:[[TMAPIClient sharedInstance] OAuthToken]
             andSecret:[[TMAPIClient sharedInstance] OAuthTokenSecret]];
            _topLabel.text = @"Tumblrd";
        });
    };
    if ([[TMAPIClient sharedInstance] OAuthToken])
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
    else
        [[TMAPIClient sharedInstance] authenticate:@"camtest1" callback:^(NSError *error) {
            if (error)
                NSLog(@"Authentication failed: %@ %@", error, [error description]);
            else
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
        }];
}

- (void) tumblrUploadr:(TumblrUploadr *)tu didFailWithError:(NSError *)error {
    NSLog(@"connection failed with error %@",[error localizedDescription]);
}
- (void) tumblrUploadrDidSucceed:(TumblrUploadr *)tu withResponse:(NSString *)response {
    NSLog(@"connection succeeded with response: %@", response);
}

@end
