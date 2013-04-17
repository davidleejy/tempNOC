//
//  QASectionView.m
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "QASectionView.h"
#import <QuartzCore/QuartzCore.h>

@implementation QASectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithQuestion:(NSString*)question Answer:(NSMutableArray*)answer
{
    self = [super init];
    
    if(self)
    {
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [[UIColor grayColor]CGColor];
        self.layer.cornerRadius = 5.0f;
        
        
        questionContent = question;
        answerContent = [NSMutableArray arrayWithArray:answer];
        [self defaultInit];
    }
    return self;
}

-(void)defaultInit
{
    UITextView* sectionTextView = [[UITextView alloc]init];
    sectionTextView.backgroundColor = [UIColor clearColor];
    sectionTextView.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    
    NSMutableString* sectionString = [NSMutableString stringWithString:@"Question: "];
    [sectionString appendString:questionContent];
    [sectionString appendString:@"\n"];
    sectionTextView.editable = NO;
    sectionTextView.delegate = self;
    
    //construct ans
    [sectionString appendString:@"Answer: "];
    for(int i=0; i<answerContent.count; i++)
    {
        [sectionString appendString:[answerContent objectAtIndex:i]];
        [sectionString appendString:@"\n"];
    }
    sectionTextView.text = sectionString;

    [self addSubview:sectionTextView];
    
    CGRect frame = CGRectMake(0, 0, 650.0f, sectionTextView.contentSize.height);
    sectionTextView.frame = frame;
    self.frame = frame;

    UIMenuItem* item1 =[[UIMenuItem alloc]initWithTitle:@"Create Note" action:@selector(CreateNewNote)];
    UIMenuController* controller = [UIMenuController sharedMenuController];
    
    [controller setMenuItems:[NSArray arrayWithObjects:item1, nil]];
}

-(void)CreateNewNote
{
    NSString* myString  = [activedTextView textInRange:activedTextView.selectedTextRange];
    
    if(![myString isEqualToString:@""] && myString != nil)
    {
        if(myString.length > 140)
        {
            [self.delegate ShowMaximumContentSizeWarning];
        }
        else
        {
            [self.delegate CreateNoteWithText:myString];
        }
    }
}

-(void)textViewDidChangeSelection:(UITextView *)textView
{
    [self becomeFirstResponder];
    activedTextView = textView;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(CreateNewNote))
    {
        return YES;
    }
    return NO;
}

-(BOOL)becomeFirstResponder
{
    return YES;
}

@end
