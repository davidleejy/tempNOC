//
//  CanvasSettingController.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorViewController.h"

@protocol CanvasSettingControllerDelegate

- (void) CanvasSettingControllerDelegateOkButton:(double)newWidth :(double)newHeight;
- (void) CanvasSettingControllerDelegateCancelButton;
- (void) CanvasSettingControllerDelegateTappedColor:(UIColor*)tappedColor;
- (void) CanvasSettingControllerDelegateTappedGZColorHexValue:(NSString*)hexValue; // TODO civics temporary
- (UIColor*) CanvasSettingControllerAsksForCanvasColor;

@end

@interface CanvasSettingController : UIViewController <UIPopoverControllerDelegate, ColorViewControllerDelegate>

- (IBAction)okButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *widthDisplay;
@property (weak, nonatomic, readwrite) IBOutlet UITextField *heightDisplay;
@property (readwrite) ColorViewController* colorViewController;
@property (readwrite) UIColor* beginningCanvasColor;

// Declare a property for my delegate
@property (weak) id <CanvasSettingControllerDelegate> delegate;


@end
