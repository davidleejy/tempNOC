//
//  DisplayQuestionViewController.h
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
#import "CheckBox.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "QuestionPopoverViewController.h"
#import "Survey.h"

@class DisplayQuestionViewController;

@protocol DisplayQuestionViewControllerDelegate

-(int)getNumberOfQuestion;
-(NSArray*)getQuestionInfoFromModelWithIndex:(int)index;
-(void)addAnswerWith:(NSMutableArray*)ans WithIndex:(int)questionIndex;
-(void)finishSurveyWithFeedBackTitle:(NSString*)title;
-(BOOL)isAllAnswered;
-(void)returnToMainInterface;

@end

@interface DisplayQuestionViewController : UIViewController<RadioButtonDelegate,CheckBoxDelegate,UIAlertViewDelegate,QuestionPopoverViewControllerDelegate,UITextViewDelegate>
{
    UITextView* activeView;
    int QuestionIndex;
    
    NSString* questionTitle;
    NSString* questionType;
    NSMutableArray* optionContentArray;
    
    NSMutableArray* answerList;
    
    UIPopoverController* popoverQuestionListController;
    NSMutableArray* questionList;
}


#pragma constructor
-(id)initWithQuestionIndex:(int)index;
#pragma end

#pragma Model
@property(nonatomic,readwrite)Survey* model;
#pragma end

#pragma Properties
@property(nonatomic,readwrite)DisplayQuestionViewController* previousController;
@property(nonatomic,readwrite)DisplayQuestionViewController* nextController;
@property(nonatomic,weak)IBOutlet id<DisplayQuestionViewControllerDelegate> delegate;
#pragma end

#pragma IBOutlets
@property (weak, nonatomic) IBOutlet UILabel *lblQuestionNumber;
@property (weak, nonatomic) IBOutlet UITextView *txtQuestionTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtOpenEndEntry;
@property (weak, nonatomic) IBOutlet UIView *vwCanvas;
#pragma end


#pragma Methods
-(NSMutableArray*)getTheMatchedControllerWithIndex:(int)index controllerArray:(NSMutableArray*)currentControllerArray;
-(void)pushToDestinatedControllerWithIndex:(int)index;
-(void)popToDestinationControllerWithIndex:(int)index;
#pragma end

@end
