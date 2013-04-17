//
//  convexHullTestController.m
//  VinoCharts
//
//  Created by Lee Jian Yi David on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "convexHullTestController.h"
#import "MathHelper.h"
#import "DebugHelper.h"
#import "ViewHelper.h"
#import "lineSegment.h"

@interface convexHullTestController ()

@end

@implementation convexHullTestController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    GridView *g = [[GridView alloc]initWithFrame:CGRectMake(100, 100, 100, 100) Step:30 LineColor:[UIColor redColor]];
    //    [self.view setBackgroundColor:[UIColor whiteColor]];
    //    [self.view addSubview:g];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    

    
    //    UITapGestureRecognizer *multiTapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twopts:)];
    //    [multiTapRecog setNumberOfTouchesRequired:2];
    //    [self.view addGestureRecognizer:multiTapRecog];
    
    
    //populating scrollview
    _canvas = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Balancoire.png"]];
    [_canvas setFrame:CGRectMake(0, 0, 2545, 3159)];
    [_sv setContentSize:_canvas.frame.size];
    [_sv addSubview:_canvas];
    [_sv setZoomScale:0.98 animated:NO];
    [_sv setZoomScale:1 animated:YES];
    [_sv setUserInteractionEnabled:YES];
    [_canvas setUserInteractionEnabled:YES];
    
    [DebugHelper printUIScrollView:_sv :@"scrollview"];
    
    [self populateCanvas];
    
    UIView* xAxis = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 500, 3)];
    [xAxis setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:xAxis];
    [self.view sendSubviewToBack:xAxis];
    
    
        
    //Initialise array that will store overlay views for mass selected notes
    _massSelectOverlayViews = [[NSMutableArray alloc]init];
    
    //ADDING GESTURE RECOGNIZERS
    
    for (int t = 3; t<8; t++) {
        UITapGestureRecognizer *multiTapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(massSelectNotes:)];
        [multiTapRecog setNumberOfTouchesRequired:t];
        [self.view addGestureRecognizer:multiTapRecog];
        //        UITapGestureRecognizer *multiTapRecog2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(massSelectNotes:)];
        //        [multiTapRecog2 setNumberOfTouchesRequired:t];
        //        [_sv addGestureRecognizer:multiTapRecog2];
        //        UITapGestureRecognizer *multiTapRecog3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(massSelectNotes:)];
        //        [multiTapRecog3 setNumberOfTouchesRequired:t];
        //        [iVSJ addGestureRecognizer:multiTapRecog3];
    }
    
    
    //linesegment test
    lineSegment* g = [[lineSegment alloc]initWith:CGPointMake(5, 10) :CGPointMake(20, 20)];
    [g NSLogWithPrefixText:@"g"];
    
}

-(void)twopts:(UITapGestureRecognizer*)recognizer{
    uint touchCount = recognizer.numberOfTouches; //get number of fingers
    
    //Make an array of finger coordinates.
    NSMutableArray * arrayOfFingerCoord = [[NSMutableArray alloc]init];
    for (int i=0; i<touchCount; i++) {
        CGPoint fingerCoord = [recognizer locationOfTouch:i inView:self.view];
        NSValue* fingerCoordNSVal = [NSValue valueWithCGPoint:fingerCoord];
        [arrayOfFingerCoord addObject:fingerCoordNSVal];
    }
    
    //Place the y extreme point at index 0.
    arrayOfFingerCoord = [MathHelper orderMinimumYPointToBeFirstElementOf:arrayOfFingerCoord];
    
    //Radial sort the array. Radial scan is from left to right. (From second quadrant to first quadrant)
    NSArray* sortedArrayOfFingerCoords = [MathHelper radialSort:arrayOfFingerCoord WithExtremePointAtIndex:0];
    
    //visually marking sortedArrayOfFingerCoords
    for (int i=0; i<sortedArrayOfFingerCoords.count; i++) {
        CGPoint fingerCoord = [(NSValue*)[sortedArrayOfFingerCoords objectAtIndex:i] CGPointValue];
        [ViewHelper embedMark:CGPointMake(fingerCoord.x+10, fingerCoord.y+10) WithColor:[UIColor blueColor] DurationSecs:1.0f In:self.view];
        [ViewHelper embedText:[NSString stringWithFormat:@"%d",i] WithFrame:CGRectMake(fingerCoord.x, fingerCoord.y, 10, 20) TextColor:[UIColor blueColor] DurationSecs:3 In:self.view];
        double rads = [MathHelper radiansOfLine:[(NSValue*)[sortedArrayOfFingerCoords objectAtIndex:0] CGPointValue] :[(NSValue*)[sortedArrayOfFingerCoords objectAtIndex:i] CGPointValue]];
        [ViewHelper embedText:[NSString stringWithFormat:@"rads w.r.t. x-axis %.2f",rads] WithFrame:CGRectMake(fingerCoord.x, fingerCoord.y, 100, 20) TextColor:[UIColor blueColor] DurationSecs:3 In:self.view];
    }
    
    
}

-(void)massSelectNotes:(UITapGestureRecognizer*)recognizer{
    
        _lineSegmentsOfConvexHull = [[NSMutableArray alloc]init];
        _notesBeingMassSelected = [[NSMutableArray alloc]init];
    
    
    NSLog(@"multi tap detected!!!");
    [DebugHelper printUIScrollView:_sv :@"scrollview"];
    [DebugHelper printCGRect:recognizer.view.frame :@"recog.view.frame"];
    [DebugHelper printCGRect:recognizer.view.bounds :@"recog.view.bounds"];
    
    UIGraphicsBeginImageContext(recognizer.view.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    uint touchCount = recognizer.numberOfTouches; //get number of fingers
    
    
    
    //Make an array of finger coordinates.
    NSMutableArray * arrayOfFingerCoord = [[NSMutableArray alloc]init];
    for (int i=0; i<touchCount; i++) {
        CGPoint fingerCoord = [recognizer locationOfTouch:i inView:self.view];
        NSValue* fingerCoordNSVal = [NSValue valueWithCGPoint:fingerCoord];
        [arrayOfFingerCoord addObject:fingerCoordNSVal];
    }
    
    //Place the extreme point at index 0.
    arrayOfFingerCoord = [MathHelper orderMinimumYPointToBeFirstElementOf:arrayOfFingerCoord];
    
    
    //Radial sort the array. Radial scan is from rads=0 to rads=2.0*M_PI (From first quadrant to second quadrant)
    NSArray* sortedArrayOfFingerCoords = [MathHelper radialSort:arrayOfFingerCoord WithExtremePointAtIndex:0];
    
    //visually marking sortedArrayOfFingerCoords
//    for (int i=0; i<sortedArrayOfFingerCoords.count; i++) {
//        CGPoint fingerCoord = [(NSValue*)[sortedArrayOfFingerCoords objectAtIndex:i] CGPointValue];
//        [ViewHelper embedMark:CGPointMake(fingerCoord.x+10, fingerCoord.y+10) WithColor:[UIColor blueColor] DurationSecs:1.0f In:self.view];
//        [ViewHelper embedText:[NSString stringWithFormat:@"%d",i] WithFrame:CGRectMake(fingerCoord.x, fingerCoord.y, 10, 20) TextColor:[UIColor blueColor] DurationSecs:3 In:self.view];
//    }
    
    
    NSMutableArray* convexHull = [MathHelper threeCoinAlgorithm:sortedArrayOfFingerCoords];//3 coin algorithm
    
    
    
    double iniX,iniY;
    for (int i=0; i<convexHull.count; i++) {
        CGPoint fingerCoord = [(NSValue*)[convexHull objectAtIndex:i] CGPointValue];
        CGPoint fingerCoord2 = [(NSValue*)[convexHull objectAtIndex:(i+1)%convexHull.count] CGPointValue];
        //        [ViewHelper embedMark:CGPointMake(fingerCoord.x+10, fingerCoord.y+10) WithColor:[UIColor redColor] DurationSecs:1.0f In:self.view];
        
        
        // Find out equivalent points on canvas
        CGPoint convexHullPt1OnCanvas = [self.view convertPoint:fingerCoord toView:_canvas];
        CGPoint convexHullPt2OnCanvas = [self.view convertPoint:fingerCoord2 toView:_canvas];
        [ViewHelper embedMark:convexHullPt1OnCanvas WithColor:[UIColor greenColor] DurationSecs:3 In:_canvas];
        
        //drawing on self.view.
        if (i == 0) {
            //            [ViewHelper embedMark:CGPointMake(fingerCoord.x+4, fingerCoord.y+4) WithColor:[UIColor blackColor] DurationSecs:1.0f In:self.view];
            
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
        //        [ViewHelper embedText:[NSString stringWithFormat:@"%d",i] WithFrame:CGRectMake(fingerCoord.x+12, fingerCoord.y+12, 10, 20) TextColor:[UIColor redColor] DurationSecs:3 In:self.view];
        
        
        //Shade convex hull area on _canvas.
        //stub TODO
        
        //Fill lineSegmentsOfConvexHull
        [_lineSegmentsOfConvexHull addObject:[[lineSegment alloc]initWith:convexHullPt1OnCanvas :convexHullPt2OnCanvas]];
        NSLog(@"There are %d line segments",_lineSegmentsOfConvexHull.count);
    }
    
//    CGContextStrokePath(context);
    
    
    //drwaing on self.view
    CGContextFillPath(context);
    UIImage *_newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *n = [[UIImageView alloc]initWithImage:_newImage];
    [self.view addSubview:n];
    [n setAlpha:0.5];
    [n performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2.5];
    
    //Variables for forming overlay.
    double overlayMinX,overlayMinY,overlayMaxX,overlayMaxY;
    
    //Keep track of no. of elements in _notesBeingMassSelected.
    int notesBeingMassSelectedCount = 0;
    
    //Determine which notes are inside convex hull.
    for (int i=0; i<_stuffOnPaper.count; i++) { //Iterate through each note
        
        int intersectionCount = 0; //reset
        
        for (int s=0; s<_lineSegmentsOfConvexHull.count; s++) {//For each note, count the no. of intersections its plumbline has with the line segments of the convex hull.
            
            if ([MathHelper plumblineFrom:((UIView*)[_stuffOnPaper objectAtIndex:i]).center
                    intersectsLineSegment:[_lineSegmentsOfConvexHull objectAtIndex:s]] ) {
                intersectionCount++;
            }
        }// end for each line segment
        
        if (intersectionCount%2 == 1) { //Implies inside convex hull.
            // Disable user interaction.
            // Remove note from physics engine.
            [((UIView*)[_stuffOnPaper objectAtIndex:i]) setBackgroundColor:[UIColor blueColor]];
            [((UIView*)[_stuffOnPaper objectAtIndex:i]) setAlpha:0.5];
            // Put these notes into an array that stores all notes that are mass selected.
            [_notesBeingMassSelected addObject:[_stuffOnPaper objectAtIndex:i]];
            ++notesBeingMassSelectedCount;
            
            NSLog(@"no. of notes being mass selected %d.  counter %d",_notesBeingMassSelected.count,notesBeingMassSelectedCount);
            
            // Determine the boundaries of the overlay that is to snugly wrap the notes.
            if (notesBeingMassSelectedCount == 1) { //Only one note being mass selected, initialise boundaries of overlay.
                overlayMinX = ((UIView*)[_notesBeingMassSelected objectAtIndex:0]).frame.origin.x;
                overlayMaxX = ((UIView*)[_notesBeingMassSelected objectAtIndex:0]).frame.origin.x;
                overlayMinY = ((UIView*)[_notesBeingMassSelected objectAtIndex:0]).frame.origin.y;
                overlayMaxY = ((UIView*)[_notesBeingMassSelected objectAtIndex:0]).frame.origin.y;
            }
            else { //Determine the boundaries of the overlay by comparing each note that is added.
                double nX = ((UIView*)[_notesBeingMassSelected objectAtIndex:notesBeingMassSelectedCount-1]).frame.origin.x;
                double nY = ((UIView*)[_notesBeingMassSelected objectAtIndex:notesBeingMassSelectedCount-1]).frame.origin.y;
                if (nX > overlayMaxX) {
                    overlayMaxX = nX;
                }
                else if (nX < overlayMinX) {
                    overlayMinX = nX;
                }
                else
                    ;//do nth
                
                if (nY > overlayMaxY) {
                    overlayMaxY = nY;
                }
                else if (nY < overlayMinY) {
                    overlayMinY = nY;
                }
                else
                    ;//do nth
            }
        }
        
    }//End for each note.
    
    // Quit if there are 0 notes being mass selected.
    if (notesBeingMassSelectedCount == 0) {
        return;
    }
    
    /* Create an overlay for all notes being selected.
    ** This overlay will snugly wrap the notes being mass selected.
    */
    UIView* overlay = [[UIView alloc]initWithFrame:CGRectMake(overlayMinX,
                                                              overlayMinY,
                                                              (overlayMaxX-overlayMinX)+10,
                                                              (overlayMaxY-overlayMinY)+10)];
    [overlay setAlpha:0.3];
    [overlay setBackgroundColor:[UIColor yellowColor]];
    [_canvas addSubview:overlay];
    
    //Attach gesture recognizer
    UIPanGestureRecognizer *panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panOverlayHoldingABunchOfNotes:)];
    [overlay addGestureRecognizer:panRecog];
    
    //Keep this overlay in an array since there can be many mass selections at once.
    [_massSelectOverlayViews addObject:overlay];
}


-(void)panOverlayHoldingABunchOfNotes:(UIPanGestureRecognizer*)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _sv.scrollEnabled = NO; //Disable scrolling
    }
    
    /* Gesture Recognizer is in progress...    */
    
    UIView* overlay = recognizer.view;
    
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    
    overlay.frame = CGRectMake(overlay.frame.origin.x+translation.x,
                               overlay.frame.origin.y+translation.y,
                               overlay.frame.size.width,
                               overlay.frame.size.height);
    
    for (int i = 0; i<_notesBeingMassSelected.count; i++) {
        
//        cpVect origBodyPos = ((Note*)((UITextView*)recognizer.view).delegate).body.pos;
//        
//        // Move only the body. Somehow the view is constantly updated by _displayLink. Wow.
//        ((Note*)((UITextView*)recognizer.view).delegate).body.pos = cpv(origBodyPos.x+translation.x,
//                                                                        origBodyPos.y+translation.y);
        UIView* note = [_notesBeingMassSelected objectAtIndex:i];
        note.frame = CGRectMake(note.frame.origin.x+translation.x,
                                note.frame.origin.y+translation.y,
                                note.frame.size.width,
                                note.frame.size.height);
    }
    
    
    [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
    
    
    
	if(recognizer.state == UIGestureRecognizerStateEnded) {
        _sv.scrollEnabled = YES; //enable scrolling
    }
}

-(void)populateCanvas{
    //'put stuff on paper
    double x=4,y=4; double sW = 10, sH=10;
    _stuffOnPaper = [[NSMutableArray alloc]init];
    
    [_stuffOnPaper addObject:[ViewHelper embedRect:CGRectMake(x, y, sW, sH) WithColor:[UIColor redColor] DurationSecs:0 In:_canvas]];
    
    x=50;y=60;
    [_stuffOnPaper addObject:[ViewHelper embedRect:CGRectMake(x, y, sW, sH) WithColor:[UIColor redColor] DurationSecs:0 In:_canvas]];
    
    x=130;y=100;
    [_stuffOnPaper addObject:[ViewHelper embedRect:CGRectMake(x, y, sW, sH) WithColor:[UIColor redColor] DurationSecs:0 In:_canvas]];
    
    x=130;y=180;
    [_stuffOnPaper addObject:[ViewHelper embedRect:CGRectMake(x, y, sW, sH) WithColor:[UIColor redColor] DurationSecs:0 In:_canvas]];
    
    x=180;y=180;
    [_stuffOnPaper addObject:[ViewHelper embedRect:CGRectMake(x, y, sW, sH) WithColor:[UIColor redColor] DurationSecs:0 In:_canvas]];
    
    x=150;y=130;
    [_stuffOnPaper addObject:[ViewHelper embedRect:CGRectMake(x, y, sW, sH) WithColor:[UIColor redColor] DurationSecs:0 In:_canvas]];
    
    x=120;y=160;
    [_stuffOnPaper addObject:[ViewHelper embedRect:CGRectMake(x, y, sW, sH) WithColor:[UIColor redColor] DurationSecs:0 In:_canvas]];
    
    x=300;y=100;
    [_stuffOnPaper addObject:[ViewHelper embedRect:CGRectMake(x, y, sW, sH) WithColor:[UIColor redColor] DurationSecs:0 In:_canvas]];
    
    x=260;y=170;
    [_stuffOnPaper addObject:[ViewHelper embedRect:CGRectMake(x, y, sW, sH) WithColor:[UIColor redColor] DurationSecs:0 In:_canvas]];
    
    x=280;y=90;
    [_stuffOnPaper addObject:[ViewHelper embedRect:CGRectMake(x, y, sW, sH) WithColor:[UIColor redColor] DurationSecs:0 In:_canvas]];
    
    x=130;y=160;
    [_stuffOnPaper addObject:[ViewHelper embedRect:CGRectMake(x, y, sW, sH) WithColor:[UIColor redColor] DurationSecs:0 In:_canvas]];
    
    for (int i = 0; i < 20; i++) {
        double xelemI = ((UIView*)[_stuffOnPaper objectAtIndex:i]).frame.origin.x;
        double yelemI = ((UIView*)[_stuffOnPaper objectAtIndex:i]).frame.origin.y;
        double newX = xelemI *2;
        double newY = yelemI *2;
        
        [_stuffOnPaper addObject:[ViewHelper embedRect:CGRectMake(newX, newY, sW, sH) WithColor:[UIColor redColor] DurationSecs:0 In:_canvas]];
        
    }

}


- (IBAction)endMassSelectionOfNotes:(id)sender {
    
    //Destroy all overlays.
    for (UIView* eachOverlay in _massSelectOverlayViews) {
        [eachOverlay removeFromSuperview];
        // Reinstate the notes of each overlay.
        for (UIView* eachNote in _notesBeingMassSelected) {
            [eachNote setBackgroundColor:[UIColor redColor]];
            [eachNote setAlpha:1];
        }
    }
    
    _massSelectOverlayViews = [[NSMutableArray alloc]init];//clear up
}

- (IBAction)reset:(id)sender {
    [self endMassSelectionOfNotes:nil];
    for (UIView* eachNote in _stuffOnPaper) {
        [eachNote removeFromSuperview];
    }
    [_stuffOnPaper removeAllObjects];
    [self populateCanvas];
}



/* ***** Orientation ****** */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES; //support all orientations
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setSv:nil];
    [super viewDidUnload];
}

@end
