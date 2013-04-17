//
//  ProjectDetailsViewController.m
//  VinoCharts
//
//  Created by Hendy Chua on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ProjectDetailsViewController.h"

@interface ProjectDetailsViewController ()

@end

@implementation ProjectDetailsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self displayTitleAndDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDetailsLabel:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"transitToEditProject"]) {
        [(EditProjectViewController*)[segue destinationViewController] setCurrentTitle:self.thisProject.title];
        [(EditProjectViewController*)[segue destinationViewController] setCurrentDetails:self.thisProject.details];
        [(EditProjectViewController*)[segue destinationViewController] setDelegate:self];
    }
}

- (void)goIntoEditMode {
    [self performSegueWithIdentifier:@"transitToEditProject" sender:self];
}

-(void)projectEditedWithTitle:(NSString *)t Details:(NSString *)d {
    self.thisProject.title = t;
    self.thisProject.details = d;
    
    [self displayTitleAndDetails];
    [self setNavBar];
}

-(void)displayTitleAndDetails {
    self.detailsLabel.text = self.thisProject.details;
}

-(void)setNavBar {
    NSString *projectTitle = [@"Project: " stringByAppendingString:self.thisProject.title];
    UILabel *navBarTitle = (UILabel *)self.navigationItem.titleView;
    if (!navBarTitle) {
        navBarTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        navBarTitle.backgroundColor = [UIColor clearColor];
        navBarTitle.font = [UIFont boldSystemFontOfSize:20.0];
        navBarTitle.textColor = [UIColor blackColor];
        [navBarTitle setText:projectTitle];
        [navBarTitle sizeToFit];
        self.tabBarController.navigationItem.titleView = navBarTitle;
    }
    
    [self setRightBarButtonToDefaultMode];
}

-(void)setRightBarButtonToDefaultMode {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Edit Details"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(goIntoEditMode)];
    [self.tabBarController.navigationItem setRightBarButtonItem:addButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [self displayTitleAndDetails];
    [self setNavBar];
}

@end
