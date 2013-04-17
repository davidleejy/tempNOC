//
//  SingleProjectViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 30/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "Survey.h"
#import "Feedback.h"
#import "Diagram.h"
#import <QuartzCore/QuartzCore.h>
#import "CreateSurveyViewController.h"
#import "SurveyOverviewViewController.h"
#import "Constants.h"
#import "DisplayTilesViewController.h"

@interface SingleProjectViewController : DisplayTilesViewController

- (void)setProject:(Project*)p;

//for core data
@property NSManagedObjectContext* context;

@property (strong, nonatomic) Project *thisProject;

@end
