//
//  Note.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/23/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveChipmunk.h"
@class AlignmentLineView;
#import "NoteView.h"
#import "NoteM.h"

@interface Note : NSObject
<ChipmunkObject,
NoteViewDelegate>

@property (readwrite) NoteView* view;

@property (readwrite) ChipmunkBody *body;
@property (readwrite) NSArray *chipmunkObjects; 

/*State*/
@property (readwrite) BOOL beingPanned;


-(void)updatePos;
//MODIFIES: textView
//EFFECTS: updates textView to follow body. Called at each delta time when using chipmunk physics engine.

-(id)initWithText:(NSString*)t;
//REQUIRES: parameter t has at most 140 characters.
//EFFECTS: ctor




-(void)setTextColor:(UIColor*)myColor;
-(void)setTextColorGZColorString:(NSString*)GZColorHexValue; //temporary TODO fix
-(UIColor*)getTextColor;
-(NSString*)getTextColorGZColorString;//temporary TODO fix

-(void)setBodyTopLeftPoint:(CGPoint)myFrameOrigin;
-(CGPoint)getBodyTopLeftPoint;

-(void)setFont:(UIFont*)myFont;
-(UIFont*)getFont;

-(void)setMaterialWithPictureFileName:(NSString*)myMaterial;
-(void)setMaterial:(UIColor*)myMaterial;
-(UIColor*)getMaterial;
-(NSString*)getMaterialFileName;

-(void)setContent:(NSString*)content;
-(NSString*)content;

-(NoteM*)generateModel;
-(void)loadWithModel:(NoteM*)myModel;

-(NSString*)vitalsToString;

@end
