//
//  RadioButton.h
//  RadioButton
//
//  Created by Jeruel Fernandes on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RadioButton;
@protocol RadioButtonDelegate <NSObject>
- (void)stateChangedForGroupID:(NSUInteger)indexGroup WithSelectedButton:(NSUInteger)indexID;
@end

@interface RadioButton : UIView
{
    NSUInteger  nID;
    NSUInteger  nGroupID;
    UIButton    *btn_RadioButton;
    UITextView     *txt_RadioButton;
    
    id <RadioButtonDelegate> delegate;
}

@property (readwrite, nonatomic) NSUInteger nID;
@property (readwrite, nonatomic) NSUInteger nGroupID;
@property (strong, nonatomic) UIButton *btn_RadioButton;
@property (strong, nonatomic) UITextView *txt_RadioButton;
@property (strong, nonatomic) id <RadioButtonDelegate> delegate;

- (id)initWithFrame:(CGRect)frame AndGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID AndTitle:(NSString*)title;
-(id)initWithFrameWithoutTitle:(CGRect)frame AndGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID;

- (void)setGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID AndTitle:(NSString*)title;
- (void)setGroupIDWithoutTitle:(NSUInteger)indexGroup AndID:(NSUInteger)indexID;

+ (NSUInteger)selectedIDForGroupID:(NSUInteger)indexGroup;

-(BOOL)isOptionContentEmpty;
-(NSString*)getOptionContent;
-(NSUInteger)getOptionID;
-(void)setOptionID:(NSUInteger)newID;
-(void)setEditable:(BOOL)flag;

@end
