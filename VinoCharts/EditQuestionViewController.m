//
//  EditQuestionViewController.m
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "EditQuestionViewController.h"

@interface EditQuestionViewController ()

@end

@implementation EditQuestionViewController

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
    [self addGestureRecognizerToDismissKeyboard];
    
    //Update title and content
    NSArray* currentQuestionInfo = [self.delegate getQuestionInfoFromModelWithIndex:QuestionIndex];
    
    //Initialize view content if current question is not a newly created one
    if(currentQuestionInfo.count != 0)
    {
        self.titleView.text = currentQuestionInfo[0];
        
        if([currentQuestionInfo[1] isEqualToString:@"Open End"])
        {
            [self setUpOpenEndedOption:currentQuestionInfo];
        }
        else if([currentQuestionInfo[1] isEqualToString:@"Radio Button"])
        {
            [self setUpRadioButtonOption:currentQuestionInfo];
        }
        else
        {
            [self setUPCheckBoxOption:currentQuestionInfo];
        }
    }
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
    //Update navigation bar items
    if((QuestionIndex + 1) == MAX_QUESTION)
    {
        [self addNavigationBarItemsWhenNumberOfQuestionReachesLimit];
    }
    else if((QuestionIndex + 1) == [self.delegate getNumberOfQuestion])
    {
        [self addNavigationBarItemsWhenCurrentQuestionIsLastQuestion];
    }
    else
    {
        [self addNavigationBarItemsInNormalCase];
    }
    [self updateInterfaceTitle];
}


#pragma instant methods
- (void)setUPCheckBoxOption:(NSArray *)currentQuestionInfo
{
    [self.typePicker setSelectedSegmentIndex:2];
    questionTitle = currentQuestionInfo[0];
    questionType = @"Check Box";
    optionContentArray = [[NSMutableArray alloc]initWithArray:currentQuestionInfo[2]];
    
    [self loadOptionsWithArray:currentQuestionInfo[2]];
    [self.optionArea setHidden:NO];
    [self.lblDescription setText:@"Surveyees can select multiple options."];
}

- (void)setUpRadioButtonOption:(NSArray *)currentQuestionInfo
{
    [self.typePicker setSelectedSegmentIndex:1];
    questionTitle = currentQuestionInfo[0];
    questionType = @"Radio Button";
    optionContentArray = [[NSMutableArray alloc]initWithArray:currentQuestionInfo[2]];
    
    [self loadOptionsWithArray:currentQuestionInfo[2]];
    [self.optionArea setHidden:NO];
    [self.lblDescription setText:@"Surveyees can only select 1 option."];
}

- (void)setUpOpenEndedOption:(NSArray *)currentQuestionInfo
{
    [self.typePicker setSelectedSegmentIndex:0];
    questionTitle = currentQuestionInfo[0];
    questionType = @"Open End";
}

- (void)addGestureRecognizerToDismissKeyboard
{
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
        subview.layer.borderColor = [[UIColor blackColor]CGColor];
        subview.layer.cornerRadius = 5.0f;
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)addNavigationBarItemsWhenNumberOfQuestionReachesLimit
{
    //Initialize Navigationbar items
    UIBarButtonItem* deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteQuestion)];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveSurvey)];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousQuestion)];
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc]initWithTitle:@"All Questions" style:UIBarButtonItemStylePlain target:self action:@selector(viewListOfQuestions:)];
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
    [closeButton setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:doneButton, backButton, deleteButton, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:closeButton,menuButton, nil];
}

- (void)addNavigationBarItemsWhenCurrentQuestionIsLastQuestion
{
    //Initialize Navigationbar items
    UIBarButtonItem* deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteQuestion)];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveSurvey)];
    UIBarButtonItem* newButton = [[UIBarButtonItem alloc]initWithTitle:@"Add Question" style:UIBarButtonItemStylePlain target:self action:@selector(createNewQuestion)];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousQuestion)];
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc]initWithTitle:@"All Questions" style:UIBarButtonItemStylePlain target:self action:@selector(viewListOfQuestions:)];
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
    [closeButton setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:newButton, backButton, doneButton, deleteButton, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:closeButton,menuButton, nil];
}

- (void)addNavigationBarItemsInNormalCase
{
    //Initialize Navigationbar items
    UIBarButtonItem* deleteButton = [[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStylePlain target:self action:@selector(deleteQuestion)];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveSurvey)];
    UIBarButtonItem* nextButton = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(loadNextQuestion)];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(backToPreviousQuestion)];
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc]initWithTitle:@"All Questions" style:UIBarButtonItemStylePlain target:self action:@selector(viewListOfQuestions:)];
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
    [closeButton setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:nextButton, backButton, doneButton, deleteButton, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:closeButton, menuButton, nil];
}

-(void)loadOptionsWithArray:(NSMutableArray*)currentArray
{
    NSMutableArray* tempArray = [[NSMutableArray alloc]initWithArray:currentArray];
    NSArray* subviews = [self.optionArea subviews];
    
    for(int i=0; i<tempArray.count; i++)
    {
        UITextView* currentOption = (UITextView*)[subviews objectAtIndex:i];
        currentOption.text = [tempArray objectAtIndex:i];
    }
}

- (void)passCurrentQuestionInfoToSurvey
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
    
    [self.delegate updateQuestionToSurveyWithTitle:questionTitle Type:questionType Options:contentArray Index:QuestionIndex];
}

-(void)saveCurrentQuestion
{
    //title
    questionTitle = self.titleView.text;
    
    //type
    switch (self.typePicker.selectedSegmentIndex)
    {
        case 0:
            questionType = @"Open End";
            break;
        case 1:
            questionType = @"Radio Button";
            break;
            
        case 2:
            questionType = @"Check Box";
            break;
            
        default:
            break;
    }
    
    [self passCurrentQuestionInfoToSurvey];
}

-(void)saveCurrentQuestionAndSubsequentQuestions
{
    [self saveCurrentQuestion];
    if(self.nextController != nil)
    {
        [self.nextController saveCurrentQuestionAndSubsequentQuestions];
    }
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

-(void)pushToDestinatedControllerWithIndex:(int)index
{
    if(self.nextController != nil)
    {
        if(QuestionIndex+1 == index)
        {
            [self.navigationController pushViewController:self.nextController animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:self.nextController animated:NO];
            //Keep pushing
            [self.nextController pushToDestinatedControllerWithIndex:index];
        }
    }
    else
    {
        EditQuestionViewController* newQuestion = [[EditQuestionViewController alloc]initWithQuestionIndex:(QuestionIndex + 1)];
        self.nextController = newQuestion;
        newQuestion.previousController = self;
        newQuestion.delegate = self.delegate;
        
        if(QuestionIndex+1 == index)
        {
            [self.navigationController pushViewController:newQuestion animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:newQuestion animated:NO];
            [self.nextController pushToDestinatedControllerWithIndex:index];
        }
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
        //keep poping here
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
        [self pushToDestinatedControllerWithIndex:index];
    }
    
    else
    {
        [self popToDestinationControllerWithIndex:index];
    }
    
    [popoverQuestionListController dismissPopoverAnimated:YES];
}
#pragma end


#pragma Navigation Bar delegation methods
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
    
    //Update quesiton index
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

- (void)constructNewQuestion
{
    //Hook up with the newly created question
    EditQuestionViewController* newQuestion = [[EditQuestionViewController alloc]initWithQuestionIndex:(QuestionIndex + 1)];
    self.nextController = newQuestion;
    newQuestion.previousController = self;
    newQuestion.delegate = self.delegate;
    
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
        [self saveCurrentQuestion];
        
        //Create a new empty question model in survey model
        [self.delegate createEmptyQuestionModel];
        [self constructNewQuestion];
    }
}

-(void)backToPreviousQuestion
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)constructNextEditedQuestion
{
    EditQuestionViewController* newQuestion = [[EditQuestionViewController alloc]initWithQuestionIndex:(QuestionIndex + 1)];
    self.nextController = newQuestion;
    newQuestion.previousController = self;
    newQuestion.delegate = self.delegate;
    
    [self.navigationController pushViewController:newQuestion animated:YES];
}

-(void)loadNextQuestion
{
    if(![self isMandotaryFieldFilled])
    {
        [self showEmptyFieldAlert];
    }
    else
    {
        [self constructNextEditedQuestion];
    }
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


#pragma Check mandotary fields
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
#pragma end


#pragma empty field alert
-(void)showEmptyFieldAlert
{
    UIAlertView *warningAlertView = [[UIAlertView alloc] initWithTitle:@"Mandatory Field(s) Not Filled"
                                                               message:@"Please fill in all mandatory fills before proceeding."
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
    CGPoint originPoint = CGPointMake(activeView.frame.origin.x + activeView.superview.frame.origin.x, activeView.frame.origin.y+activeView.superview.frame.origin.y);
    
    if (!CGRectContainsPoint(aRect, originPoint) )
    {
        
        CGPoint scrollPoint = CGPointMake(0.0, originPoint.y + activeView.frame.size.height-kbSize.width);
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


#pragma textView Deletation methods
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

- (void)viewDidUnload
{
    [self setMyCanvasView:nil];
    [self setTitleView:nil];
    [self setTypePicker:nil];
    [self setOptionArea:nil];
    [self setLblDescription:nil];
    [super viewDidUnload];
}
#pragma end

@end
