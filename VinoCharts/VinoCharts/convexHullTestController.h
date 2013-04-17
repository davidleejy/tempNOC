//
//  convexHullTestController.h
//  VinoCharts
//
//  Created by Lee Jian Yi David on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface convexHullTestController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@property (readwrite) UIImageView* canvas;

@property (readwrite) NSMutableArray* stuffOnPaper; //analogous to notes
@property (readwrite) NSMutableArray* lineSegmentsOfConvexHull;
@property (readwrite) NSMutableArray* notesBeingMassSelected;

@property (readwrite) NSMutableArray* massSelectOverlayViews;

- (IBAction)endMassSelectionOfNotes:(id)sender;
- (IBAction)reset:(id)sender;

@end
