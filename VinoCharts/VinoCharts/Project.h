//
//  Project.h
//  VinoCharts
//
//  Created by Ang Civics on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectModel.h"
#import "CoreDataConstant.h"
#import "Survey.h"
#import "SurveyModel+Other.h"
#import "Feedback.h"
#import "FeedbackModel+Other.h"
#import "Diagram.h"
#import "DiagramModel+Other.h"

@interface Project : NSObject

@property (nonatomic) NSDate * creationDate;
@property (nonatomic) NSString * details;
@property (nonatomic) NSString * title;
@property (nonatomic,readonly) NSMutableArray *diagrams;
@property (nonatomic,readonly) NSMutableArray *feedbacks;
@property (nonatomic,readonly) NSMutableArray *surveys;

- (id)initWithCoreData:(ProjectModel*)model;
- (void)removeFromCoreData;

- (void)addDiagramsObject:(Diagram *)value;
- (void)updateDiagramAtIndex:(int)index With:(Diagram*)value;
- (void)removeDiagramAtIndex:(int)index;

- (void)addFeedbacksObject:(Feedback *)value;
- (void)updateFeedbackAtIndex:(int)index With:(Feedback*)value;
- (void)removeFeedbackAtIndex:(int)index;

- (void)addSurveysObject:(Survey *)value;
- (void)updateSurveyAtIndex:(int)index With:(Survey*)value;
- (void)removeSurveyAtIndex:(int)index;

@end
