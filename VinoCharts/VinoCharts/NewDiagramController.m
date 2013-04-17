//
//  NewDiagramController.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/25/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "NewDiagramController.h"
#import "EditDiagramController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import "Constants.h"

static double DEFAULT_WIDTH = 3000;
static double DEFAULT_HEIGHT = 4240;

@interface NewDiagramController ()
@property (readwrite) NSNumberFormatter* formatter;
@end

@implementation NewDiagramController


- (void)viewDidLoad
{
    [super viewDidLoad]; // Do any additional setup after loading the view.
    
    [_widthIO setText:[NSString stringWithFormat:@"%.0f",DEFAULT_WIDTH]];
    [_heightIO setText:[NSString stringWithFormat:@"%.0f",DEFAULT_HEIGHT]];
    
    [_widthIO setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_heightIO setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    [_widthIO setDelegate:self];
    [_heightIO setDelegate:self];
    
    _formatter = [[NSNumberFormatter alloc] init];
    [_formatter setNumberStyle:NSNumberFormatterDecimalStyle];
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    NSNumber* w = [_formatter numberFromString:_widthIO.text];
    NSNumber* h = [_formatter numberFromString:_heightIO.text];
    double w_dbl = [w doubleValue];
    double h_dbl = [h doubleValue];
    
    
    
    // If input is too small ...
    if (h_dbl < NOTE_DEFAULT_HEIGHT) {
        [self raiseUIAlert:[NSString stringWithFormat:@"Height is too small. Height should be larger than %d. Height has been automatically set to %d.",NOTE_DEFAULT_HEIGHT,NOTE_DEFAULT_HEIGHT]];
        h_dbl = NOTE_DEFAULT_HEIGHT;
    }
    if (w_dbl < NOTE_DEFAULT_WIDTH) {
        [self raiseUIAlert:[NSString stringWithFormat:@"Width is too small. Width should be larger than %d. Width has been automatically set to %d.",NOTE_DEFAULT_WIDTH,NOTE_DEFAULT_WIDTH]];
        w_dbl = NOTE_DEFAULT_WIDTH;
    }
    // If input is too big ...
    if (h_dbl > CANVAS_HEIGHT_UPPERLIM) {
        [self raiseUIAlert:[NSString stringWithFormat:@"Height is too big. Height should be smaller than %d. Height has been automatically set to %d.",CANVAS_HEIGHT_UPPERLIM,CANVAS_HEIGHT_UPPERLIM]];
        h_dbl = CANVAS_HEIGHT_UPPERLIM;
    }
    if (w_dbl > CANVAS_WIDTH_UPPERLIM) {
        [self raiseUIAlert:[NSString stringWithFormat:@"Width is too big. Width should be smaller than %d. Width has been automatically set to %d.",CANVAS_WIDTH_UPPERLIM,CANVAS_WIDTH_UPPERLIM]];
        w_dbl = CANVAS_HEIGHT_UPPERLIM;
    }
    
    if ([segue.identifier isEqualToString:@"EditDiagramController"]) {
        EditDiagramController *eDC = [segue destinationViewController];
        eDC.requestedCanvasHeight = h_dbl;
        eDC.requestedCanvasWidth = w_dbl;
        eDC.delegate = _projectDiagramsVC;
    }
    
}

#pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if((toInterfaceOrientation == UIDeviceOrientationLandscapeRight) ||
       (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft))
        return YES;
    else
        return NO;
}


/******* UITextFieldDelegate method *******/
/*
 ** The delegate method below concerns editing of the text in the width and height I/O.
 ** Content is enforced here.
 */

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString* futureContentOfTextField = [NSString stringWithFormat:@"%@%@",textField.text,string];
    NSNumber* value = [_formatter numberFromString:futureContentOfTextField];
    
    // If input is not a number ...
    if (value == nil) {
        [self raiseUIAlert:@"Must be a number."];
        return NO;
    }
    
    return YES;
}


-(void)raiseUIAlert:(NSString*)title{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [alert show];
}


- (void)viewDidUnload {
    [self setHeightIO:nil];
    [self setWidthIO:nil];
    [super viewDidUnload];
}











#pragma mark - Don't Care
/* Don't care about stuff below this line */
/********************************************************************************/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/******** Old stuff DON'T USE! DON'T USE! DON'T USE! DON'T USE! *********/
- (IBAction)createCanvasButton:(id)sender {
    
    EditDiagramController *eDC = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDiagramController"];
    
    eDC.requestedCanvasHeight = _height;
    eDC.requestedCanvasWidth = _width;
    
    // *** Transit to edit diagram scene ***
    
    [self presentViewController:eDC animated:NO completion:nil];
}



@end
