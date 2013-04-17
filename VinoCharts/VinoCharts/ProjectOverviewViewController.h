//
//  ProjectOverviewViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 24/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TileViewController.h"
#import <UIKit/UIKit.h>
#import "Project.h"
#import "Constants.h"

@interface ProjectOverviewViewController : TileViewController

@property (nonatomic, strong) Project *project;

-(id)initWithModel:(Project*)p Delegate:(id)d;

@end
