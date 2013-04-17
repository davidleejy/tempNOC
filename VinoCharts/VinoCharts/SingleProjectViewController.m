//
//  SingleProjectViewController.m
//  VinoCharts
//
//  Created by Hendy Chua on 30/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SingleProjectViewController.h"

@interface SingleProjectViewController ()

@end

@implementation SingleProjectViewController

- (void)setProject:(Project*) p {
    self.thisProject = p;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // background image
    UIImage *backgroundImage = [UIImage imageNamed:@"chalkboard_board.png"];
	UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

// Override to allow orientations other than the default portrait orientation.
// Rotation for v. 5.1.1
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
