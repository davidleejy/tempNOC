//
//  Diagram.h
//  VinoCharts
//
//  Created by Ang Civics on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiagramModel.h"
#import "NoteM.h"

@interface Diagram : NSObject


@property (nonatomic) double height;
@property (nonatomic) NSString * title;
@property (nonatomic) double width;
@property (nonatomic) NSMutableArray *placedNotes;
@property (nonatomic) NSMutableArray *unplacedNotes;
@property NSString* color;

-(id)initWithCoreData:(DiagramModel*)model;

-(id)init;

@end
