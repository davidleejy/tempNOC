//
//  EditProjectViewController.m
//  VinoCharts
//
//  Created by Hendy Chua on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "EditProjectViewController.h"

#define MAX_TITLE_CHARS 50
#define MAX_DETAILS_CHARS 500

@interface EditProjectViewController ()

@end

@implementation EditProjectViewController

@synthesize delegate;
@synthesize currentTitle;
@synthesize currentDetails;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.titleTextField becomeFirstResponder];
    self.detailsTextView.layer.borderWidth = 0.5f;
    self.detailsTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.detailsTextView.layer.cornerRadius = 5.0f;
    
    self.titleTextField.text = self.currentTitle;
    self.detailsTextView.text = self.currentDetails;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleTextField:nil];
    [self setDetailsTextView:nil];
    [super viewDidUnload];
}
- (IBAction)finishEditingProject:(id)sender {
    NSString *newTitle = self.titleTextField.text;
    NSString *newDetails = self.detailsTextView.text;
    
    if (newTitle.length <= 0 || newTitle.length > MAX_TITLE_CHARS) {
        [[[UIAlertView alloc] initWithTitle:@"Project title error"
                                    message:@"Project title cannot be empty and it cannot exceed 50 characters."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
    } else if (newDetails.length > MAX_DETAILS_CHARS) {
        [[[UIAlertView alloc] initWithTitle:@"Project details error"
                                    message:@"Project details cannot exceed 500 characters."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
    } else {
        [self.delegate projectEditedWithTitle:newTitle Details:newDetails];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (IBAction)dismissModal:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.titleTextField) {
        [self.detailsTextView becomeFirstResponder];
    }
    return YES;
}

// Override to allow orientations other than the default portrait orientation.
// Rotation for v. 5.1.1
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

// Rotation 6.0
// Tell the system It should autorotate
- (BOOL) shouldAutorotate {
    return YES;
}

// Tell the system which initial orientation we want to have
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

// Tell the system what we support
-(NSUInteger)supportedInterfaceOrientations

{
    return UIInterfaceOrientationMaskLandscape;
}

@end
