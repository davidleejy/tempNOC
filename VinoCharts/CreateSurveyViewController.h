//
//  CreateSurveyViewController.h
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateQuestionViewController.h"
#import "Survey.h"
#import "QuestionPopoverViewController.h"

@class CreateSurveyViewController;

@protocol createSurveyViewControllerDelegation

-(void)saveSurvey:(Survey*)survey;

@end

@interface CreateSurveyViewController : UIViewController<CreateQuestionViewControllerDelegate,UITextViewDelegate,QuestionPopoverViewControllerDelegate, UITextFieldDelegate>
{
    CreateQuestionViewController* firstQuestion;
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
@property (nonatomic,weak)IBOutlet id<createSurveyViewControllerDelegation> delegate;
#pragma end

@end
