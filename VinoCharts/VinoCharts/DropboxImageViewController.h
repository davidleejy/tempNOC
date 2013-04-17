//
//  DropboxImageViewController.h
//  VinoCharts
//
//  Created by Ang Civics on 2/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropboxImageViewController.h"

@interface DropboxImageViewController : UIViewController<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property NSString* path;
@property UIImageView* imageView;

- (id)initWithPath:(NSString*)path;

@end
