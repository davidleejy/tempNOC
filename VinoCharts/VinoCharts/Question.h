//
//  Question.h
//  VinoCharts
//
//  Created by Ang Civics on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

// this model does not related to core data
#import <Foundation/Foundation.h>
#import "CoreDataConstant.h"

@interface Question : NSObject

@property NSString* title;
@property NSArray* options;
@property NSString* type;

-(NSArray*)getInfo;


@end
