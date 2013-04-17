//
//  ViewHelper.m
//  Game
//
//  Created by Lee Jian Yi David on 3/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ViewHelper.h"

@implementation ViewHelper

+ (UIView*) embedText:(NSString*)txt
         WithFrame:(CGRect)frame
         TextColor:(UIColor*)color
      DurationSecs:(double)t
                In:(UIView*)view1
{
    UILabel *lbl = [[UILabel alloc]init];
    [lbl setFrame:frame];
    [lbl setText:txt];
    [lbl setAdjustsFontSizeToFitWidth:YES];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setTextColor:color];
    [view1 addSubview:lbl];
    
    if (t <= 0.0) {
        return lbl;
    }
    else // lbl will remove itself from view1 after t seconds.
        [lbl performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:t];
    
    return lbl;
}


+(UIView*)embedMark:(CGPoint)coord
     WithColor:(UIColor*)color
  DurationSecs:(double)t
            In:(UIView*)view1
{
    UIView *mark = [[UIView alloc]initWithFrame:CGRectMake(coord.x, coord.y, 5, 5)];
    [mark setBackgroundColor:color];
    [view1 addSubview:mark];
    
    if (t <= 0.0) {
        return mark;
    }
    else // mark will remove itself from view1 after t seconds.
        [mark performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:t];
    
    return mark;
}


+(UIView*)embedRect:(CGRect)frame
          WithColor:(UIColor*)color
       DurationSecs:(double)t
                 In:(UIView*)view1
{
    UIView *rect = [[UIView alloc]initWithFrame:frame];
    [rect setBackgroundColor:color];
    [view1 addSubview:rect];
    
    if (t <= 0.0) {
        return rect;
    }
    else // mark will remove itself from view1 after t seconds.
        [rect performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:t];
    
    return rect;
}


+(UIColor*)invColorOf:(UIColor*)aColor{
    
    // White and black color are special cases.
    if ([aColor isEqual:[UIColor whiteColor]]) {
        return [UIColor blackColor];
    }
    
    if ([aColor isEqual:[UIColor blackColor]]) {
        return [UIColor whiteColor];
    }
    // End of special cases.
    
    const CGFloat *componentColors = CGColorGetComponents(aColor.CGColor);
    
    UIColor *invColor = [[UIColor alloc] initWithRed:(1.0 - componentColors[0])
                                               green:(1.0 - componentColors[1])
                                                blue:(1.0 - componentColors[2])
                                               alpha:componentColors[3]];
    return invColor;
}

+(CGRect)centeredFrameForScrollViewWithNoContentInset:(UIScrollView *)sV AndWithContentView:(UIView *)cV {
    CGSize boundsSize = sV.bounds.size;
    CGRect frameToCenter = cV.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    return frameToCenter; //apply this to cV!
}



+(CGRect)visibleRectOf:(UIView*)aViewInSV
       thatIsSubViewOf:(UIScrollView*)sV
    withParentMostView:(UIView*)parentView
{
    
    CGRect visibleRect;
    visibleRect.origin = sV.contentOffset;
    visibleRect.size = sV.contentSize;
    visibleRect.origin.x /= sV.zoomScale;
    visibleRect.origin.y /= sV.zoomScale;
    
    if (sV.contentSize.width > sV.bounds.size.width) {
        // Horizontally, there is content off-screen.
        // The algo in this block finds the top right visible point of _canvas. And uses this point to find the width of the visible area of the canvas (w.r.t _canvas).
        //
        //
        // Convert top right visible point of _canvas into equivalent point in self.view (layer "closest" to user)
        CGPoint inSelfViewTL = [parentView convertPoint:visibleRect.origin fromView:aViewInSV];
        // In self.view, find the point equivalent to top right visible point of _canvas.
        CGPoint inSelfViewTR = CGPointMake(inSelfViewTL.x+sV.frame.size.width, inSelfViewTL.y);
        // Convert this point to an equivalent point in _canvas.
        CGPoint inCanvasTR = [aViewInSV convertPoint:inSelfViewTR fromView:parentView];
        // Compute visible wdith in canvas w.r.t _canvas.
        visibleRect.size.width = inCanvasTR.x - visibleRect.origin.x;
    }
    else {
        visibleRect.size.width /= sV.zoomScale;
    }
    
    if (sV.contentSize.height > sV.bounds.size.height) {
        // Vertically, there is content off-screen.
        // The algo in this block finds the bottom left visible point of _canvas. And uses this point to find the height of the visible area of the canvas (w.r.t _canvas).
        //
        //
        // Convert top right visible point of _canvas into equivalent point in self.view (layer "closest" to user)
        CGPoint inSelfViewTL = [parentView convertPoint:visibleRect.origin fromView:aViewInSV];
        // In self.view, find the point equivalent to bottom left visible point of _canvas.
        CGPoint inSelfViewBL = CGPointMake(inSelfViewTL.x, inSelfViewTL.y+sV.frame.size.height);
        // Convert this point to an equivalent point in _canvas.
        CGPoint inCanvasBL = [aViewInSV convertPoint:inSelfViewBL fromView:parentView];
        // Compute visible height in canvas w.r.t _canvas.
        visibleRect.size.height = inCanvasBL.y - visibleRect.origin.y;
    }
    else {
        visibleRect.size.height /= sV.zoomScale;
    }
    
    return visibleRect;
}


@end
