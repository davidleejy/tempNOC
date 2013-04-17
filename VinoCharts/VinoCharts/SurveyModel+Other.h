//
//  SurveyModel+Other.h
//  VinoCharts
//
//  Created by Ang Civics on 29/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SurveyModel.h"
//#import "QuestionModel+Other.h"
#import "CoreDataConstant.h"
#import "Survey.h"

@interface SurveyModel (Other)

-(id)copySurveyData:(SurveyModel *)survey;
-(void)retrieveSurveyData:(Survey*)survey;
@end
