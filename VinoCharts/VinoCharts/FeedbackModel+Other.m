//
//  FeedbackModel+Other.m
//  VinoCharts
//
//  Created by Ang Civics on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FeedbackModel+Other.h"

@implementation FeedbackModel (Other)

-(id)copyFeedbackData:(FeedbackModel *)feedback{
    [self setTitle:feedback.title];
    [self setAnswerArray:feedback.answerArray];
    [self setQuestionArray:feedback.questionArray];
    
    return self;
}

-(void)retrieveFeedbackData:(Feedback*)feedback{
    [self setTitle:feedback.title];
    [self setAnswerArray:[NSKeyedArchiver archivedDataWithRootObject:feedback.answerArray]];
    [self setQuestionArray:[NSKeyedArchiver archivedDataWithRootObject:feedback.questionArray]];
}

@end
