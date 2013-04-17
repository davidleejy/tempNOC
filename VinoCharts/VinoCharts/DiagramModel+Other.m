//
//  DiagramModel+Other.m
//  VinoCharts
//
//  Created by Ang Civics on 7/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DiagramModel+Other.h"

@implementation DiagramModel (Other)

-(void)retrieveDiagramData:(Diagram *)value{
    self.title = value.title;
    self.width = [NSNumber numberWithDouble: value.width];
    self.height = [NSNumber numberWithDouble:value.height];
    self.color = value.color;
    
    //remove all note from context first
    for(NoteModel* note in [self.placedNotes allObjects]){
        [self.managedObjectContext deleteObject:note];
    }
    for(NoteModel* note in [self.unplacedNotes allObjects]){
        [self.managedObjectContext deleteObject:note];
    }
    
    //add in all new note
    for(NoteM* note in value.placedNotes){
        [self addPlacedNotesObject:[self retrieveNoteData:note]];
    }
    for(NoteM* note in value.unplacedNotes){
        [self addUnplacedNotesObject:[self retrieveNoteData:note]];
    }
}

-(NoteModel*)retrieveNoteData:(NoteM*)note{
    //will create a core data note model
    NoteModel* temp = [NSEntityDescription insertNewObjectForEntityForName:kNote inManagedObjectContext:self.managedObjectContext];
    
    [temp setContent:note.content];
    [temp saveFont:note.font];
    [temp setFontColor:note.fontColor];
    [temp setNoteColor:note.material];
    [temp setX:[NSNumber numberWithDouble:note.x]];
    [temp setY:[NSNumber numberWithDouble:note.y]];
    
    [temp setDiagram:self];
    
    return temp;
}

-(id)copyDiagramData:(DiagramModel *)diagram{
    [self setHeight:diagram.height];
    
    [self setWidth:diagram.width];
    
    [self setTitle:diagram.title];
  
    [self setColor:diagram.color];
    
    for(NoteModel* note in [diagram.placedNotes allObjects]){
        [self addPlacedNotesObject:[self copyNoteData:note]];
    }
    
    for(NoteModel* note in [diagram.unplacedNotes allObjects]){
        [self addUnplacedNotesObject:[self copyNoteData:note]];
    }
    
    return self;
}

-(NoteModel*)copyNoteData:(NoteModel*)note{
    NoteModel* temp = [NSEntityDescription insertNewObjectForEntityForName:kNote inManagedObjectContext:self.managedObjectContext];
    
    [temp setContent:note.content];
    [temp setFont:note.font];
    [temp setFontColor:note.fontColor];
    [temp setNoteColor:note.noteColor];
    [temp setX:note.x];
    [temp setY:note.y];
    
    [temp setDiagram:self];
    
    return temp;
}

@end
