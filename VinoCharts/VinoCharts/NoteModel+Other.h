//
//  NoteModel+Other.h
//  VinoCharts
//
//  Created by Ang Civics on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "NoteModel.h"
#import "CoreDataConstant.h"

@interface NoteModel (Other)

-(void)saveFont:(UIFont*)font;

-(UIFont*)getFont;

@end
