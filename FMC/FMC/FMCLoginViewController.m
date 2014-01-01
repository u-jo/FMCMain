//
//  FMCLoginViewController.m
//  FMC
//
//  Created by Lee Yu Zhou on 1/1/14.
//  Copyright (c) 2014 Lee Yu Zhou. All rights reserved.
//

#import "FMCLoginViewController.h"
#import "FMCAppDelegate.h"
@interface FMCLoginViewController ()
@property (strong, nonatomic) NSString *accessToken;

@end

@implementation FMCLoginViewController
#define WELCOME_IMAGE @"FMCWelcome.jpg"
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
	FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.delegate = self;
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), (self.view.center.y) + (loginView.frame.size.height * 2));
    [self.view addSubview:loginView];
    UIImage *welcomeImage = [UIImage imageNamed:WELCOME_IMAGE];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:welcomeImage];
    //imageView.contentMode = UIViewContentModeScaleAspectFill;
    CGSize size = CGSizeMake(0.95 * self.view.frame.size.width, 0.2 * self.view.frame.size.height);
    CGRect frame = CGRectMake((self.view.frame.size.width - size.width)/2, loginView.frame.origin.y - 50 - size.height, size.width, size.height);
    imageView.frame = frame;
    [self.view addSubview:imageView];
}


// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    FMCAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UITabBarController *tabBarController = (UITabBarController *)appDelegate.window.rootViewController;
    UIViewController *selectedViewController = [tabBarController selectedViewController];
    UIViewController *viewController;
    if ([selectedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)selectedViewController;
        viewController = [navController viewControllers][0];
    } else {
        viewController = selectedViewController;
    }
    if ([[viewController presentedViewController] isKindOfClass:[FMCLoginViewController class]]) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
        tabBarController.selectedViewController = [tabBarController viewControllers][0];
    }
    
}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
