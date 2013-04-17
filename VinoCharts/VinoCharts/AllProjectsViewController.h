//
//  AllProjectsViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 24/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "Model.h"
#import "UserOptionsLoadPicker.h"
#import "ProjectOverviewViewController.h"
#import "CreateProjectViewController.h"
#import "SingleProjectViewController.h"
#import "DisplayTilesViewController.h"
#import "DropboxViewController.h"

#import "PreviewDiagramViewController.h"

@interface AllProjectsViewController : DisplayTilesViewController <UserOptionsLoadPickerDelegate, TileControllerDelegate, CreateProjectViewDelegate, ModelDelegate, DropboxDelegate> {
    UserOptionsLoadPicker *optionsPicker;
    UIPopoverController *optionsPickerPopOver;
    Project *selectedProject;
}

@property (nonatomic) UserOptionsLoadPicker *optionsPicker;
@property (nonatomic) UIPopoverController *optionsPickerPopOver;

//for core data
@property Model* model;
@property (nonatomic)UIActivityIndicatorView *indicator;

@end
