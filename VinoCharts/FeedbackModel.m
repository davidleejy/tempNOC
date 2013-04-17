//
//  FeedbackModel.m
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FeedbackModel.h"

@implementation FeedbackModel

-(id)initWithQuestionArray:(NSMutableArray*)qArray answerArray:(NSMutableArray*)aArray Title:(NSString*)title
{
    self = [super init];
    
    if(self)
    {
        self.questionArray = [[NSMutableArray alloc]initWithArray:qArray];
        self.answerArray = [[NSMutableArray alloc]initWithArray:aArray];
        self.title = title;
    }
    
    return self;
}

@end
