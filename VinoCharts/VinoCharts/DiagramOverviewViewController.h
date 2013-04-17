//
//  DiagramOverviewViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TileViewController.h"
#import <UIKit/UIKit.h>
#import "Diagram.h"
#import "Constants.h"

@interface DiagramOverviewViewController : TileViewController

@property (nonatomic, strong) Diagram *diagram;

-(id)initWithModel:(Diagram*)diag Delegate:(id)d;

@end
