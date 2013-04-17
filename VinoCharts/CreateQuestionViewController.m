//
//  CreateQuestionViewController.m
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "CreateQuestionViewController.h"

@interface CreateQuestionViewController ()

@end

@implementation CreateQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(id)initWithQuestionIndex:(int)index
{
    self = [super init];
    
    if(self != nil)
    {
        QuestionIndex = index;
        questionList = [[NSMutableArray alloc]init];
        
        if(index == 0)
        {
            self.previousController = nil;
            self.nextController = nil;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if((QuestionIndex + 1) == MAX_QUESTION)
    {
        [self addNavigationButtonsWhenNumberOfQuestionReachesLimit];
    }
    else
    {
        [self addNavigationButtonsWhenNumberOfQuestionsUnderLimit];
    }
    
    [self addGestureRecognizerToDismissKeyboard];
    [self setUpInterfaceOutlook];
}

- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [self updateInterfaceTitle];
}



#pragma Instant methods

- (void)addNavigationButtonsWhenNumberOfQuestionReachesLimit
{
    //Initialize Navigationbar items
    UIBarButtonItem* deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteQuestion)];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(saveSurvey)];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousQuestion)];
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc]initWithTitle:@"All Questions" style:UIBarButtonItemStylePlain target:self action:@selector(viewListOfQuestions:)];
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
    [closeButton setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:doneButton, backButton, deleteButton, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:closeButton,menuButton, nil];
}

- (void)addNavigationButtonsWhenNumberOfQuestionsUnderLimit
{
    //Initialize Navigationbar items
    UIBarButtonItem* deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteQuestion)];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(saveSurvey)];
    UIBarButtonItem* nextButton = [[UIBarButtonItem alloc]initWithTitle:@"Add Question" style:UIBarButtonItemStylePlain target:self action:@selector(createNewQuestion)];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousQuestion)];
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc]initWithTitle:@"All Questions" style:UIBarButtonItemStylePlain target:self action:@selector(viewListOfQuestions:)];
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
    [closeButton setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:nextButton,backButton,doneButton,deleteButton, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:closeButton,menuButton, nil];
}

- (void)addGestureRecognizerToDismissKeyboard
{
    //Assign Gesturerecognizer to scroll view (hide keyboard)
    UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.myCanvasView addGestureRecognizer:singleTapGestureRecognizer];
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
}

- (void)setUpInterfaceOutlook
{
    self.titleView.layer.borderWidth = 0.5f;
    self.titleView.layer.borderColor = [[UIColor grayColor]CGColor];
    self.titleView.layer.cornerRadius = 5.0f;
    
    //set up options outlook
    NSArray* subviews = [self.optionArea subviews];
    for(UITextView* subview in subviews)
    {
        subview.layer.borderWidth = 0.5f;
        subview.layer.borderColor = [[UIColor grayColor]CGColor];
        subview.layer.cornerRadius = 5.0f;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)saveQuestion:(NSString *)currentQuestionType currentQuestionTitle:(NSString *)currentQuestionTitle
{
    //options
    NSMutableArray* contentArray = [[NSMutableArray alloc]init];
    NSArray* subviews = [self.optionArea subviews];
    
    [optionContentArray removeAllObjects];
    for(UIView* subview in subviews)
    {
        UITextView* currentOption = (UITextView*)subview;
        if (currentOption.text.length != 0)
        {
            [contentArray addObject:currentOption.text];
            [optionContentArray addObject:currentOption.text];
        }
    }
    
    [self.delegate updateQuestionToSurveyWithTitle:currentQuestionTitle Type:currentQuestionType Options:contentArray Index:QuestionIndex];
}

-(void)constructCurrentQuestionInfo
{
    NSString* currentQuestionTitle = self.titleView.text;
    questionTitle = self.titleView.text;
    
    NSString* currentQuestionType;
    switch (self.typePicker.selectedSegmentIndex)
    {
        case 0:
            currentQuestionType = @"Open End";
            break;
        case 1:
            currentQuestionType = @"Radio Button";
            break;
            
        case 2:
            currentQuestionType = @"Check Box";
            break;
            
        default:
            break;
    }
    questionType = currentQuestionType;
    
    [self saveQuestion:currentQuestionType currentQuestionTitle:currentQuestionTitle];
}

-(void)saveCurrentQuestionAndSubsequentQuestions
{
    [self constructCurrentQuestionInfo];
    if(self.nextController != nil)
    {
        [self.nextController saveCurrentQuestionAndSubsequentQuestions];
    }
}

-(BOOL)isMandotaryFieldsOfAllQuestionsFilled
{
    if(![self isMandotaryFieldFilled])
    {
        return NO;
    }
    if(self.nextController != nil)
    {
        return [self.nextController isMandotaryFieldsOfAllQuestionsFilled];
    }
    return YES;
}

-(BOOL)isMandotaryFieldFilled
{
    if(self.titleView.text.length == 0)
    {
        return NO;
    }
    
    if(self.typePicker.selectedSegmentIndex == 0)
    {
        return YES;
    }
    
    if([self isThereAtLeastOneOption])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)isThereAtLeastOneOption
{
    NSArray* subviews = [self.optionArea subviews];
    
    for(UIView* subview in subviews)
    {
        UITextView* currentOption = (UITextView*)subview;
        if(currentOption.text.length != 0)
        {
            return YES;
        }
    }
    return NO;
}

-(NSMutableArray*)getTheMatchedControllerWithIndex:(int)index controllerArray:(NSMutableArray*)currentControllerArray
{
    if(QuestionIndex == index)
    {
        [currentControllerArray addObject:self];
        return currentControllerArray;
    }
    else if(QuestionIndex < index)
    {
        [currentControllerArray addObject:self];
        return [self.nextController getTheMatchedControllerWithIndex:index controllerArray:(NSMutableArray*)currentControllerArray];
    }
    [currentControllerArray addObject:self];
    return [self.previousController getTheMatchedControllerWithIndex:index controllerArray:(NSMutableArray*)currentControllerArray];
}

-(void)pushToDestinationControllerWithIndex:(int)index
{
    if(QuestionIndex+1 == index)
    {
        [self.navigationController pushViewController:self.nextController animated:YES];
    }
    else
    {
        [self.navigationController pushViewController:self.nextController animated:NO];
        //keep pushing here
        [self.nextController pushToDestinationControllerWithIndex:index];
    }
}

-(void)popToDestinationControllerWithIndex:(int)index
{
    if(QuestionIndex-1 == index)
    {
        [self.navigationController popToViewController:self.previousController animated:YES];
    }
    else
    {
        [self.navigationController popToViewController:self.previousController animated:NO];
        //keep pushing here
        [self.previousController popToDestinationControllerWithIndex:index];
    }
}

-(void)switchToQuestionWithIndex:(int)index
{
    if(index == QuestionIndex)
    {
        return;
    }
    
    else if(index > QuestionIndex)
    {
        [self pushToDestinationControllerWithIndex:index];
    }
    
    else
    {
        [self popToDestinationControllerWithIndex:index];
    }
    
    [popoverQuestionListController dismissPopoverAnimated:YES];
}
#pragma end


#pragma Navigationbar button callback methods
-(void)deleteQuestion
{
    //Change navigation controllers
    if(self.previousController == nil)
    {
        [self.delegate changeFirstQuestion:self.nextController];
    }
    self.previousController.nextController = self.nextController;
    self.nextController.previousController = self.previousController;
    
    [self.delegate removeCurrentQuestionModel:QuestionIndex];
    [self.nextController updateQuestionIndex];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveSurvey
{
    //Check if mandatory fields are filled
    if(![self isMandotaryFieldsOfAllQuestionsFilled])
    {
        [self showEmptyFieldAlert];
    }
    else
    {
        [self saveCurrentQuestionAndSubsequentQuestions];
        [self.delegate finishEditingSuvey];
    }
}
- (void)constructAndDisplayNewQuestion
{
    CreateQuestionViewController* newQuestion = [[CreateQuestionViewController alloc]initWithQuestionIndex:(QuestionIndex + 1)];
    self.nextController = newQuestion;
    newQuestion.previousController = self;
    newQuestion.delegate = self.delegate;
    [self.delegate createEmptyQuestionModel];
    
    [self.navigationController pushViewController:newQuestion animated:YES];
}

-(void)createNewQuestion
{
    //Check if mandatory fields are filled
    if(![self isMandotaryFieldFilled])
    {
        [self showEmptyFieldAlert];
    }
    else
    {
        //Save current quesiton
        [self constructCurrentQuestionInfo];
        
        //Check if next question created
        if(self.nextController != nil)
        {
            [self.navigationController pushViewController:self.nextController animated:YES];
        }
        else
        {
            [self constructAndDisplayNewQuestion];
        }
    }
}

-(void)backToPreviousQuestion
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildQuestionList:(int)currentTotalNumberOfQuestion
{
    for(int i=0; i<currentTotalNumberOfQuestion; i++)
    {
        NSMutableString* currentQuestion = [NSMutableString stringWithString:@"Question "];
        [currentQuestion appendString:[NSString stringWithFormat:@"%d",i+1]];
        
        [questionList addObject:currentQuestion];
    }
}

-(void)viewListOfQuestions:(id)sender
{
    if(!popoverQuestionListController)
    {
        //Build the items
        int currentTotalNumberOfQuestion = [self.delegate getNumberOfQuestion];
        
        [self buildQuestionList:currentTotalNumberOfQuestion];
        
        QuestionPopoverViewController* controller = [[QuestionPopoverViewController alloc]initWithDiagramList:questionList];
        controller.delegate = self;
        popoverQuestionListController = [[UIPopoverController alloc]initWithContentViewController:controller];
    }
    
    if([popoverQuestionListController isPopoverVisible])
    {
        [popoverQuestionListController dismissPopoverAnimated:YES];
    }
    else
    {
        [popoverQuestionListController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
#pragma end

#pragma empty field alert
-(void)showEmptyFieldAlert
{
    UIAlertView *warningAlertView = [[UIAlertView alloc] initWithTitle:@"Mandatory Fields Not Filled"
                                                               message:@"Please fill in mandatory fields before proceeding."
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
    
    warningAlertView.alertViewStyle = UIAlertViewStyleDefault;
    warningAlertView.tag = 1;
    [warningAlertView show];
}


-(void)updateQuestionIndex
{
    QuestionIndex--;
    if(self.nextController != nil)
    {
        [self.nextController updateQuestionIndex];
    }
}

- (void)updateInterfaceTitle
{
    //Initialize viewcontroller title
    NSMutableString* currentQuestionNumber = [NSMutableString stringWithFormat:@"%d",QuestionIndex + 1];
    NSString* totalQuestionNumber = [NSString stringWithFormat:@"%d",[self.delegate getNumberOfQuestion]];
    [currentQuestionNumber appendString:@" of "];
    [currentQuestionNumber appendString:totalQuestionNumber];
    self.title = currentQuestionNumber;
}
#pragma end

#pragma keyboard events
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.width, 0.0);
    self.myCanvasView.contentInset = contentInsets;
    self.myCanvasView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    CGRect aRect = self.myCanvasView.frame;
    aRect.size.height -= kbSize.width;
    CGPoint originPoint = CGPointMake(activeView.frame.origin.x + activeView.superview.frame.origin.x, activeView.frame.origin.y+activeView.superview.frame.origin.y + activeView.frame.size.height);
    
    if (!CGRectContainsPoint(aRect, originPoint) )
    {
        
        CGPoint scrollPoint = CGPointMake(0.0, originPoint.y - kbSize.width);
        
        [self.myCanvasView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    self.myCanvasView.contentInset = contentInsets;
    
    self.myCanvasView.scrollIndicatorInsets = contentInsets;
}

-(void)hideKeyboard
{
    if(activeView != nil)
    {
        [activeView resignFirstResponder];
    }
    if([self.titleView isFirstResponder])
    {
        [self.titleView resignFirstResponder];
    }
}
#pragma end


#pragma Actions
- (IBAction)typePickerSelected:(id)sender
{
    switch (self.typePicker.selectedSegmentIndex)
    {
        case 0:
            [self.optionArea setHidden:YES];
            self.lblDescription.text = @"";
            break;
        case 1:
            [self.optionArea setHidden:NO];
            self.lblDescription.text = @"Surveyees can only select 1 option.";
            break;
        case 2:
            [self.optionArea setHidden:NO];
            self.lblDescription.text = @"Surveyees can select multiple options.";
            break;
            
        default:
            break;
    }
}
#pragma end


#pragma textView delegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    activeView = textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    activeView = nil;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    if(textView == self.titleView)
    {
        return (newLength > 500) ? NO : YES;
    }
    else
    {
        return (newLength > 100) ? NO : YES;
    }
}
#pragma end


#pragma default
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTitleView:nil];
    [self setTypePicker:nil];
    [self setMyCanvasView:nil];
    [self setOptionArea:nil];
    [self setLblDescription:nil];
    [super viewDidUnload];
}
#pragma end

@end
