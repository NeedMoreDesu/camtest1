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

@property (nonatomic, strong) ACAccountStore *accountStore;

@end

@implementation ViewControllerSave

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
    _accountStore = [[ACAccountStore alloc] init];
    
	// Do any additional setup after loading the view.
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

- (IBAction)savePhoto:(UIButton *)sender {
    [_metaImage
     saveImageWithName:[_text text]
     quality:[_scroll value]];
    _text.text = [self generateFilename];
}

#pragma mark - twitter

- (IBAction)tweetPhoto:(id)sender {
    [self
     postImageToTwitter:[_metaImage image]
     withStatus:[_textView text]];
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
    NSData *picData = [NSData dataWithData:UIImagePNGRepresentation([_metaImage image])];
    void (^block) (void) = ^{
        TumblrUploadr *tu = [[TumblrUploadr alloc]
                             initWithNSDataForPhotos:@[picData]
                             andBlogName:@"testtesttestwww.tumblr.com"
                             andDelegate:nil
                             andCaption:[_textView text]];
        dispatch_async( dispatch_get_main_queue(), ^{
            [tu
             signAndSendWithTokenKey:[[TMAPIClient sharedInstance] OAuthToken]
             andSecret:[[TMAPIClient sharedInstance] OAuthTokenSecret]];
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
