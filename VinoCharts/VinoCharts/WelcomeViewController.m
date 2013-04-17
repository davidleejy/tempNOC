//
//  WelcomeViewController.m
//  VinoCharts
//
//  Created by Hendy Chua on 23/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "WelcomeViewController.h"
#import <DropboxSDK/DropboxSDK.h>

#define VERTICAL_PADDING 10
#define BUTTON_HEIGHT 40
#define SYNC_BUTTON_Y 300
#define SYNC_BUTTON_WIDTH 150
#define PROCEED_BUTTON_WIDTH 400

@interface WelcomeViewController ()

//for dropbox signed in verification
@property(nonatomic) NSTimer* timer;

@end

@implementation WelcomeViewController

@synthesize syncButton;
@synthesize proceedButton;

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
	// Do any additional setup after loading the view.
    if([[DBSession sharedSession] isLinked]){
        [self performSegueWithIdentifier:@"transitToAllProjectsView" sender:self];
    }
    
    [self.navigationController setNavigationBarHidden:YES];
    
    // background image
    UIImage *backgroundImage = [UIImage imageNamed:@"chalkboard.png"];
	UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
    
    // introbox image
    UIImage *introBoxImage = [UIImage imageNamed:@"introbox.png"];
	UIImageView *introBox = [[UIImageView alloc] initWithImage:introBoxImage];
    introBox.frame = CGRectMake((self.view.frame.size.height-introBox.frame.size.width)/2,
                                VERTICAL_PADDING,
                                introBox.frame.size.width,
                                introBox.frame.size.height);

    // sync button
    self.syncButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.syncButton.frame = CGRectMake((self.view.frame.size.height-SYNC_BUTTON_WIDTH)/2,
                                       SYNC_BUTTON_Y,
                                       SYNC_BUTTON_WIDTH,
                                       BUTTON_HEIGHT);
    [self.syncButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.syncButton setTitle:@"Sync Account" forState:UIControlStateNormal];
    [self.syncButton addTarget:self action:@selector(syncWithDropBox) forControlEvents:UIControlEventTouchUpInside];
    
    // proceed button
    self.proceedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.proceedButton.frame = CGRectMake((self.view.frame.size.height-PROCEED_BUTTON_WIDTH)/2,
                                       self.syncButton.frame.origin.y+self.syncButton.frame.size.height+(VERTICAL_PADDING*4),
                                       PROCEED_BUTTON_WIDTH,
                                       BUTTON_HEIGHT);
    [self.proceedButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.proceedButton setTitle:@"Tap here to continue without signing in" forState:UIControlStateNormal];
    [self.proceedButton addTarget:self action:@selector(proceedWithoutDropbox) forControlEvents:UIControlEventTouchUpInside];

    
    // add those views to the main view
    [self.view addSubview:background];
    [self.view addSubview:introBox];
    [self.view addSubview:self.syncButton];
    [self.view addSubview:self.proceedButton];
    
}

-(void)syncWithDropBox {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(transitIfSuccesfullySignIn) userInfo:nil repeats:YES];
        
        //incase user cancel to log in to dropbox, then the timer will keep on running, but not sure if 30s enough.
        [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(forceTimerStop) userInfo:nil repeats:NO];
    }
}

-(void)transitIfSuccesfullySignIn{
    NSLog(@"timer");
    if ([[DBSession sharedSession] isLinked]) {
        [self.timer invalidate];
        self.timer = nil;
        [self performSegueWithIdentifier:@"transitToAllProjectsView" sender:self];
    }
}
-(void)forceTimerStop{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)proceedWithoutDropbox {
    //NSLog(@"Proceeding without dropbox...");
    [self performSegueWithIdentifier:@"transitToAllProjectsView" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Override to allow orientations other than the default portrait orientation.
// Rotation for v. 5.1.1
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


@end
