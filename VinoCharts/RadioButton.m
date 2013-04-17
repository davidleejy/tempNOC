//
//  RadioButton.m
//  RadioButton
//
//  Created by Jeruel Fernandes on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RadioButton.h"

@interface RadioButton()
+ (void)registerInstance:(RadioButton*)radioButton;
- (void)defaultInit;
- (void)handleTap;
@end

@implementation RadioButton

@synthesize txt_RadioButton;
@synthesize btn_RadioButton;
@synthesize nID;
@synthesize nGroupID;
@synthesize delegate;

#define kImageHeight    30
#define kImageWidth     30
#define crossButtonWidth 30
#define crossButtonHeight 30

static NSMutableArray *arr_Instances=nil;

- (void)defaultInit
{    
    btn_RadioButton            = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_RadioButton.frame      = CGRectMake(0, 0, kImageWidth, kImageHeight);
    btn_RadioButton.adjustsImageWhenHighlighted = NO;
    [btn_RadioButton setImage:[UIImage imageNamed:@"RadioButton_Deselected.png"] forState:UIControlStateNormal];
    [btn_RadioButton setImage:[UIImage imageNamed:@"RadioButton_Selected.png"] forState:UIControlStateSelected];
    [btn_RadioButton addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_RadioButton];
    
    txt_RadioButton = [[UITextView alloc] initWithFrame:CGRectMake(35, 0, self.bounds.size.width-35, 40)];
    [txt_RadioButton setBackgroundColor:[UIColor whiteColor]];
    [txt_RadioButton setFont:[UIFont systemFontOfSize:14.0]];
    [self addSubview:txt_RadioButton];
    
    [RadioButton registerInstance:self];
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

- (id)initWithFrame:(CGRect)frame AndGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID AndTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultInit];
        [self setGroupID:indexGroup AndID:indexID AndTitle:title];
    }
    return self;
}

-(id)initWithFrameWithoutTitle:(CGRect)frame AndGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultInit];
        [self setGroupIDWithoutTitle:indexGroup AndID:indexID];
    }
    return self;
}

- (void)setGroupIDWithoutTitle:(NSUInteger)indexGroup AndID:(NSUInteger)indexID
{
    nID = indexID;
    nGroupID = indexGroup;
    [txt_RadioButton setEditable:YES];
}

- (void)setGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID AndTitle:(NSString *)title
{
    nID = indexID;
    nGroupID = indexGroup;
    txt_RadioButton.text = title;
    txt_RadioButton.backgroundColor = [UIColor clearColor];
    [txt_RadioButton setEditable:NO];
}

+ (void)registerInstance:(RadioButton*)radioButton
{
    if(!arr_Instances)
    {
        arr_Instances = [[NSMutableArray alloc] init];
    }    
    [arr_Instances addObject:radioButton];
}

+ (void)handleGroup:(RadioButton*)radioButton
{
    if(arr_Instances) 
    {
        for (int i=0; i<[arr_Instances count]; i++) 
        {
            RadioButton *button = [arr_Instances objectAtIndex:i];
            if ((![button isEqual:radioButton]) && (button.nGroupID == radioButton.nGroupID))
            {
                [button.btn_RadioButton setSelected:NO];
            }
        }
    }
}

+ (NSUInteger)selectedIDForGroupID:(NSUInteger)indexGroup
{
    if(arr_Instances)
    {
        for(int i=0; i<[arr_Instances count]; i++)
        {
            RadioButton *button = [arr_Instances objectAtIndex:i];
            if((button.nGroupID == indexGroup) && (button.btn_RadioButton.isSelected))
            {
                return button.nID;
            }
        }
    }
    return 0;
}

- (void)handleTap
{
    if(!btn_RadioButton.selected)
    {
        [btn_RadioButton setSelected:YES];
        [RadioButton handleGroup:self];
        [delegate stateChangedForGroupID:nGroupID WithSelectedButton:nID];
    }
}

//-(void)deleteOption
//{
//    [self.delegate deleteOptionFromCurrentQuestion:self];
//}

-(BOOL)isOptionContentEmpty
{
    if(self.txt_RadioButton.text.length == 0)
    {
        return YES;
    }
    return NO;
}

-(NSString*)getOptionContent
{
    return self.txt_RadioButton.text;
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
        [txt_RadioButton setEditable:YES];
        [btn_RadioButton setEnabled:NO];
        btn_RadioButton.frame = CGRectMake(0, 0, kImageWidth, kImageHeight);
        txt_RadioButton.frame = CGRectMake(35, 0, self.bounds.size.width-35, 40);
        
        [txt_RadioButton setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [txt_RadioButton setEditable:NO];
        [btn_RadioButton setEnabled:YES];
        btn_RadioButton.frame = CGRectMake(0, 0, kImageWidth, kImageHeight);
        txt_RadioButton.frame = CGRectMake(35, 0, self.bounds.size.width-35, 40);
        
        [txt_RadioButton setBackgroundColor:[UIColor clearColor]];
    }
}

@end
