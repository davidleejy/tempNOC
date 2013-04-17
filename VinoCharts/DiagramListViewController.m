//
//  DiagramListViewController.m
//  FinalSurvey
//
//  Created by Roy Huang Purong on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DiagramListViewController.h"

@interface DiagramListViewController ()

@end

@implementation DiagramListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentSizeForViewInPopover = CGSizeMake(250.0, 320.0);
    }
    return self;
}

-(id)initWithDiagramList:(NSArray*)list
{
    self = [super init];
    
    if(self)
    {
        diagramList = [[NSArray alloc]initWithArray:list];
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return diagramList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
    }
    
    NSString* cellText = [NSString stringWithString:[diagramList objectAtIndex:indexPath.row]];
    cell.textLabel.text = cellText;

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate updateButtonTitleWithIndex:indexPath.row];
}


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
