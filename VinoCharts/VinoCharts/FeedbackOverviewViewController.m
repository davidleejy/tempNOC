//
//  FeedbackOverviewViewController.m
//  VinoCharts
//
//  Created by Hendy Chua on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FeedbackOverviewViewController.h"

@interface FeedbackOverviewViewController ()

@end

@implementation FeedbackOverviewViewController

@synthesize feedback;

-(id)initWithModel:(Feedback*)f Delegate:(id)d {
    self = [super init];
    if (self != nil) {
        tileState = VIEW_STATE;
        self.feedback = f;
        self.delegate = d;
        
        UIImage *image = [FeedbackOverviewViewController getTileImage];
        
        self.tileImageView = [[UIImageView alloc] initWithImage:image];
        
        // displaying title of feedback
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tileImageView.bounds.origin.x+TITLE_X_PADDING,
                                                                    self.tileImageView.bounds.origin.y+TITLE_Y_PADDING,
                                                                    TITLE_LABEL_WIDTH,
                                                                    TITLE_LABEL_HEIGHT)];
        [self.titleLabel setText:self.feedback.title];
        [self.titleLabel setTextColor:[UIColor grayColor]];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        
        //displaying details of feedback
        self.detailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tileImageView.bounds.origin.x+TITLE_X_PADDING,
                                                                      self.tileImageView.bounds.origin.y+(TITLE_Y_PADDING*2)+TITLE_LABEL_HEIGHT,
                                                                      TITLE_LABEL_WIDTH,
                                                                      self.tileImageView.frame.size.height-self.tileImageView.bounds.origin.y+(TITLE_Y_PADDING*2)+TITLE_LABEL_HEIGHT)];
        NSString *details = [NSString stringWithFormat:@"%d questions completed", self.feedback.questionArray.count];
        if ([details length] > DESC_LENGTH) {
            details = [[details substringToIndex:DESC_LENGTH+1] stringByAppendingString:@"..."];
        }
        [self.detailsLabel setText:details];
        [self.detailsLabel setFont:[UIFont systemFontOfSize:10.0f]];
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
    // tells the delegate this feedback is selected so that the delegate can proceed.
    [self.delegate tileSelected:self.feedback];
}

-(void)deleteThisTile:(UITapGestureRecognizer *)gesture {
    [self.delegate deleteTile:self.feedback];
}

// overriding the superclass's getTileImage to provide a custom image
+(UIImage*)getTileImage {
    UIImage *image = [UIImage imageNamed:@"feedbackicon.png"];
    return image;
}

@end
