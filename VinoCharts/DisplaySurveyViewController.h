//
//  DisplaySurveyViewController.h
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DisplayQuestionViewController.h"
#import "Survey.h"
#import "QuestionPopoverViewController.h"


@class DisplaySurveyViewController;

@protocol DisplaySurveyViewControllerDelegate

-(void)createFeedbackWithTitle:(NSString*)title Question:(NSMutableArray*)questionArray Content:(NSMutableArray*)contentArray;

@end

@interface DisplaySurveyViewController : UIViewController<DisplayQuestionViewControllerDelegate,QuestionPopoverViewControllerDelegate>
{
    DisplayQuestionViewController* firstQuestion;
    NSString* feedBackTitle;
    NSMutableArray* ansArray;
    NSMutableArray* QArray;
    
    UIPopoverController* popoverQuestionListController;
    NSMutableArray* questionList;
}

#pragma IBOutlets
@property (strong, nonatomic) IBOutlet UITextField *txtSurveyTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtSurveyDetail;
#pragma end


#pragma Model
@property(nonatomic,readwrite)Survey* model;
#pragma end

#pragma properties
@property (nonatomic,weak)IBOutlet id<DisplaySurveyViewControllerDelegate> delegate;
#pragma end

@end
