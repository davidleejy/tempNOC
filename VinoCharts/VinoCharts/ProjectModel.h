//
//  ProjectModel.h
//  VinoCharts
//
//  Created by Ang Civics on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DiagramModel, FeedbackModel, SurveyModel;

@interface ProjectModel : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *diagrams;
@property (nonatomic, retain) NSSet *feedbacks;
@property (nonatomic, retain) NSSet *surveys;
@end

@interface ProjectModel (CoreDataGeneratedAccessors)

- (void)addDiagramsObject:(DiagramModel *)value;
- (void)removeDiagramsObject:(DiagramModel *)value;
- (void)addDiagrams:(NSSet *)values;
- (void)removeDiagrams:(NSSet *)values;

- (void)addFeedbacksObject:(FeedbackModel *)value;
- (void)removeFeedbacksObject:(FeedbackModel *)value;
- (void)addFeedbacks:(NSSet *)values;
- (void)removeFeedbacks:(NSSet *)values;

- (void)addSurveysObject:(SurveyModel *)value;
- (void)removeSurveysObject:(SurveyModel *)value;
- (void)addSurveys:(NSSet *)values;
- (void)removeSurveys:(NSSet *)values;

@end
