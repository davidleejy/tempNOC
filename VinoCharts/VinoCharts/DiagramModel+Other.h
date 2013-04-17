//
//  DiagramModel+Other.h
//  VinoCharts
//
//  Created by Ang Civics on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DiagramModel.h"
#import "NoteModel+Other.h"
#import "CoreDataConstant.h"

#import "Diagram.h"
#import "NoteM.h"

@interface DiagramModel (Other)

-(id)copyDiagramData:(DiagramModel*)diagram;

-(void)retrieveDiagramData:(Diagram*)value;

@end
