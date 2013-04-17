//
//  Diagram.m
//  VinoCharts
//
//  Created by Ang Civics on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Diagram.h"

@implementation Diagram

-(id)initWithCoreData:(DiagramModel *)model{
    self = [super init];
    if(self){
        self.title = model.title;
        self.width = [model.width doubleValue];
        self.height = [model.height doubleValue];
        self.color = model.color;
        
        self.unplacedNotes = [[NSMutableArray alloc]init];
        for(NoteModel* note in [model.unplacedNotes allObjects]){
            [self.unplacedNotes addObject:[[NoteM alloc] initWithCoreData:note]];
        }
        
        self.placedNotes = [[NSMutableArray alloc]init];
        for(NoteModel* note in [model.placedNotes allObjects]){
            [self.placedNotes addObject:[[NoteM alloc] initWithCoreData:note]];
        }
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self){
        //height and weight are primitive data types.
        _title = [[NSString alloc]init];
        _placedNotes = [[NSMutableArray alloc]init];
        _unplacedNotes = [[NSMutableArray alloc]init];
        _color = [[NSString alloc]init];
    }
    return self;
}

@end
