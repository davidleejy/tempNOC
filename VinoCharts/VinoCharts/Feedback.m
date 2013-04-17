//
//  Feedback.m
//  VinoCharts
//
//  Created by Ang Civics on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Feedback.h"

@implementation Feedback

-(id)initWithCoreData:(FeedbackModel *)model{
    self = [super init];
    if(self){
        self.title = model.title;
        self.questionArray = [NSKeyedUnarchiver unarchiveObjectWithData:model.questionArray];
        self.answerArray = [NSKeyedUnarchiver unarchiveObjectWithData:model.answerArray];
    }
    return self;
}
-(id)initWithQuestionArray:(NSMutableArray*)qArray
               answerArray:(NSMutableArray*)aArray
                     Title:(NSString*)title
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
