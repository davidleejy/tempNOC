//
//  EditProjectViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol EditProjectViewDelegate

-(void)projectEditedWithTitle:(NSString *)t Details:(NSString *)d;

@end

@interface EditProjectViewController : UIViewController <UITextFieldDelegate> {
    id<EditProjectViewDelegate> delegate;
}

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextView *detailsTextView;
@property (strong, nonatomic) NSString *currentTitle;
@property (strong, nonatomic) NSString *currentDetails;

@property (nonatomic) id<EditProjectViewDelegate> delegate;

- (IBAction)finishEditingProject:(id)sender;
- (IBAction)dismissModal:(id)sender;

@end
