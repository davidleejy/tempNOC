//
//  CreateProjectViewController.m
//  VinoCharts
//
//  Created by Hendy Chua on 24/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CreateProjectViewController.h"

#define MAX_TITLE_CHARS 50
#define MAX_DETAILS_CHARS 500

@interface CreateProjectViewController ()

@end

@implementation CreateProjectViewController

@synthesize delegate;

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
    [self.titleTextField becomeFirstResponder];
    self.detailsTextView.layer.borderWidth = 0.5f;
    self.detailsTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.detailsTextView.layer.cornerRadius = 5.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissModal:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)createNewProject:(id)sender {
    NSString *title = self.titleTextField.text;
    NSString *details = self.detailsTextView.text;
    
    if (title.length <= 0 || title.length > MAX_TITLE_CHARS) {
        [[[UIAlertView alloc] initWithTitle:@"Project title error"
                                    message:@"Project title cannot be empty and it cannot exceed 50 characters."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
    } else if (details.length > MAX_DETAILS_CHARS) {
        [[[UIAlertView alloc] initWithTitle:@"Project details error"
                                    message:@"Project details cannot exceed 500 characters."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
    } else {
        Project *newProject = [[Model sharedModel] createProjectModel];
        newProject.title = title;
        newProject.details = details;
        [self.delegate newProjectCreated:newProject];
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.titleTextField) {
        [self.detailsTextView becomeFirstResponder];
    }
    return YES;
}

- (void)viewDidUnload {
    [self setDetailsTextView:nil];
    [self setTitleTextField:nil];
    [super viewDidUnload];
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
