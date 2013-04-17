//
//  CreateQuestionViewController.h
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "QuestionPopoverViewController.h"

@class CreateQuestionViewController;

@protocol CreateQuestionViewControllerDelegate

-(void)createEmptyQuestionModel;
-(void)removeCurrentQuestionModel:(int)index;
-(void)updateQuestionToSurveyWithTitle:(NSString*)title Type:(NSString*)type Options:(NSMutableArray*)optionList Index:(int)index;
-(void)finishEditingSuvey;
-(int)getNumberOfQuestion;
-(void)changeFirstQuestion:(CreateQuestionViewController*)sender;
-(NSArray*)getQuestionInfoFromModelWithIndex:(int)index;

@end

@interface CreateQuestionViewController : UIViewController<UITextViewDelegate,QuestionPopoverViewControllerDelegate>
{
    NSArray* typeList;
    UITextView* activeView;
    int QuestionIndex;
    
    NSString* questionTitle;
    NSString* questionType;
    NSMutableArray* optionContentArray;
    
    UIPopoverController* popoverQuestionListController;
    NSMutableArray* questionList;
}

#pragma Constructors
-(id)initWithQuestionIndex:(int)index;
#pragma end

#pragma Properties
@property(nonatomic,readwrite)CreateQuestionViewController* previousController;
@property(nonatomic,readwrite)CreateQuestionViewController* nextController;
@property(nonatomic,weak)IBOutlet id<CreateQuestionViewControllerDelegate> delegate;
#pragma end

#pragma IBBullet
@property (strong, nonatomic) IBOutlet UIScrollView *myCanvasView;
@property (strong, nonatomic) IBOutlet UITextView *titleView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typePicker;
@property (strong, nonatomic) IBOutlet UIView *optionArea;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
#pragma end

#pragma Actions
- (IBAction)typePickerSelected:(id)sender;
#pragma end

#pragma Methods
-(void)saveCurrentQuestionAndSubsequentQuestions;
-(BOOL)isMandotaryFieldsOfAllQuestionsFilled;
-(NSMutableArray*)getTheMatchedControllerWithIndex:(int)index controllerArray:(NSMutableArray*)currentControllerArray;
-(void)pushToDestinationControllerWithIndex:(int)index;
-(void)popToDestinationControllerWithIndex:(int)index;
#pragma end

@end
