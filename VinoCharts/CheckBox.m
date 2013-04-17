//
//  CheckBox.m
//  Checkbox
//
//  Created by Jeruel Fernandes on 14/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckBox.h"

@interface CheckBox()
- (void)defaultInit;
- (void)handleTap;
@end

@implementation CheckBox

@synthesize nID;
@synthesize btn_CheckBox;
@synthesize txt_CheckBox;
@synthesize delegate;

#define kImageHeight    30
#define kImageWidth     30
#define deleteButtonHeight 30
#define deleteButtonWidth 30

- (void)defaultInit
{
    btn_CheckBox            = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_CheckBox.frame      = CGRectMake(0, 0, kImageWidth, kImageHeight);
    btn_CheckBox.adjustsImageWhenHighlighted = NO;
    [btn_CheckBox setImage:[UIImage imageNamed:@"CheckBox_Deselected.png"] forState:UIControlStateNormal];
    [btn_CheckBox setImage:[UIImage imageNamed:@"CheckBox_Selected.png"] forState:UIControlStateSelected];
    [btn_CheckBox addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_CheckBox];
    
    txt_CheckBox            = [[UITextView alloc] initWithFrame:CGRectMake(35, 0, self.bounds.size.width-35, 40)];
    txt_CheckBox.backgroundColor    = [UIColor whiteColor];
    [txt_CheckBox setFont:[UIFont systemFontOfSize:14.0]];
    [self addSubview:txt_CheckBox];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self defaultInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndID:(NSUInteger)index AndSelected:(BOOL)state AndTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultInit];
        [self setID:index AndSelected:state AndTitle:title];
    }
    return self;
}

- (void)setID:(NSUInteger)index AndSelected:(BOOL)state AndTitle:(NSString *)title
{
    nID = index;
    [btn_CheckBox setSelected:state];
    txt_CheckBox.text = title;
}

- (void)setIDWithoutTitle:(NSUInteger)index AndSelected:(BOOL)state
{
    nID = index;
    [btn_CheckBox setSelected:state];
}

- (void)handleTap
{
    if(btn_CheckBox.selected)
    {
        [btn_CheckBox setSelected:NO];
    }
    else
    {
        [btn_CheckBox setSelected:YES];
    }
    
    [delegate stateChangedForID:nID WithCurrentState:btn_CheckBox.selected];
}

- (BOOL)currentState
{
    return btn_CheckBox.selected;
}

-(BOOL)isOptionContentEmpty
{
    if(self.txt_CheckBox.text.length == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(NSString*)getOptionContent
{
    return self.txt_CheckBox.text;
}

-(NSUInteger)getOptionID
{
    return nID;
}

-(void)setOptionID:(NSUInteger)newID
{
    nID = newID;
}

-(void)setEditable:(BOOL)flag
{
    if(flag)
    {
        [txt_CheckBox setEditable:YES];
        [btn_CheckBox setEnabled:NO];
        btn_CheckBox.frame = CGRectMake(0, 0, kImageWidth, kImageHeight);
        txt_CheckBox.frame = CGRectMake(35, 0, self.bounds.size.width-35, 40);
        
        [txt_CheckBox setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [txt_CheckBox setEditable:NO];
        [btn_CheckBox setEnabled:YES];
        btn_CheckBox.frame = CGRectMake(0, 0, kImageWidth, kImageHeight);
        txt_CheckBox.frame = CGRectMake(35, 0, self.bounds.size.width-35, 40);
        
        [txt_CheckBox setBackgroundColor:[UIColor clearColor]];
    }
}

@end
