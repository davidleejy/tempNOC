//
//  ViewController.h
//  DelegationProblem
//
//  Created by Roy Huang Purong on 4/9/13.
//  Copyright (c) 2013 nus.3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feedback.h"
#import <QuartzCore/QuartzCore.h>
#import "QASectionView.h"
#import "DiagramListViewController.h"

@class FeedbackViewController;

@protocol FeedbackViewControllerDelegate

@required
-(NSArray*)getListOfDiagrams;
-(void)CreateNoteWithContent:(NSString*)content InDiagramIndex:(NSInteger)index;
-(NSArray*)CreateAndReturnListOfDiagramsDiagramNamed:(NSString*)name;

@end

@interface  FeedbackViewController : UIViewController<QASectionViewDelegate,DiagramListViewControllerDelegate>
{
    NSString* feedbackTitle;
    NSMutableArray* questionArray;
    NSMutableArray* answerArray;
    
    NSMutableArray* listOfDiagramInfo;
    CGFloat currentScrollViewHeight;
    
    UIPopoverController* popoverDiagramList;
    
    int currentDiagramIndex;
}

#pragma properties
@property(nonatomic,readwrite)Feedback* model;
@property(nonatomic,weak)IBOutlet id<FeedbackViewControllerDelegate> delegate;
#pragma end

#pragma IBOutlet links
@property (strong, nonatomic) IBOutlet UIScrollView *myCanvasView;
@property (strong, nonatomic) IBOutlet UILabel *numberOfNotesLeft;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *btnDiagram;


#pragma end

#pragma controller methods
- (IBAction)backToMainInterface:(id)sender;

- (IBAction)showDiagramList:(id)sender;

#pragma end

@end
