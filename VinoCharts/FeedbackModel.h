//
//  FeedbackModel.h
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedbackModel : NSObject
{
    
}

@property(nonatomic,readwrite)NSString* title;
@property(nonatomic,readwrite)NSMutableArray* questionArray;
@property(nonatomic,readwrite)NSMutableArray* answerArray;


-(id)initWithQuestionArray:(NSMutableArray*)qArray answerArray:(NSMutableArray*)aArray Title:(NSString*)title;

@end
