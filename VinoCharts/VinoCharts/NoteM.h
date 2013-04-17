//
//  NoteM.h
//  VinoCharts
//
//  Created by Ang Civics on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel+Other.h"

@interface NoteM : NSObject

@property (nonatomic) NSString * content;
@property (nonatomic) double x;
@property (nonatomic) double y;
@property (nonatomic) NSString * fontColor;
@property (nonatomic) NSString * material;
@property (nonatomic) UIFont * font;

-(id)initWithCoreData:(NoteModel*)model;
-(id)init;

@end
