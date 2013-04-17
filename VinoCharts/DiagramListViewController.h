//
//  DiagramListViewController.h
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiagramListViewController;

@protocol DiagramListViewControllerDelegate

-(void)updateButtonTitleWithIndex:(int)index;

@end

@interface DiagramListViewController : UITableViewController
{
    NSArray* diagramList;
}

@property(nonatomic,weak)IBOutlet id<DiagramListViewControllerDelegate> delegate;


-(id)initWithDiagramList:(NSArray*)list;

@end
