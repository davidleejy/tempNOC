//
//  DisplayTilesViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TileViewController.h"
#import "Constants.h"

@interface DisplayTilesViewController : UIViewController

@property (nonatomic,strong) NSMutableArray *modelsArray;
@property (nonatomic,strong) NSMutableArray *modelsRepresentationArray;
@property (strong, nonatomic) IBOutlet UIScrollView *tilesDisplayArea;

- (void)fillUpTiles;

-(void)finishDeletingMode;
-(void)showDeleteButtonOnTiles;

-(void)reloadModelsArrayAndRepresentationArray;
-(void)setRightBarButtonToDeletingMode;
-(void)setRightBarButtonToDefaultMode;

@end
