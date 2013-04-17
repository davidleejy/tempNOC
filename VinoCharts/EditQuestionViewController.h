//
//  EditQuestionViewController.h
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <QuartzCore/QuartzCore.h>
#import "QuestionPopoverViewController.h"

@class EditQuestionViewController;

@protocol EditQuestionViewControllerDelegate

-(void)createEmptyQuestionModel;
-(void)removeCurrentQuestionModel:(int)index;
-(void)updateQuestionToSurveyWithTitle:(NSString*)title Type:(NSString*)type Options:(NSMutableArray*)optionList Index:(int)index;
-(void)finishEditingSuvey;
-(int)getNumberOfQuestion;
-(void)changeFirstQuestion:(EditQuestionViewController*)sender;
-(NSArray*)getQuestionInfoFromModelWithIndex:(int)index;

@end


@interface EditQuestionViewController : UIViewController<UITextViewDelegate,QuestionPopoverViewControllerDelegate>
{
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
@property(nonatomic,readwrite)EditQuestionViewController* previousController;
@property(nonatomic,readwrite)EditQuestionViewController* nextController;
@property(nonatomic,weak)IBOutlet id<EditQuestionViewControllerDelegate> delegate;
#pragma end

#pragma IBBullet
@property (strong, nonatomic) IBOutlet UIScrollView *myCanvasView;
@property (strong, nonatomic) IBOutlet UITextView *titleView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *typePicker;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UIView *optionArea;
#pragma end

#pragma Actions
- (IBAction)typePickerSelected:(id)sender;
#pragma end

#pragma Methods
-(void)saveCurrentQuestionAndSubsequentQuestions;
-(BOOL)isMandotaryFieldsOfAllQuestionsFilled;
-(NSMutableArray*)getTheMatchedControllerWithIndex:(int)index controllerArray:(NSMutableArray*)currentControllerArray;
-(void)pushToDestinatedControllerWithIndex:(int)index;
-(void)popToDestinationControllerWithIndex:(int)index;
#pragma end

@end
