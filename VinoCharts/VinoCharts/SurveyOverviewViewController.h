//
//  SurveyOverviewViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TileViewController.h"
#import <UIKit/UIKit.h>
#import "Survey.h"
#import "Constants.h"

@interface SurveyOverviewViewController : TileViewController


@property (nonatomic, strong) Survey *survey;

-(id)initWithModel:(Survey*)s Delegate:(id)d;

@end
