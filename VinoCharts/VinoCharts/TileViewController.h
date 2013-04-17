//
//  TileViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 9/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

#define VIEW_STATE 0
#define DELETE_STATE 1

@protocol TileControllerDelegate <NSObject>

-(void)tileSelected:(id)model;
-(void)longPressActivated;
-(void)deleteTile:(id)model;

@optional
-(void)tileToBeEdited:(id)model;

@end;

@interface TileViewController : UIViewController {
    id<TileControllerDelegate> delegate;
    int tileState;
}

@property (nonatomic, strong) UIImageView *tileImageView;
@property (nonatomic, strong) UIImageView *crossButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailsLabel;
@property (nonatomic) id delegate;

-(void)editSelectedTile:(UITapGestureRecognizer *)gesture;
-(void)selectTile:(UITapGestureRecognizer *)gesture;
-(void)deleteThisTile:(UITapGestureRecognizer *)gesture;
-(void)notifyDelegateLongPress:(UILongPressGestureRecognizer *)gesture;
-(void)displayDeleteCrossIcon;
-(void)removeDeleteCrossIcon;

+(UIImage*)getTileImage;
+(UIImage*)getCrossIcon;

-(void)addTapAndLongPressGestureOnTile;

@end
