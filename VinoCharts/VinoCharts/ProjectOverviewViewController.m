//
//  ProjectOverviewViewController.m
//  VinoCharts
//
//  Created by Hendy Chua on 24/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ProjectOverviewViewController.h"

@interface ProjectOverviewViewController ()

@end

@implementation ProjectOverviewViewController

@synthesize project;

-(id)initWithModel:(Project*)p Delegate:(id)d {
    self = [super init];
    
    if (self != nil) {
        tileState = VIEW_STATE;
        self.project = p;
        self.delegate = d;
        UIImage *image = [ProjectOverviewViewController getTileImage];
        
        self.tileImageView = [[UIImageView alloc] initWithImage:image];
    
        // displaying title of project
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tileImageView.bounds.origin.x+TITLE_X_PADDING,
                                                                    self.tileImageView.bounds.origin.y+TITLE_Y_PADDING,
                                                                    TITLE_LABEL_WIDTH,
                                                                    TITLE_LABEL_HEIGHT)];
        [self.titleLabel setText:self.project.title];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    
        //displaying details of project
        self.detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tileImageView.bounds.origin.x+TITLE_X_PADDING,
                                                                      self.tileImageView.bounds.origin.y+(TITLE_Y_PADDING)+TITLE_LABEL_HEIGHT,
                                                                      TITLE_LABEL_WIDTH,
                                                                      self.tileImageView.frame.size.height-self.tileImageView.bounds.origin.y+(TITLE_Y_PADDING)+TITLE_LABEL_HEIGHT)];
        NSString *details = self.project.details;
        if ([details length] > DESC_LENGTH) {
            details = [[details substringToIndex:DESC_LENGTH+1] stringByAppendingString:@"..."];
        }
        [self.detailsLabel setText:details];
        [self.detailsLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [self.detailsLabel setLineBreakMode:UILineBreakModeWordWrap];
        [self.detailsLabel setNumberOfLines:0];
        [self.detailsLabel setBackgroundColor:[UIColor clearColor]];
        [self.detailsLabel sizeToFit];
    
        [self.tileImageView addSubview:self.titleLabel];
        [self.tileImageView addSubview:self.detailsLabel];
        
        [self addTapAndLongPressGestureOnTile];
    }
    
    return self;
}

-(void)selectTile:(UITapGestureRecognizer *)gesture {
    // tells the delegate this project is selected so that the delegate can proceed.
    // e.g. move to the next view to see the project in detail.
    [self.delegate tileSelected:self.project];
}

-(void)deleteThisTile:(UITapGestureRecognizer *)gesture {
    [self.delegate deleteTile:self.project];
}

// overriding the superclass's getTileImage to provide a custom image
+(UIImage*)getTileImage {
    UIImage *image = [UIImage imageNamed:@"projectfolder.png"];
    return image;
}

@end
