//
//  SurveyModel.h
//  VinoCharts
//
//  Created by Ang Civics on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ProjectModel;

@interface SurveyModel : NSManagedObject

@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSData * questionArray;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) ProjectModel *projectModel;

@end
