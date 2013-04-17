//
//  Feedback.h
//  VinoCharts
//
//  Created by Ang Civics on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedbackModel.h"

@interface Feedback : NSObject

@property(nonatomic,readwrite)NSString* title;
@property(nonatomic,readwrite)NSMutableArray* questionArray;
@property(nonatomic,readwrite)NSMutableArray* answerArray;

-(id)initWithCoreData:(FeedbackModel*)model;
-(id)initWithQuestionArray:(NSMutableArray*)qArray answerArray:(NSMutableArray*)aArray Title:(NSString*)title;

@end
