//
//  EditDiagramController+EditDiagramController_MassSelectNotes.m
//  VinoCharts
//
//  Created by Lee Jian Yi David on 4/10/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "EditDiagramController+MassSelectNotes.h"
#import "EditDiagramController.h"

#import "lineSegment.h"
#import "MathHelper.h"
#import "ViewHelper.h"

@implementation EditDiagramController (MassSelectNotes)


-(void) attachGestureRecognizersForMassSelectionOfNotes{
    // 3 ~ 7 fingers required.
    for (int touches = 3; touches<=7; touches++) {
        UITapGestureRecognizer *multiTapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(massSelectNotes:)];
        [multiTapRecog setNumberOfTouchesRequired:touches];
        [self.view addGestureRecognizer:multiTapRecog];
    }
}


-(void)massSelectNotes:(UITapGestureRecognizer*)recognizer{
    
    [self.canvasWindow setScrollEnabled:NO]; //disable scrolling
    
    //TODO reset. Shift these to reset
    self.lineSegmentsOfConvexHull = [[NSMutableArray alloc]init];
    self.notesBeingMassSelected = [[NSMutableArray alloc]init];
    
    CGRect visiblePortionOfCanvas = [ViewHelper visibleRectOf:self.canvas thatIsSubViewOf:self.canvasWindow withParentMostView:self.view];
    
    UIGraphicsBeginImageContext(visiblePortionOfCanvas.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    uint touchCount = recognizer.numberOfTouches; //get number of fingers
    
    //Make an array of NSValue CGPoints corresponding to finger coordinates.
    //These NSValue CGPoints are "in _canvas" layer.
    NSMutableArray * arrayOfFingerCoord = [[NSMutableArray alloc]init];
    for (int i=0; i<touchCount; i++) {
        CGPoint fingerCoord = [recognizer locationOfTouch:i inView:self.canvas];
        NSValue* fingerCoordNSVal = [NSValue valueWithCGPoint:fingerCoord];
        [arrayOfFingerCoord addObject:fingerCoordNSVal];
    }
    
    //Place the extreme point at index 0.
    arrayOfFingerCoord = [MathHelper orderMinimumYPointToBeFirstElementOf:arrayOfFingerCoord];
    
    //Radial sort the array.
    NSArray* sortedArrayOfFingerCoords = [MathHelper radialSort:arrayOfFingerCoord WithExtremePointAtIndex:0];

    //Find points that are on the perimeter of the convex hull.
    NSMutableArray* convexHull = [MathHelper threeCoinAlgorithm:sortedArrayOfFingerCoords];//3 coin algorithm
    
    //Build an array of line segments of the convex hull.
    double iniX,iniY;
    for (int i=0; i<convexHull.count; i++) {
        CGPoint fingerCoord = [(NSValue*)[convexHull objectAtIndex:i] CGPointValue];
        CGPoint fingerCoord2 = [(NSValue*)[convexHull objectAtIndex:(i+1)%convexHull.count] CGPointValue];
        
        //drawing on self.canvas
        if (i == 0) {
            iniX = fingerCoord.x; iniY= fingerCoord.y;
            CGContextMoveToPoint(context,fingerCoord.x,fingerCoord.y);
        }
        else if (i == convexHull.count-1){
            CGContextAddLineToPoint(context,fingerCoord.x,fingerCoord.y);
            CGContextAddLineToPoint(context,iniX,iniY);
        }
        else {
            
            CGContextAddLineToPoint(context,fingerCoord.x,fingerCoord.y);
        }
        [self.lineSegmentsOfConvexHull addObject:[[lineSegment alloc]initWith:fingerCoord :fingerCoord2]];
        NSLog(@"There are %d line segments",self.lineSegmentsOfConvexHull.count);
    }
    
    
    
    
    //Stroke perimeter of hull.
    CGContextSetStrokeColorWithColor(context,[ViewHelper invColorOf:self.canvas.backgroundColor].CGColor);
    CGContextStrokePath(context);
//    CGContextFillPath(context);
    UIImage *_newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *n = [[UIImageView alloc]initWithImage:_newImage];
    [self.canvas addSubview:n];
    [n setAlpha:0.5];
    [n performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
//
//    //Variables for forming overlay.
//    double overlayMinX,overlayMinY,overlayMaxX,overlayMaxY;
//    
//    //Keep track of no. of elements in _notesBeingMassSelected.
//    int notesBeingMassSelectedCount = 0;
//    
//    //Determine which notes are inside convex hull.
//    for (int i=0; i<_stuffOnPaper.count; i++) { //Iterate through each note
//        
//        int intersectionCount = 0; //reset
//        
//        for (int s=0; s<_lineSegmentsOfConvexHull.count; s++) {//For each note, count the no. of intersections its plumbline has with the line segments of the convex hull.
//            
//            if ([MathHelper plumblineFrom:((UIView*)[_stuffOnPaper objectAtIndex:i]).center
//                    intersectsLineSegment:[_lineSegmentsOfConvexHull objectAtIndex:s]] ) {
//                intersectionCount++;
//            }
//        }// end for each line segment
//        
//        if (intersectionCount%2 == 1) { //Implies inside convex hull.
//            // Disable user interaction.
//            // Remove note from physics engine.
//            [((UIView*)[_stuffOnPaper objectAtIndex:i]) setBackgroundColor:[UIColor blueColor]];
//            [((UIView*)[_stuffOnPaper objectAtIndex:i]) setAlpha:0.5];
//            // Put these notes into an array that stores all notes that are mass selected.
//            [_notesBeingMassSelected addObject:[_stuffOnPaper objectAtIndex:i]];
//            ++notesBeingMassSelectedCount;
//            
//            NSLog(@"no. of notes being mass selected %d.  counter %d",_notesBeingMassSelected.count,notesBeingMassSelectedCount);
//            
//            // Determine the boundaries of the overlay that is to snugly wrap the notes.
//            if (notesBeingMassSelectedCount == 1) { //Only one note being mass selected, initialise boundaries of overlay.
//                overlayMinX = ((UIView*)[_notesBeingMassSelected objectAtIndex:0]).frame.origin.x;
//                overlayMaxX = ((UIView*)[_notesBeingMassSelected objectAtIndex:0]).frame.origin.x;
//                overlayMinY = ((UIView*)[_notesBeingMassSelected objectAtIndex:0]).frame.origin.y;
//                overlayMaxY = ((UIView*)[_notesBeingMassSelected objectAtIndex:0]).frame.origin.y;
//            }
//            else { //Determine the boundaries of the overlay by comparing each note that is added.
//                double nX = ((UIView*)[_notesBeingMassSelected objectAtIndex:notesBeingMassSelectedCount-1]).frame.origin.x;
//                double nY = ((UIView*)[_notesBeingMassSelected objectAtIndex:notesBeingMassSelectedCount-1]).frame.origin.y;
//                if (nX > overlayMaxX) {
//                    overlayMaxX = nX;
//                }
//                else if (nX < overlayMinX) {
//                    overlayMinX = nX;
//                }
//                else
//                    ;//do nth
//                
//                if (nY > overlayMaxY) {
//                    overlayMaxY = nY;
//                }
//                else if (nY < overlayMinY) {
//                    overlayMinY = nY;
//                }
//                else
//                    ;//do nth
//            }
//        }
//        
//    }//End for each note.
//    
//    // Quit if there are 0 notes being mass selected.
//    if (notesBeingMassSelectedCount == 0) {
//        return;
//    }
//    
//    /* Create an overlay for all notes being selected.
//     ** This overlay will snugly wrap the notes being mass selected.
//     */
//    UIView* overlay = [[UIView alloc]initWithFrame:CGRectMake(overlayMinX,
//                                                              overlayMinY,
//                                                              (overlayMaxX-overlayMinX)+10,
//                                                              (overlayMaxY-overlayMinY)+10)];
//    [overlay setAlpha:0.3];
//    [overlay setBackgroundColor:[UIColor yellowColor]];
//    [_canvas addSubview:overlay];
//    
//    //Attach gesture recognizer
//    UIPanGestureRecognizer *panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOverlayHoldingABunchOfNotes:)];
//    [overlay addGestureRecognizer:panRecog];
//    
//    //Keep this overlay in an array since there can be many mass selections at once.
//    [_massSelectOverlayViews addObject:overlay];
    
    
    [self.canvasWindow setScrollEnabled:YES]; //Reenable scrolling.
}



@end
