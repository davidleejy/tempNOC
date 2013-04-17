//
//  Project.m
//  VinoCharts
//
//  Created by Ang Civics on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Project.h"

@interface Project ()

@property ProjectModel* coreDataModel;

@property (nonatomic,readwrite) NSMutableArray *diagrams;
@property (nonatomic,readwrite) NSMutableArray *feedbacks;
@property (nonatomic,readwrite) NSMutableArray *surveys;

@end

@implementation Project

-(void)removeFromCoreData{
    [self.coreDataModel.managedObjectContext deleteObject:self.coreDataModel];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.coreDataModel.title = title;
}

-(void)setCreationDate:(NSDate *)creationDate{
    _creationDate = creationDate;
    self.coreDataModel.creationDate = creationDate;
}

-(void)setDetails:(NSString *)details{
    _details = details;
    self.coreDataModel.details = details;
}

-(id)initWithCoreData:(ProjectModel *)model{
    self = [super init];
    if(self){
        self.title = model.title;
        self.details = model.details;
        self.creationDate = model.creationDate;
        
        self.diagrams = [[NSMutableArray alloc] init];
        for(DiagramModel* diagram in [model.diagrams allObjects]){
            [self.diagrams addObject:[[Diagram alloc] initWithCoreData:diagram]];
        }
        self.feedbacks = [[NSMutableArray alloc] init];
        for (FeedbackModel* feedback in [model.feedbacks allObjects]){
            [self.feedbacks addObject:[[Feedback alloc]initWithCoreData:feedback]];
        }
        self.surveys = [[NSMutableArray alloc] init];
        for (SurveyModel* survey in [model.surveys allObjects]){
            [self.surveys addObject:[[Survey alloc]initWithCoreData:survey]];
        }
        
        self.coreDataModel = model;
    }
    return self;
}

- (void)addDiagramsObject:(Diagram *)value{
    DiagramModel* model = [NSEntityDescription insertNewObjectForEntityForName:kDiagram inManagedObjectContext:self.coreDataModel.managedObjectContext];
    model.project = self.coreDataModel;
    [model retrieveDiagramData:value];
    [self.diagrams addObject:value];
}
-(void)updateDiagramAtIndex:(int)index With:(Diagram *)value{
    DiagramModel* model = [[self.coreDataModel.diagrams allObjects]objectAtIndex:index];
    [model retrieveDiagramData:value];
    [self.diagrams replaceObjectAtIndex:index withObject:value];
}
-(void)removeDiagramAtIndex:(int)index{
    DiagramModel* model = [[self.coreDataModel.diagrams allObjects]objectAtIndex:index];
    [self.coreDataModel.managedObjectContext deleteObject:model];
    [self.diagrams removeObjectAtIndex:index];
}

- (void)addFeedbacksObject:(Feedback *)value{
    FeedbackModel* model = [NSEntityDescription insertNewObjectForEntityForName:kFeedback inManagedObjectContext:self.coreDataModel.managedObjectContext];
    model.project = self.coreDataModel;
    [model retrieveFeedbackData:value];
    [self.feedbacks addObject:value];
}
-(void)updateFeedbackAtIndex:(int)index With:(Feedback *)value{
    FeedbackModel* feedback = [[self.coreDataModel.feedbacks allObjects]objectAtIndex:index];
    [feedback retrieveFeedbackData:value];
    [self.feedbacks replaceObjectAtIndex:index withObject:value];
}
-(void)removeFeedbackAtIndex:(int)index{
    FeedbackModel* feedback = [[self.coreDataModel.feedbacks allObjects]objectAtIndex:index];
    [self.coreDataModel.managedObjectContext deleteObject:feedback];
    [self.feedbacks removeObjectAtIndex:index];
}

- (void)addSurveysObject:(Survey *)value{
    SurveyModel* model = [NSEntityDescription insertNewObjectForEntityForName:kSurvey inManagedObjectContext:self.coreDataModel.managedObjectContext];
    model.projectModel = self.coreDataModel;
    [model retrieveSurveyData:value];
    [self.surveys addObject:value];
    NSLog(@"%@", self.surveys);
}
-(void)updateSurveyAtIndex:(int)index With:(Survey *)value{
    SurveyModel* survey = [[self.coreDataModel.surveys allObjects] objectAtIndex:index];
    [survey retrieveSurveyData:value];
    [self.surveys replaceObjectAtIndex:index withObject:value];
}
-(void)removeSurveyAtIndex:(int)index{
    SurveyModel* survey = [[self.coreDataModel.surveys allObjects] objectAtIndex:index];
    [self.coreDataModel.managedObjectContext deleteObject:survey];
    [self.surveys removeObjectAtIndex:index];
}


@end
