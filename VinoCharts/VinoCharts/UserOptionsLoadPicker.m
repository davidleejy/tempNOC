//
//  UserOptionsLoadPicker.m
//  VinoCharts
//
//  Created by Hendy Chua on 24/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "UserOptionsLoadPicker.h"

@interface UserOptionsLoadPicker ()

@end

@implementation UserOptionsLoadPicker

@synthesize options;
@synthesize delegate;

-(id)initWithOptions:(NSArray *)optionsName{
    if([self init]){
        options = optionsName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    // self.contentSizeForViewInPopover = CGSizeMake(150.0, 100.0);
    //    options = [[NSArray alloc] initWithObjects:@"Sync",@"Logout", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.options count];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [self.options objectAtIndex:indexPath.row];
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
	}
    cell.textLabel.text = text;
    
    //for font
    if([UIFont fontWithName:text size:12]){
        cell.textLabel.font = [UIFont fontWithName:text size:12];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate != nil) {
        NSString *option = [self.options objectAtIndex:indexPath.row];
        [self.delegate optionSelected:option];
    }
}

@end
