//
//  PreviewDiagramViewController.h
//  VinoCharts
//
//  Created by Ang Civics on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DropboxImageViewController.h"
#import "DropboxViewController.h"
#import "CoreDataConstant.h"
#import <QuartzCore/QuartzCore.h>

@interface PreviewDiagramViewController : DropboxImageViewController


@property NSString* title;
@property NSString* projectTitle;

-(id)initWithImage:(UIImage*)image Title:(NSString*)title ProjectTitle:(NSString*)projectTitle;

@end
