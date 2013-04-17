//
//  NoteModel+Other.m
//  VinoCharts
//
//  Created by Ang Civics on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "NoteModel+Other.h"

@implementation NoteModel (Other)

-(void)saveFont:(UIFont *)font{
    [self setFont:[font fontName]];
    [self setFontSize:[NSNumber numberWithDouble:font.pointSize]];
}

-(UIFont*)getFont{
    return [UIFont fontWithName:self.font size:[self.fontSize doubleValue]];
}

@end
