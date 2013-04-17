//
//  FeedbackModel+Other.h
//  VinoCharts
//
//  Created by Ang Civics on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FeedbackModel.h"
#import "Feedback.h"
#import "CoreDataConstant.h"

@interface FeedbackModel (Other)

-(id)copyFeedbackData:(FeedbackModel *)feedback;
-(void)retrieveFeedbackData:(Feedback*)feedback;

@end
