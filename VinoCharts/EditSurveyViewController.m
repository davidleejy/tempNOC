//
//  EditSurveyViewController.m
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "EditSurveyViewController.h"

@interface EditSurveyViewController ()

@end

@implementation EditSurveyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeProperties];
    [self addGestureRegnizerToDismissKeyboard];
    
    if(self.model.questions.count != 0)
    {
        [self setUpNavigationItemsWhenThereIsAtLeastOneQuestion];
    }
    else
    {
        [self setUpNavigationItemsWhenOneSurveyWithoutQuestions];
    }
    
    [self setUpOutlook];
}


#pragma instant methods
- (void)addGestureRegnizerToDismissKeyboard
{
    //Add Tap gesture recognizer
    UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
    [self.myBackgroundView addGestureRecognizer:singleTapGestureRecognizer];
    singleTapGestureRecognizer.cancelsTouchesInView = NO;
}

- (void)setUpNavigationItemsWhenThereIsAtLeastOneQuestion
{
    [self.navigationItem setHidesBackButton:YES animated:NO];
    UIBarButtonItem* nextButton = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(editFirstQuestion)];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveSurvey)];
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc]initWithTitle:@"All Questions" style:UIBarButtonItemStylePlain target:self action:@selector(viewListOfQuestions:)];
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
    [closeButton setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:nextButton,doneButton, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:closeButton, menuButton, nil];
}

- (void)setUpNavigationItemsWhenOneSurveyWithoutQuestions
{
    [self.navigationItem setHidesBackButton:YES animated:NO];
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveSurvey)];
    UIBarButtonItem* newButton = [[UIBarButtonItem alloc]initWithTitle:@"Add Question" style:UIBarButtonItemStylePlain target:self action:@selector(createNewQuestion)];
    UIBarButtonItem* closeButton = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(dismissModalViewControllerAnimated:)];
    [closeButton setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:doneButton,newButton, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:closeButton, nil];
}

- (void)initializeProperties
{
    self.txtTitleView.delegate = self;
    self.txtDetailView.delegate = self;
    questionList = [[NSMutableArray alloc]init];
    firstQuestion = nil;
    self.title = @"Survey Details (Edit)";
}

- (void)setUpOutlook
{
    //Set up outlook
    self.txtTitleView.text = self.model.title;
    self.txtDetailView.text = self.model.detail;
    [self.txtTitleView becomeFirstResponder];
    self.txtDetailView.layer.borderWidth = 0.5f;
    self.txtDetailView.layer.borderColor = [[UIColor grayColor]CGColor];
    self.txtDetailView.layer.cornerRadius = 5.0f;
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)showFirstEditedQuestion
{
    //Switch to question view
    EditQuestionViewController* newQuestion = [[EditQuestionViewController alloc]initWithQuestionIndex:0];
    newQuestion.delegate = self;
    firstQuestion = newQuestion;
    [self.navigationController pushViewController:newQuestion animated:YES];
}

- (void)editFirstQuestion
{
    if(self.txtTitleView.text.length == 0)
    {
        [self showEmptyWarning];
    }
    else
    {
        //Update survey title and description info to model
        [self.model setTitle:self.txtTitleView.text];
        [self.model setDetail:self.txtDetailView.text];
        
        if(firstQuestion != nil)
        {
            [self.navigationController pushViewController:firstQuestion animated:YES];
        }
        else
        {
            [self showFirstEditedQuestion];
        }
    }
}

-(void)createNewQuestion
{
    if(self.txtTitleView.text.length == 0 || self.txtDetailView.text.length == 0)
    {
        [self showEmptyWarning];
    }
    else
    {
        //Update survey title and description info to model
        [self.model setTitle:self.txtTitleView.text];
        [self.model setDetail:self.txtDetailView.text];
        
        [self createEmptyQuestionModel];

        //Switch to question view
        EditQuestionViewController* newQuestion = [[EditQuestionViewController alloc]initWithQuestionIndex:0];
        newQuestion.delegate = self;
        firstQuestion = newQuestion;
        [self.navigationController pushViewController:newQuestion animated:YES];
    }
}

- (void)constructQuestionList:(int)currentTotalNumberOfQuestion
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
        int currentTotalNumberOfQuestion = [self.model getNumberOfQuestion];
        [self constructQuestionList:currentTotalNumberOfQuestion];
        
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

-(void)showEmptyWarning
{
    UIAlertView *warningAlertView = [[UIAlertView alloc] initWithTitle:@"Mandatory Field Not Filled"
                                                               message:@"Please fill in mandatory fields before saving!"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
    
    warningAlertView.alertViewStyle = UIAlertViewStyleDefault;
    warningAlertView.tag = 1;
    [warningAlertView show];
}

-(void)showQuestionNotCompletedWarning
{
    UIAlertView *warningAlertView = [[UIAlertView alloc] initWithTitle:@"Mandatory Field Not Filled"
                                                               message:@"Please check mandotary fields of questions!"
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil, nil];
    
    warningAlertView.alertViewStyle = UIAlertViewStyleDefault;
    warningAlertView.tag = 2;
    [warningAlertView show];
}

-(void)hideKeyboard
{
    if([self.txtTitleView isFirstResponder])
    {
        [self.txtTitleView resignFirstResponder];
    }
    if([self.txtDetailView isFirstResponder])
    {
        [self.txtDetailView resignFirstResponder];
    }
}

-(void)saveSurvey
{
    //check completeness of each question
    if(self.txtTitleView.text.length == 0)
    {
        [self showEmptyWarning];
    }
    else
    {
        if(firstQuestion != nil)
        {
            if([self isMandotaryFieldsOfAllQuestionsFilled])
            {
                [firstQuestion saveCurrentQuestionAndSubsequentQuestions];
                [self dismissModalViewControllerAnimated:YES];
            }
            else
            {
                [self showQuestionNotCompletedWarning];
            }
        }
        else
        {
            [self dismissModalViewControllerAnimated:YES];
        }
        self.model.title = self.txtTitleView.text;
        self.model.detail = self.txtDetailView.text;
        [self.delegate updateSurvey:self.model];
    }
}

-(BOOL)isMandotaryFieldsOfAllQuestionsFilled
{
    return [firstQuestion isMandotaryFieldsOfAllQuestionsFilled];
}
#pragma end


#pragma delegation methods of Question
-(void)createEmptyQuestionModel
{
    [self.model addEmptyQuestion];
}

-(void)removeCurrentQuestionModel:(int)index
{
    [self.model deleteQuestionAtIndex:index];
}

-(void)updateQuestionToSurveyWithTitle:(NSString*)title Type:(NSString*)type Options:(NSMutableArray*)optionList Index:(int)index
{
    [self.model updateQuestionWithTitle:title Type:type Options:optionList Index:index];
}

-(void)finishEditingSuvey
{
    [self dismissModalViewControllerAnimated:YES];
    [self.delegate updateSurvey:self.model];
}

-(int)getNumberOfQuestion
{
    return [self.model getNumberOfQuestion];
}

-(void)changeFirstQuestion:(EditQuestionViewController*)sender
{
    firstQuestion = sender;
}

-(NSArray*)getQuestionInfoFromModelWithIndex:(int)index
{
    return [self.model getQuestionInfoWithIndex:index];
}

-(void)switchToQuestionWithIndex:(int)index
{
    if(self.txtTitleView.text.length == 0 || self.txtDetailView.text.length == 0)
    {
        [self showEmptyWarning];
        return;
    }

    //Update survey title and description info to model
    [self.model setTitle:self.txtTitleView.text];
    [self.model setDetail:self.txtDetailView.text];
    
    if(firstQuestion != nil)
    {
        if(index == 0)
        {
            [self.navigationController pushViewController:firstQuestion animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:firstQuestion animated:NO];
            //continue push here
            [firstQuestion pushToDestinatedControllerWithIndex:index];
        }
    }
    else
    {
        EditQuestionViewController* newQuestion = [[EditQuestionViewController alloc]initWithQuestionIndex:0];
        newQuestion.delegate = self;
        firstQuestion = newQuestion;
       if(index == 0)
       {
            
            [self.navigationController pushViewController:newQuestion animated:YES];
       }
        else
        {
            [self.navigationController pushViewController:newQuestion animated:NO];
            //continue push here
            [firstQuestion pushToDestinatedControllerWithIndex:index];
        }
    }
    
    [popoverQuestionListController dismissPopoverAnimated:YES];
}
#pragma end

#pragma textField and textview delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtTitleView) {
        [self.txtDetailView becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 100) ? NO : YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    return (newLength > 500) ? NO : YES;
}
#pragma end


#pragma default
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (void)viewDidUnload {
    [self setTxtTitleView:nil];
    [self setTxtDetailView:nil];
    [self setMyBackgroundView:nil];
    [super viewDidUnload];
}
#pragma end
@end
