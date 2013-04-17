//
//  QASectionView.h
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QASectionView;

@protocol QASectionViewDelegate

-(void)CreateNoteWithText:(NSString*)selectedString;
-(void)ShowMaximumContentSizeWarning;

@end

@interface QASectionView : UIView <UITextViewDelegate>
{
    NSString* questionContent;
    NSMutableArray* answerContent;
    
    UITextView* activedTextView;
    
    id observer;
}

@property(nonatomic,weak)IBOutlet id<QASectionViewDelegate> delegate;

-(id)initWithQuestion:(NSString*)question Answer:(NSMutableArray*)answer;

@end
