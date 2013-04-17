//
//  NoteM.m
//  VinoCharts
//
//  Created by Ang Civics on 11/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "NoteM.h"

@implementation NoteM

-(id)initWithCoreData:(NoteModel *)model{
    self = [super init];
    if(self){
        self.content = model.content;
        self.x = [model.x doubleValue];
        self.y = [model.y doubleValue];
        self.font = [model getFont];
        self.fontColor = model.fontColor;
        self.material = model.noteColor;
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self){
        _content = [[NSString alloc]init];
        // _x and _y are primitive data types. Don't init.
        _fontColor = [[NSString alloc]init];
        _material = [[NSString alloc]init];
        _font = [[UIFont alloc]init];
    }
    return self;
}

@end
