//
//  DiagramOverviewViewController.m
//  VinoCharts
//
//  Created by Hendy Chua on 8/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DiagramOverviewViewController.h"

@interface DiagramOverviewViewController ()

@end

@implementation DiagramOverviewViewController

@synthesize diagram;

-(id)initWithModel:(Diagram*)diag Delegate:(id)d {
    self = [super init];
    if (self != nil) {
        tileState = VIEW_STATE;
        self.diagram = diag;
        self.delegate = d;
        
        UIImage *image = [DiagramOverviewViewController getTileImage];
        
        self.tileImageView = [[UIImageView alloc] initWithImage:image];
        
        // displaying title of diagram
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.tileImageView.bounds.origin.x+TITLE_X_PADDING,
                                                                    self.tileImageView.bounds.origin.y+TITLE_Y_PADDING,
                                                                    TITLE_LABEL_WIDTH,
                                                                    TITLE_LABEL_HEIGHT)];
        [self.titleLabel setText:self.diagram.title];
        [self.titleLabel setTextColor:[UIColor grayColor]];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        
        [self.tileImageView addSubview:self.titleLabel];
        
        [self addTapAndLongPressGestureOnTile];
    }
    return self;
}

-(void)selectTile:(UITapGestureRecognizer *)gesture {
    // tells the delegate this diagram is selected so that the delegate can proceed.
    [self.delegate tileSelected:self.diagram];
}

-(void)deleteThisTile:(UITapGestureRecognizer *)gesture {
    [self.delegate deleteTile:self.diagram];
}

// overriding the superclass's getTileImage to provide a custom image
+(UIImage*)getTileImage {
    UIImage *image = [UIImage imageNamed:@"diagramicon.png"];
    return image;
}

@end
