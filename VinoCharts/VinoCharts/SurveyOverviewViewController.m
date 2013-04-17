//
//  SurveyOverviewViewController.m
//  VinoCharts
//
//  Created by Hendy Chua on 31/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SurveyOverviewViewController.h"

@interface SurveyOverviewViewController ()

@end

@implementation SurveyOverviewViewController

@synthesize survey;

-(id)initWithModel:(Survey*)s Delegate:(id)d {
    self = [super init];
    if (self != nil) {
        tileState = VIEW_STATE;
        self.survey = s;
        self.delegate = d;
        
        UIImage *image = [SurveyOverviewViewController getTileImage];
        
        self.tileImageView = [[UIImageView alloc] initWithImage:image];
        
        // displaying title of survey
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tileImageView.bounds.origin.x+TITLE_X_PADDING,
                                                                    self.tileImageView.bounds.origin.y+TITLE_Y_PADDING,
                                                                    TITLE_LABEL_WIDTH,
                                                                    TITLE_LABEL_HEIGHT)];
        [self.titleLabel setText:self.survey.title];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        
        //displaying details of project
        self.detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tileImageView.bounds.origin.x+TITLE_X_PADDING,
                                                                      self.tileImageView.bounds.origin.y+(TITLE_Y_PADDING)+TITLE_LABEL_HEIGHT,
                                                                      TITLE_LABEL_WIDTH,
                                                                      self.tileImageView.frame.size.height-self.tileImageView.bounds.origin.y+(TITLE_Y_PADDING)+TITLE_LABEL_HEIGHT)];
        NSString *details = self.survey.detail;
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
    // tells the delegate this survey is selected so that the delegate can proceed.
    [self.delegate tileSelected:self.survey];
}

-(void)deleteThisTile:(UITapGestureRecognizer *)gesture {
    [self.delegate deleteTile:self.survey];
}

-(void)editSelectedTile:(UITapGestureRecognizer *)gesture {
    [self.delegate tileToBeEdited:self.survey];
}

// overriding the superclass's getTileImage to provide a custom image
+(UIImage*)getTileImage {
    UIImage *image = [UIImage imageNamed:@"surveyicon.png"];
    return image;
}

@end
