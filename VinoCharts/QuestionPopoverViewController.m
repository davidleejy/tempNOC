//
//  QuestionPopoverViewController.m
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/10/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "QuestionPopoverViewController.h"

@interface QuestionPopoverViewController ()

@end

@implementation QuestionPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(200.0, 480);
    }
    return self;
}

-(id)initWithDiagramList:(NSMutableArray*)list
{
    self = [super init];
    
    if(self)
    {
        questionList = [[NSMutableArray alloc]initWithArray:list];
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return questionList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
    
    NSString* cellText = [NSString stringWithString:[questionList objectAtIndex:indexPath.row]];
    cell.textLabel.text = cellText;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate switchToQuestionWithIndex:indexPath.row];
}

#pragma Methods
-(void)updateQuestionListWith:(NSMutableArray*)newList
{
    [questionList removeAllObjects];
    
    for(int i=0; i<newList.count; i++)
    {
        [questionList addObject:[newList objectAtIndex:i]];
    }
}
#pragma end


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
