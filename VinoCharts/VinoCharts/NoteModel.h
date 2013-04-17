//
//  NoteModel.h
//  VinoCharts
//
//  Created by Ang Civics on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DiagramModel;

@interface NoteModel : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * font;
@property (nonatomic, retain) NSString * fontColor;
@property (nonatomic, retain) NSString * noteColor;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSNumber * fontSize;
@property (nonatomic, retain) DiagramModel *diagram;

@end
