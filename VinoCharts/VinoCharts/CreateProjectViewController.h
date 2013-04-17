//
//  CreateProjectViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 24/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Project.h"
#import "CoreDataConstant.h"
#import "Model.h"

@protocol CreateProjectViewDelegate

-(void)newProjectCreated:(Project *)project;

@end

@interface CreateProjectViewController : UIViewController <UITextFieldDelegate> {
    id<CreateProjectViewDelegate> delegate;
}

- (IBAction)dismissModal:(id)sender;
- (IBAction)createNewProject:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *detailsTextView;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;

@property (nonatomic) id<CreateProjectViewDelegate> delegate;

//for core data
//@property NSManagedObjectContext* context;
//@property Model* model;

@end
