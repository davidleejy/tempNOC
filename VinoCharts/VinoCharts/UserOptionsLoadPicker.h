//
//  UserOptionsLoadPicker.h
//  VinoCharts
//
//  Created by Hendy Chua on 24/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserOptionsLoadPickerDelegate

- (void)optionSelected:(NSString *)option;

@end

@interface UserOptionsLoadPicker : UITableViewController {
    NSArray *options;
    id<UserOptionsLoadPickerDelegate> delegate;
}

@property (readonly, strong) NSArray *options;
@property (nonatomic) id<UserOptionsLoadPickerDelegate> delegate;

-(id)initWithOptions:(NSArray*)optionsName;

@end
