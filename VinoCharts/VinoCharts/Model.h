//
//  Model.h
//  VinoCharts
//
//  Created by Ang Civics on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//
/****************************/
// This is singleton class

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreDataConstant.h"
#import "Project.h"

//CoreDataImplementation of Model
#import "ProjectModel+Other.h"

@protocol ModelDelegate

-(void)projectLoaded;

@end

@interface Model : NSObject

@property UIManagedDocument* database;

@property (readonly) NSMutableArray* allProjects;

@property id<ModelDelegate> delegate;

+(id)sharedModel;

-(Project*)createProjectModel;
-(void)removeProjectAtIndex:(int)index;
-(void)importProjectFromTemporaryDirectoryPersistentStore;
@end
