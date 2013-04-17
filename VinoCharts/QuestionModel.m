//
//  QuestionModel.m
//  MySurvey
//
//  Created by Roy Huang Purong on 3/27/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.options = [[NSMutableArray alloc]init];
    }
    return self;
}

-(id)initWithTitle:(NSString*)questingTitle Type:(QuestionType)questionType Options:(NSArray*)questionOptions
{
    self = [super init];
    
    if(self != nil)
    {
        self.title = questingTitle;
        self.type = questionType;
        self.options = [[NSMutableArray alloc]initWithArray:questionOptions];
    }
    
    return self;
}

-(void)insertOption:(NSString*)newOption
{
    [self.options addObject:newOption];
}

-(void)deleteOption:(int)index
{
    [self.options removeObjectAtIndex:index];
}

-(void)updateOptions:(NSMutableArray*)newOptions
{
    [self.options removeAllObjects];
    
    for(int i=0; i<newOptions.count; i++)
    {
        [self.options addObject:[newOptions objectAtIndex:i]];
    }
}

-(NSArray*)getInfo
{
    NSString* currentType;
    
    switch(self.type)
    {
        case QOpenEnd:
            currentType = @"Open End";
            break;
        case QRadioButton:
            currentType = @"Radio Button";
            break;
        case QCheckBox:
            currentType = @"Check Box";
            break;
            
            default:
            break;
    }
    
    return [[NSArray alloc]initWithObjects:self.title,currentType,self.options, nil];
}

@end
