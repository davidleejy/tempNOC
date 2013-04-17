//
//  ProjectSurveysViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SingleProjectViewController.h"
#import "SurveyOverviewViewController.h"
#import "CreateSurveyViewController.h"
#import "EditSurveyViewController.h"
#import "DisplaySurveyViewController.h"
#import "FeedbackViewController.h"
#import "Feedback.h"

@interface ProjectSurveysViewController : SingleProjectViewController <TileControllerDelegate,createSurveyViewControllerDelegation, DisplaySurveyViewControllerDelegate, editSurveyViewControllerDelegation> {
    Survey *surveySelected;
}

@end
