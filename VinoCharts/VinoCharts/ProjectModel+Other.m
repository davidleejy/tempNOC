//
//  ProjectModel+Other.m
//  VinoCharts
//
//  Created by Ang Civics on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ProjectModel+Other.h"

@implementation ProjectModel (Other)

-(id)copyProjectData:(ProjectModel *)pro{
    [self setTitle:pro.title];
    
    [self setDetails:pro.details];
    
    [self setCreationDate:pro.creationDate];
    
    if(pro.diagrams){
        for(DiagramModel* diagram in [pro.diagrams allObjects]){
            DiagramModel* temp = [NSEntityDescription insertNewObjectForEntityForName:kDiagram inManagedObjectContext:self.managedObjectContext];
            [temp setProject:self];
            [self addDiagramsObject:[temp copyDiagramData:diagram]];
        }
    }
    
    if(pro.feedbacks){
        for(FeedbackModel* feedback in [pro.feedbacks allObjects]){
            FeedbackModel* temp = [NSEntityDescription insertNewObjectForEntityForName:kFeedback inManagedObjectContext:self.managedObjectContext];
            [temp setProject:self];
            [self addFeedbacksObject:[temp copyFeedbackData:temp]];
        }
    }
    
    if(pro.surveys){
        for(SurveyModel* survey in [pro.surveys allObjects]){
            SurveyModel* temp = [NSEntityDescription insertNewObjectForEntityForName:kSurvey inManagedObjectContext:self.managedObjectContext];
            [temp setProjectModel:self];
            [self addSurveysObject:[temp copySurveyData:survey]];
        }
    }
    
    return self;
}

@end
