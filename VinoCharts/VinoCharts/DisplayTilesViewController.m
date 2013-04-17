//
//  DisplayTilesViewController.m
//  VinoCharts
//
//  Created by Hendy Chua on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DisplayTilesViewController.h"

@interface DisplayTilesViewController ()

@end

@implementation DisplayTilesViewController

- (void)fillUpTiles {
    // the scrollable height is determined by the number of rows
    
    int numRows = [self.modelsRepresentationArray count]/NUM_TILES_IN_A_ROW;
    int width = self.view.frame.size.width; // we don't want horizontal scrolling
    int scrollableHeight = ((numRows+0.8)*[TileViewController getTileImage].size.height) + ((numRows+2)*TILE_VERTICAL_PADDING);
    
    [self.tilesDisplayArea setContentSize:CGSizeMake(width, scrollableHeight)];
    
    for (UIView *v in self.tilesDisplayArea.subviews) {
        [v removeFromSuperview];
    }
    
    // tiling them
    int i = 0;
    for (TileViewController *t in self.modelsRepresentationArray) {
        t.tileImageView.frame = CGRectMake(TILE_HORIZONTAL_PADDING
                                           + (t.tileImageView.frame.size.width*(i%NUM_TILES_IN_A_ROW))
                                           + (TILE_HORIZONTAL_PADDING*(i%NUM_TILES_IN_A_ROW)),
                                           
                                           TILE_VERTICAL_PADDING
                                           + (t.tileImageView.frame.size.height*(i/NUM_TILES_IN_A_ROW))
                                           + (TILE_VERTICAL_PADDING*(i/NUM_TILES_IN_A_ROW)),
                                           
                                           t.tileImageView.frame.size.width,
                                           t.tileImageView.frame.size.height);
        [self.tilesDisplayArea addSubview:t.tileImageView];
        i += 1;
    }
}

-(void)finishDeletingMode {
    for (int i=0; i<[self.modelsRepresentationArray count]; i++) {
        TileViewController *t = (TileViewController*)[self.modelsRepresentationArray objectAtIndex:i];
        [t removeDeleteCrossIcon];
    }
}

-(void)showDeleteButtonOnTiles {
    for (int i=0; i<[self.modelsRepresentationArray count]; i++) {
        TileViewController *t = (TileViewController*)[self.modelsRepresentationArray objectAtIndex:i];
        [t displayDeleteCrossIcon];
    }
}

-(void)reloadModelsArrayAndRepresentationArray {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)];
}

-(void)setRightBarButtonToDeletingMode {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)];
}

- (void)setRightBarButtonToDefaultMode {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass.", NSStringFromSelector(_cmd)];
}

- (void)viewDidUnload {
    [self setTilesDisplayArea:nil];
    [super viewDidUnload];
}
@end
