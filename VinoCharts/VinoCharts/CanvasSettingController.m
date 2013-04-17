//
//  CanvasSettingController.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/29/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#define DEBUG 1

#import "CanvasSettingController.h"
#import "ColorViewController.h"

#import "Constants.h"


@implementation CanvasSettingController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_widthDisplay setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_heightDisplay setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    
    _colorViewController = [[ColorViewController alloc] init];
    _colorViewController.delegate = self;
    [self.view addSubview:_colorViewController.view];
    
    [_colorViewController.view setFrame:CGRectMake(200, 0,
                                                   _colorViewController.view.frame.size.width,
                                                   _colorViewController.view.frame.size.height)];
    _beginningCanvasColor = [[UIColor alloc]init];

}

-(void)viewWillAppear:(BOOL)animated{
    _beginningCanvasColor = [_delegate CanvasSettingControllerAsksForCanvasColor];
}

-(void) colorPopoverControllerDidSelectColor:(NSString *)hexColor{
    [_delegate CanvasSettingControllerDelegateTappedColor:[GzColors colorFromHex:hexColor]];
    [_delegate CanvasSettingControllerDelegateTappedGZColorHexValue:hexColor]; //TODO temporary
}


- (IBAction)okButton:(id)sender {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *w = [f numberFromString:_widthDisplay.text];
    NSNumber *h = [f numberFromString:_heightDisplay.text];
    double w_dbl = [w doubleValue];
    double h_dbl = [h doubleValue];
    
    if (DEBUG) {
        NSLog(@"CanvasSettingController okButton width %@ height %@",w,h);
    }
    
    double note_default_width = NOTE_DEFAULT_WIDTH;
    double note_default_height = NOTE_DEFAULT_HEIGHT;
    
    
    if (w == nil || h == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Width and height must be numbers."]
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:(BOOL)NO afterDelay:1.0f];
    }
    else if (w_dbl <= note_default_width|| h_dbl <= note_default_height) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Width and height must be large enough to accommodate at least 1 note. The default width and height of a note are %d and %d respectively.",NOTE_DEFAULT_WIDTH,NOTE_DEFAULT_HEIGHT]
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else if (w_dbl > 10000|| h_dbl > 10000){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Width cannot exceed %d. Height cannot exceed %d",CANVAS_WIDTH_UPPERLIM,CANVAS_HEIGHT_UPPERLIM]
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else {
        [_delegate CanvasSettingControllerDelegateOkButton:[w doubleValue] :[h doubleValue]];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelButton:(id)sender {
    [_delegate CanvasSettingControllerDelegateCancelButton];
}


- (void)viewDidUnload {
    [self setWidthDisplay:nil];
    [self setHeightDisplay:nil];
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
