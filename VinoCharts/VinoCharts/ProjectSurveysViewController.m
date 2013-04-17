//
//  ProjectSurveysViewController.m
//  VinoCharts
//
//  Created by Hendy Chua on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ProjectSurveysViewController.h"

@interface ProjectSurveysViewController ()

@end

@implementation ProjectSurveysViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadModelsArrayAndRepresentationArray];
    [self fillUpTiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"transitToCreateSurvey"]) {
        CreateSurveyViewController* createSurveyVC = (CreateSurveyViewController*)[[segue destinationViewController] topViewController];
        createSurveyVC.delegate = self;
        
    } else if ([[segue identifier] isEqualToString:@"transitToViewSurvey"]) {
        DisplaySurveyViewController* currentDisplaySurvey = (DisplaySurveyViewController*)[[segue destinationViewController] topViewController];
        currentDisplaySurvey.delegate = self;
        currentDisplaySurvey.model = surveySelected;
        
    } else if ([[segue identifier] isEqualToString:@"transitToEditSurvey"]) {
        [[segue destinationViewController] setDelegate:self];
        EditSurveyViewController* currentEditSurvey = (EditSurveyViewController*)[[segue destinationViewController] topViewController];
        currentEditSurvey.delegate = self;
        currentEditSurvey.model = surveySelected;
    }
}

- (void)showCreateSurveyForm {
    [self performSegueWithIdentifier:@"transitToCreateSurvey" sender:self];
}

-(void)newSurveyCreated:(Survey*)s {
    [self.thisProject addSurveysObject:s];
    [self reloadModelsArrayAndRepresentationArray];
    [self fillUpTiles];
}

-(void)setNavBar {
    NSString *navBarTitleString = @"Surveys in Project";
    UILabel *navBarTitle = (UILabel *)self.navigationItem.titleView;
    if (!navBarTitle) {
        navBarTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        navBarTitle.backgroundColor = [UIColor clearColor];
        navBarTitle.font = [UIFont boldSystemFontOfSize:20.0];
        navBarTitle.textColor = [UIColor blackColor];
        [navBarTitle setText:navBarTitleString];
        [navBarTitle sizeToFit];
        self.tabBarController.navigationItem.titleView = navBarTitle;
    }
    
    [self setRightBarButtonToDefaultMode];
}

- (void)viewDidAppear:(BOOL)animated {
    [self setNavBar];
}

// overriding superclass displaytilesviewcontroller methods

-(void)reloadModelsArrayAndRepresentationArray {
    NSArray *projectSurveysArray = self.thisProject.surveys;
    self.modelsArray = [projectSurveysArray copy];
    
    if (self.modelsRepresentationArray != nil) {
        for (SurveyOverviewViewController* s in self.modelsRepresentationArray) {
            [s.tileImageView removeFromSuperview];
        }
    }
    self.modelsRepresentationArray = nil;
    self.modelsRepresentationArray = [NSMutableArray array];
    
    // creating the project overviews
    for (int i=0; i<[self.modelsArray count]; i++) {
        Survey *surv = (Survey *)[self.modelsArray objectAtIndex:i];
        
        SurveyOverviewViewController *s = [[SurveyOverviewViewController alloc] initWithModel:surv Delegate:self];
        [self.modelsRepresentationArray addObject:s];
    }
}

-(void)setRightBarButtonToDeletingMode {
    UIBarButtonItem *doneDeleting = [[UIBarButtonItem alloc] initWithTitle:@"Done Deleting"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(finishDeletingMode)];
    [doneDeleting setTintColor:[UIColor redColor]];
    [self.tabBarController.navigationItem setRightBarButtonItem:doneDeleting];
}

- (void)setRightBarButtonToDefaultMode {
    UIBarButtonItem *createButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Create Survey +"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(showCreateSurveyForm)];
    [self.tabBarController.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:createButton, nil]];
}


-(void)finishDeletingMode {
    [super finishDeletingMode];
    [self setRightBarButtonToDefaultMode];
}

// tileviewcontrollerdelegate method

-(void)tileSelected:(id)model {
    surveySelected = model;
    [self performSegueWithIdentifier:@"transitToViewSurvey" sender:self];
}

-(void)longPressActivated {
    [self setRightBarButtonToDeletingMode];
    [self showDeleteButtonOnTiles];
}

//need to change to index
-(void)deleteTile:(id)model {    
    // delete the actual survey object
    NSArray* surveys = self.thisProject.surveys;
    for(int i=0; i < [surveys count];i++){
        if([surveys objectAtIndex:i]==model){
            [self.thisProject removeSurveyAtIndex:i];
            break;
        }
    }
    
    [self reloadModelsArrayAndRepresentationArray];
    [self fillUpTiles];
    [self showDeleteButtonOnTiles];
}

-(void)tileToBeEdited:(id)model {
    surveySelected = model;
    [self performSegueWithIdentifier:@"transitToEditSurvey" sender:self];
}

#pragma delegation methods
-(void)saveSurvey:(Survey*)survey
{
    [self.thisProject addSurveysObject:survey];
    [self reloadModelsArrayAndRepresentationArray];
    [self fillUpTiles];
}

-(void)updateSurvey:(Survey*)survey
{
    NSArray* surveys = self.thisProject.surveys;
    
    for(int i=0 ; i<surveys.count ; i++){
        if([surveys objectAtIndex:i] == survey){
            [self.thisProject updateSurveyAtIndex:i With:survey];
        }
    }
    [self reloadModelsArrayAndRepresentationArray];
    [self fillUpTiles];
}

-(void)createFeedbackWithTitle:(NSString*)title Question:(NSMutableArray*)questionArray Content:(NSMutableArray*)contentArray
{
    [self.thisProject addFeedbacksObject:[[Feedback alloc]initWithQuestionArray:questionArray answerArray:contentArray Title:title]];
    [self.tabBarController setSelectedIndex:2]; // 2 is the index of feedback view controller in the tab bar controller
}

#pragma end

@end
