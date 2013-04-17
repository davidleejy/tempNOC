//
//  ViewController.m
//  DelegationProblem
//
//  Created by Roy Huang Purong on 4/9/13.
//  Copyright (c) 2013 nus.3217. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    questionArray = [[NSMutableArray alloc]initWithArray:self.model.questionArray];
    answerArray = [[NSMutableArray alloc]initWithArray:self.model.answerArray];
    feedbackTitle = self.model.title;
    
    self.myCanvasView.layer.borderWidth = 0.5f;
    self.myCanvasView.layer.borderColor = [[UIColor grayColor]CGColor];
    
    if (listOfDiagramInfo!=nil) {
        listOfDiagramInfo = [[self.delegate getListOfDiagrams] copy];
    } else {
        listOfDiagramInfo = nil;
    }
    //listOfDiagramInfo = [[NSMutableArray alloc]initWithObjects:[NSMutableArray arrayWithObjects:@"Diagram 1",@"Diagram 2",@"Diagram 3", nil],[NSMutableArray arrayWithObjects:@"30",@"50",@"60", nil], nil];
    
    QASectionView* previousSectionView;
    for(int i=0; i<questionArray.count; i++)
    {
        QASectionView* newSectionView = [[QASectionView alloc]initWithQuestion:[questionArray objectAtIndex:i] Answer:[answerArray objectAtIndex:i]];
        if(previousSectionView != nil)
        {
            newSectionView.frame = CGRectMake(previousSectionView.frame.origin.x, previousSectionView.frame.origin.y + previousSectionView.frame.size.height + 20.0,newSectionView.frame.size.width, newSectionView.frame.size.height);
        }
        else
        {
            newSectionView.frame = CGRectMake(50.0, 50.0, newSectionView.frame.size.width, newSectionView.frame.size.height);
        }
        newSectionView.delegate = self;
        [self.myCanvasView addSubview:newSectionView];
        previousSectionView = newSectionView;
    }
    
    self.myCanvasView.contentSize = CGSizeMake(self.myCanvasView.contentSize.width, previousSectionView.frame.origin.y + previousSectionView.frame.size.height + 30.0);
    self.title = feedbackTitle;
    
    //Set the diagram info
    [self initializeAndDisplayDiagramInfo];
    
    //Set the background image
    self.myCanvasView.backgroundColor = [UIColor whiteColor];
}

-(void)initializeAndDisplayDiagramInfo
{
    if(listOfDiagramInfo != nil)
    {
        [self.numberOfNotesLeft setHidden:NO];
        //Set the diagram button text
        [self.btnDiagram setTitle:[NSString stringWithFormat:@"Selected Diagram: %@",[[listOfDiagramInfo objectAtIndex:0]
                                                                                      objectAtIndex:0]]];
        //Set the note title and index
        currentDiagramIndex = 0;
        NSMutableString* noteInfo = [NSString stringWithFormat:@"You can create %@ more notes in the selected diagram. (Max. 100)", [NSMutableString stringWithString:[[listOfDiagramInfo objectAtIndex:1]objectAtIndex:0]]];
        [self.numberOfNotesLeft setText:noteInfo];
    }
    else
    {
        [self.numberOfNotesLeft setHidden:YES];
        [self.btnDiagram setTitle:@"No Diagram (Create 1?)"];
    }
}

#pragma QASectionView delegate methods
-(void)CreateNoteWithText:(NSString*)selectedString
{
    if(listOfDiagramInfo == nil)
    {
        [self showEmptyDiagramWarning];
    }
    else
    {
        int currentNumberOfNotesLeft = [[[listOfDiagramInfo objectAtIndex:1]objectAtIndex:currentDiagramIndex] intValue];
        if(currentNumberOfNotesLeft == 0)
        {
            [self showReachNumberOfNoteLimitWarning];
        }
        else
        {
            currentNumberOfNotesLeft--;
            [[listOfDiagramInfo objectAtIndex:1]replaceObjectAtIndex:currentDiagramIndex withObject:[NSString stringWithFormat:@"%d",currentNumberOfNotesLeft]];
            
            NSMutableString* noteInfo = [NSString stringWithFormat:@"You can create %@ more notes in the selected diagram. (Max. 100)", [NSMutableString stringWithString:[[listOfDiagramInfo objectAtIndex:1]objectAtIndex:currentDiagramIndex]]];
            [self.numberOfNotesLeft setText:noteInfo];
            
            //Uncomment it to create note
            //[self.delegate CreateNoteWithContent:selectedString InDiagramIndex:currentDiagramIndex];
            [self showSuccessfulCreationMessageWithNoteContent:selectedString];
        }
    }
}

-(void)showEmptyDiagramWarning
{
    UIAlertView *warningAlertView = [[UIAlertView alloc] initWithTitle:@"No Diagram Available"
                                                               message:@"Please enter a diagram name below to create one:"
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                     otherButtonTitles:@"Submit", nil];
    
    warningAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    warningAlertView.tag = 2;
    [warningAlertView show];
}

-(void)showReachNumberOfNoteLimitWarning
{
    UIAlertView *warningAlertView = [[UIAlertView alloc] initWithTitle:@"Note Not Created"
                                                               message:@"No more notes available for current diagram"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
    
    warningAlertView.alertViewStyle = UIAlertViewStyleDefault;
    warningAlertView.tag = 1;
    [warningAlertView show];
}

-(void)ShowMaximumContentSizeWarning
{
    UIAlertView *warningAlertView = [[UIAlertView alloc] initWithTitle:@"Note Not Created"
                                                               message:@"Exceeded maximum number of characters: 140"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
    
    warningAlertView.alertViewStyle = UIAlertViewStyleDefault;
    warningAlertView.tag = 1;
    [warningAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* title;
    NSArray* returnedList;
    
    if(alertView.tag == 2)
    {
        switch (buttonIndex)
        {
            case 0:
                
                break;
            case 1:
                title = [[alertView textFieldAtIndex:0]text];
                returnedList = [self.delegate CreateAndReturnListOfDiagramsDiagramNamed:title];
                
                if(returnedList == nil)
                {
                    listOfDiagramInfo = nil;
                }
                else
                {
                    listOfDiagramInfo = [NSMutableArray arrayWithArray:returnedList];
                }
                [self initializeAndDisplayDiagramInfo];
                break;
                
            default:
                break;
        }
    }
}
#pragma end

-(void)showSuccessfulCreationMessageWithNoteContent:(NSString*)content
{
    NSMutableString* message = [NSMutableString stringWithString:@"A note with content: "];
    [message appendString:content];
    [message appendString:@" has been created"];
    
    UIAlertView *warningAlertView = [[UIAlertView alloc] initWithTitle:@"Note Created"
                                                               message:message
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
    
    warningAlertView.alertViewStyle = UIAlertViewStyleDefault;
    warningAlertView.tag = 1;
    [warningAlertView show];
}

#pragma update the title of diagram button
-(void)updateButtonTitleWithIndex:(int)index
{
    [self.btnDiagram setTitle:[NSString stringWithFormat:@"Selected Diagram: %@",[[listOfDiagramInfo objectAtIndex:0]objectAtIndex:index]]];
    
    NSMutableString* noteInfo = [NSString stringWithFormat:@"You can create %@ more notes in the selected diagram. (Max. 100)", [NSMutableString stringWithString:[[listOfDiagramInfo objectAtIndex:1]objectAtIndex:index]]];
    
    [self.numberOfNotesLeft setText:noteInfo];
    [popoverDiagramList dismissPopoverAnimated:YES];
    
    currentDiagramIndex = index;
}
#pragma end

- (void)viewDidUnload {
    [self setNumberOfNotesLeft:nil];
    [self setMyCanvasView:nil];
    [self setBtnDiagram:nil];
    [super viewDidUnload];
}

- (IBAction)backToMainInterface:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showDiagramList:(id)sender
{
    if(listOfDiagramInfo != nil)
    {
        if(!popoverDiagramList)
        {
            DiagramListViewController* controller = [[DiagramListViewController alloc]initWithDiagramList:[listOfDiagramInfo objectAtIndex:0]];
            controller.delegate = self;
            
            popoverDiagramList = [[UIPopoverController alloc]initWithContentViewController:controller];
            
        }
        if([popoverDiagramList isPopoverVisible])
        {
            [popoverDiagramList dismissPopoverAnimated:YES];
        }
        else
        {
            [popoverDiagramList presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
    else
    {
        [self showEmptyDiagramWarning];
    }
}

// Override to allow orientations other than the default portrait orientation.
// Rotation for v. 5.1.1
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
