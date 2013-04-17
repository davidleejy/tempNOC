//
//  EditSurveyViewController.h
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Survey.h"
#import "EditQuestionViewController.h"
#import "QuestionPopoverViewController.h"

@class EditSurveyViewController;

@protocol editSurveyViewControllerDelegation

-(void)updateSurvey:(Survey*)survey;

@end

@interface EditSurveyViewController : UIViewController<UITextViewDelegate,EditQuestionViewControllerDelegate,QuestionPopoverViewControllerDelegate, UITextFieldDelegate>
{
    EditQuestionViewController* firstQuestion;
    UIPopoverController* popoverQuestionListController;
    NSMutableArray* questionList;
}

#pragma IBOutlet
@property (strong, nonatomic) IBOutlet UITextField *txtTitleView;
@property (strong, nonatomic) IBOutlet UITextView *txtDetailView;
@property (strong, nonatomic) IBOutlet UIView *myBackgroundView;
#pragma end

#pragma properties
@property (nonatomic,readwrite) Survey* model;
@property (nonatomic,weak)IBOutlet id<editSurveyViewControllerDelegation> delegate;
#pragma end

@end
