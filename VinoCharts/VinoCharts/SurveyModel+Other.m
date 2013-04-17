//
//  SurveyModel+Other.m
//  VinoCharts
//
//  Created by Ang Civics on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SurveyModel+Other.h"

@implementation SurveyModel (Other)

-(id)copySurveyData:(SurveyModel *)survey{
    [self setDetail:survey.detail];
    [self setTitle:survey.title];
    [self setQuestionArray:survey.questionArray];
    
    return self;
}

-(void)retrieveSurveyData:(Survey *)survey{
    self.detail = survey.detail;
    self.title = survey.title;
    self.questionArray = [NSKeyedArchiver archivedDataWithRootObject:survey.questions];
}
@end
