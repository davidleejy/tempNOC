//
//  QuestionModel.h
//  MySurvey
//
//  Created by Roy Huang Purong on 3/27/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionModel.h"

typedef enum {QOpenEnd, QRadioButton, QCheckBox} QuestionType;
@interface QuestionModel : NSObject

@property(nonatomic,readwrite)NSString* title;
@property(nonatomic,readwrite)QuestionType type;
@property(nonatomic,readwrite)NSMutableArray* options;

-(id)init;
-(id)initWithTitle:(NSString*)questingTitle Type:(QuestionType)questionType Options:(NSArray*)questionOptions;
-(void)insertOption:(NSString*)newOption;
-(void)deleteOption:(int)index;
-(NSArray*)getInfo;

@end
