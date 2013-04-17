//
//  NoteViewTwo.h
//  VinoCharts
//
//  Created by Lee Jian Yi David on 4/13/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlignmentLineView;

@protocol NoteViewDelegate
//empty
@end

@interface NoteView : UIView

@property(nonatomic,weak,readonly) IBOutlet id <NoteViewDelegate> delegate;

@property (readwrite) UIImageView *foreShadow; //Used in snap to grid to show where note will land after snapping.

@property (readwrite) AlignmentLineView *alignmentLines; //Used to help users arrange their notes.

@property (readwrite) NSString* materialFileName;
@property (readwrite) NSString* textColorGZColorString;//TODO temp fix

-(void)setDelegate:(id<NoteViewDelegate>)aDelegate;

-(id)initWithFrame:(CGRect)f AndText:(NSString*)s;

-(void)setText:(NSString*)myText;
-(NSString*)getText;

-(void)setTextColor:(UIColor*)myColor;
-(void)setTextColorGZColorString:(NSString*)GZColorHexValue;//TODO temp fix
-(UIColor*)getTextColor;
-(NSString*)getTextColorGZColorString;//TODO temp fix

-(void)setFont:(UIFont*)myFont;
-(UIFont*)getFont;

-(void)setMaterialWithPictureFileName:(NSString*)myMaterial;
-(void)setMaterial:(UIColor*)myMaterial;
-(UIColor*)getMaterial;
-(NSString*)getMaterialFileName;

-(CGPoint)getFrameOrigin;
-(void)setFrameOrigin:(CGPoint)myFrameOrigin;

@end
