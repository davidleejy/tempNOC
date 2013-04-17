//
//  Survey.h
//  VinoCharts
//
//  Created by Ang Civics on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SurveyModel.h"
#import "Question.h"

@interface Survey : NSObject

@property (nonatomic) NSString * detail;
@property (nonatomic) NSString * title;
@property (nonatomic) NSMutableArray *questions;

-(id)initWithCoreData:(SurveyModel*)model;
-(id)init;

-(void)updateQuestionWithTitle:(NSString*)QTitle Type:(NSString*)QType Options:(NSArray*)QOptions Index:(int)index;
-(void)addEmptyQuestion;
-(int)getNumberOfQuestion;
-(void)deleteQuestionAtIndex:(int)index;

-(NSArray*)getQuestionInfoWithIndex:(int)index;

@end
