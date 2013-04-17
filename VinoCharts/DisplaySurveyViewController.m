//
//  DisplaySurveyViewController.m
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/6/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DisplaySurveyViewController.h"

@interface DisplaySurveyViewController ()

@end

@implementation DisplaySurveyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    questionList = [[NSMutableArray alloc]init];
    ansArray = [[NSMutableArray alloc]init];
    QArray = [[NSMutableArray alloc]init];
    for(int i=0; i<self.model.questions.count; i++)
    {
        [ansArray addObject:[NSNull null]];
    }
    for(int i=0; i<self.model.questions.count; i++)
    {
        [QArray addObject:[[self.model.questions objectAtIndex:i]title]];
    }
    
    //Set up navigation bar items
    if(self.model.questions.count != 0)
    {
        [self setUpNavigationBarItemsWhenThereIsAtLeastOneQuestion];
    }
    else
    {
        [self setUpNavigationBarItemsForSurveyWithNoQuestion];
    }
    
    [self setUpInterfaceOutlook];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.txtSurveyTitle.text = self.model.title;
    self.txtSurveyDetail.text = self.model.detail;
}


#pragma instant methods
- (void)setUpNavigationBarItemsWhenThereIsAtLeastOneQuestion
{
    [self.navigationItem setHidesBackButton:YES animated:NO];
    UIBarButtonItem* nextButton = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(viewFirstQuestion)];
    UIBarButtonItem* menuButton = [[UIBarButtonItem alloc]initWithTitle:@"All Questions" style:UIBarButtonItemStylePlain target:self action:@selector(viewListOfQuestions:)];
    UIBarButtonItem* quitButton = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(quitCurrentSurvey)];
    [quitButton setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:nextButton, nil];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:quitButton, menuButton, nil];
}

- (void)setUpNavigationBarItemsForSurveyWithNoQuestion
{
    UIBarButtonItem* quitButton = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(quitCurrentSurvey)];
    [quitButton setTintColor:[UIColor redColor]];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:quitButton, nil];
}

- (void)setUpInterfaceOutlook
{
    //Interface title
    self.title = @"Survey Details";
    self.txtSurveyDetail.layer.borderWidth = 0.5f;
    self.txtSurveyDetail.layer.borderColor = [[UIColor grayColor]CGColor];
    self.txtSurveyDetail.layer.cornerRadius = 5.0f;
    self.view.backgroundColor = [UIColor whiteColor];
}
#pragma end


#pragma navigation bar call back methods
-(void)viewFirstQuestion
{
    if(firstQuestion != nil)
    {
        [self.navigationController pushViewController:firstQuestion animated:YES];
    }
    else
    {
        //Configure first question and display it
        DisplayQuestionViewController* newQuestion = [[DisplayQuestionViewController alloc]initWithQuestionIndex:0];
        newQuestion.delegate = self;
        firstQuestion = newQuestion;
        [self.navigationController pushViewController:newQuestion animated:YES];
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
        int currentTotalNumberOfQuestion = [self.model getNumberOfQuestion];
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

-(void)quitCurrentSurvey
{
    [self dismissModalViewControllerAnimated:YES];
}
#pragma end


#pragma Question delegates
-(int)getNumberOfQuestion
{
    return [self.model getNumberOfQuestion];
}

-(NSArray*)getQuestionInfoFromModelWithIndex:(int)index
{
    return [self.model getQuestionInfoWithIndex:index];
}

-(void)addAnswerWith:(NSMutableArray*)ans WithIndex:(int)questionIndex;
{
    [ansArray replaceObjectAtIndex:questionIndex withObject:ans];
}

-(void)finishSurveyWithFeedBackTitle:(NSString*)title
{
    //remove null elements
    for(int i=0; i<ansArray.count; i++)
    {
        NSMutableArray* currentQuestion = [ansArray objectAtIndex:i];
        [currentQuestion removeObjectIdenticalTo:(id)[NSNull null]];
    }
    feedBackTitle = title;
    [self.delegate createFeedbackWithTitle:feedBackTitle Question:QArray Content:ansArray];
    [self dismissModalViewControllerAnimated:YES];
}

-(BOOL)isAllAnswered
{
    int answeredNumber = 0;
    for(int i=0; i<ansArray.count; i++)
    {
        //check individual question
        NSMutableArray* currentQuestion = [ansArray objectAtIndex:i];
        if(![currentQuestion isEqual:[NSNull null]])
        {
            for(int j=0; j<currentQuestion.count; j++)
            {
                if(![[currentQuestion objectAtIndex:j]isEqual:(id)[NSNull null]])
                {
                    NSString* currentAnsString = [currentQuestion objectAtIndex:j];
                    if(![self isCurrentStringEmpty:currentAnsString])
                    {
                        answeredNumber++;
                        break;
                    }
                }
            }
        }
    }
    
    if(answeredNumber == ansArray.count)
    {
        return YES;
    }
    return NO;
}

-(BOOL)isCurrentStringEmpty:(NSString*)currentString
{
    NSString* stringWithWhiteSpaceRemoved = [currentString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if([stringWithWhiteSpaceRemoved length] == 0)
    {
        return YES;
    }
    
    return NO;
}

-(void)returnToMainInterface
{
    [self.navigationController popToViewController:self animated:NO];
    [self dismissModalViewControllerAnimated:YES];
}
#pragma end


#pragma Popover delegate
-(void)switchToQuestionWithIndex:(int)index
{
    if(firstQuestion != nil)
    {
        if(index == 0)
        {
            [self.navigationController pushViewController:firstQuestion animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:firstQuestion animated:NO];
            [firstQuestion pushToDestinatedControllerWithIndex:index];
        }
    }
    else
    {
        DisplayQuestionViewController* newQuestion = [[DisplayQuestionViewController alloc]initWithQuestionIndex:0];
        newQuestion.delegate = self;
        firstQuestion = newQuestion;
        if(index == 0)
        {
            [self.navigationController pushViewController:newQuestion animated:YES];
        }
        else
        {
            [self.navigationController pushViewController:newQuestion animated:NO];
            [firstQuestion pushToDestinatedControllerWithIndex:index];
        }
    }
    
    [popoverQuestionListController dismissPopoverAnimated:YES];
}
#pragma end


#pragma default
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTxtSurveyTitle:nil];
    [self setTxtSurveyDetail:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
#pragma end

@end
