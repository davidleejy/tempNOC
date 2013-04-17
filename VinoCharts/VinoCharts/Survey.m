//
//  Survey.m
//  VinoCharts
//
//  Created by Ang Civics on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Survey.h"

@implementation Survey

-(id)init{
    self = [super init];
    if(self){
        self.questions = [[NSMutableArray alloc] init];
    }
    return self;
}
-(id)initWithCoreData:(SurveyModel *)model{
    self = [super init];
    if(self){
        self.title = model.title;
        self.detail = model.detail;
        self.questions = [NSKeyedUnarchiver unarchiveObjectWithData:model.questionArray];
    }
    return self;
}

-(void)deleteQuestionAtIndex:(int)index{

    [self.questions removeObjectAtIndex:index];
}
-(void)updateQuestionWithTitle:(NSString*)QTitle Type:(NSString*)QType Options:(NSArray*)QOptions Index:(int)index
{
    Question* que = [self.questions objectAtIndex:index];
    [que setTitle:QTitle];
    [que setType:QType];
    [que setOptions:QOptions];
}

-(void)addEmptyQuestion
{
    [self.questions addObject:[[Question alloc] init]];
}

-(int)getNumberOfQuestion
{
    return [self.questions count];
}

-(NSArray*)getQuestionInfoWithIndex:(int)index
{
    return [(Question*)[self.questions objectAtIndex:index] getInfo];
}
@end
