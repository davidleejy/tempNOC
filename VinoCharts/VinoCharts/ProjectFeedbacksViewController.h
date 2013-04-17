//
//  ProjectFeedbacksViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SingleProjectViewController.h"
#import "FeedbackOverviewViewController.h"
#import "FeedbackViewController.h"

@interface ProjectFeedbacksViewController : SingleProjectViewController <TileControllerDelegate, FeedbackViewControllerDelegate> {
    Feedback *feedbackSelected;
}

@end
