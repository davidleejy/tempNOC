//
//  ProjectDetailsViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SingleProjectViewController.h"
#import "EditProjectViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ProjectDetailsViewController : SingleProjectViewController <EditProjectViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *detailsLabel;

@end
