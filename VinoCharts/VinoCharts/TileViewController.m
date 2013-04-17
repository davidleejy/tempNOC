//
//  TileViewController.m
//  VinoCharts
//
//  Created by Hendy Chua on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "TileViewController.h"

@interface TileViewController ()

@end

@implementation TileViewController

@synthesize delegate;

- (void)editSelectedTile:(UITapGestureRecognizer *)gesture {
    // subclass to override but not compulsory
}

-(void)selectTile:(UITapGestureRecognizer *)gesture {
    // let the subclass handle it. as it might be a projected selected, a survey, a feedback etc.
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)];
}

-(void)deleteThisTile:(UITapGestureRecognizer *)gesture {
    // let the subclass handle it. as it might be a projected deleted, a survey, a feedback etc.
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)];}

-(void)notifyDelegateLongPress:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.delegate longPressActivated];
    }
}

-(void)displayDeleteCrossIcon {
    if (tileState == VIEW_STATE) {
        tileState = DELETE_STATE;
        self.crossButton = [[UIImageView alloc] initWithImage:[TileViewController getCrossIcon]];
        self.crossButton.frame = CGRectMake(0, 0, 40, 40);
        self.crossButton.center = CGPointMake(self.tileImageView.frame.origin.x, self.tileImageView.frame.origin.y);
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteThisTile:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [self.crossButton addGestureRecognizer:tapRecognizer];
        
        [self.crossButton setUserInteractionEnabled:YES];
        
        [self.tileImageView.superview addSubview:self.crossButton];
    }
}

-(void)removeDeleteCrossIcon {
    if (tileState == DELETE_STATE) {
        tileState = VIEW_STATE;
        [self.crossButton removeFromSuperview];
    }
}

+(UIImage*)getTileImage {
    UIImage *image = [UIImage imageNamed:@"tile.png"];
    return image;
}

+(UIImage*)getCrossIcon {
    UIImage *image = [UIImage imageNamed:@"cross.png"];
    return image;
}

-(void)addTapAndLongPressGestureOnTile {
    // adding gesture recognizer
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editSelectedTile:)];
    [doubleTapRecognizer setNumberOfTapsRequired:2];
    [self.tileImageView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTile:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [tapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    [self.tileImageView addGestureRecognizer:tapRecognizer];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(notifyDelegateLongPress:)];
    [longPress setMinimumPressDuration:0.7f];
    [self.tileImageView addGestureRecognizer:longPress];
    
    [self.tileImageView setUserInteractionEnabled:YES];
}


@end
