//
//  DiagramModel.h
//  VinoCharts
//
//  Created by Ang Civics on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NoteModel, ProjectModel;

@interface DiagramModel : NSManagedObject

@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSSet *placedNotes;
@property (nonatomic, retain) ProjectModel *project;
@property (nonatomic, retain) NSSet *unplacedNotes;
@end

@interface DiagramModel (CoreDataGeneratedAccessors)

- (void)addPlacedNotesObject:(NoteModel *)value;
- (void)removePlacedNotesObject:(NoteModel *)value;
- (void)addPlacedNotes:(NSSet *)values;
- (void)removePlacedNotes:(NSSet *)values;

- (void)addUnplacedNotesObject:(NoteModel *)value;
- (void)removeUnplacedNotesObject:(NoteModel *)value;
- (void)addUnplacedNotes:(NSSet *)values;
- (void)removeUnplacedNotes:(NSSet *)values;

@end
