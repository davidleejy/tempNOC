//
//  FeedbackOverviewViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TileViewController.h"
#import <UIKit/UIKit.h>
#import "Feedback.h"
#import "Constants.h"

@interface FeedbackOverviewViewController : TileViewController

@property (nonatomic, strong) Feedback *feedback;

-(id)initWithModel:(Feedback*)f Delegate:(id)d;

@end
