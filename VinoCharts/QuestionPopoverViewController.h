//
//  QuestionPopoverViewController.h
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/10/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuestionPopoverViewController;

@protocol QuestionPopoverViewControllerDelegate

-(void)switchToQuestionWithIndex:(int)index;

@end

@interface QuestionPopoverViewController : UITableViewController
{
    NSMutableArray* questionList;
}

#pragma delegate method
@property(nonatomic,weak)IBOutlet id<QuestionPopoverViewControllerDelegate> delegate;
#pragma end

#pragma methods
-(void)updateQuestionListWith:(NSMutableArray*)newList;
-(id)initWithDiagramList:(NSMutableArray*)list;

#pragma end

@end
