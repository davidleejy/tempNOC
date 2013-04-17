//
//  MathHelper.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
@class lineSegment;

#define VERBOSE 0 //For debugging purposes




@interface MathHelper : NSObject



#pragma mark - Floating Point Numbers

+(BOOL)approxEq:(double)a :(double)b Precision:(uint)decPlaces;






#pragma mark - Geometry

+(double)radiansOfLine:(CGPoint)u :(CGPoint)v;
    //EFFECT: returns radians of vector UV w.r.t. x-axis. Radians returned can only be from 0~(2*M_PI)^-
    //	For e.g. if vector UV lies in the 4th quadrant with convex angle of 45 deg from x-axis,
    //	this function will return radians as (M_PI*1.75). This is equivalent to 315 deg.
    //	this function WON’t return radians of –M_PI/2.


+(BOOL)plumblineFrom:(CGPoint)point intersectsLineSegmentFrom:(CGPoint)a To:(CGPoint)b;
    //EFFECT: Determines whether plumbline x=point.x (straight line parallel to the
    //          y axis extended from "point" to y=-infinity.) interesects line segment AB.
    //          Returns yes IFF intersections occurs.


+(BOOL)plumblineFrom:(CGPoint)point intersectsLineSegment:(lineSegment*)l;
//EFFECT: Determines whether plumbline x=point.x (straight line parallel to the
//          y axis extended from "point" to y=-infinity.) interesects l.
//          Returns yes IFF intersections occurs.


+(double)gradient:(CGPoint)a :(CGPoint)b;
    //EFFECT: Returns gradient of line segment AB.
    //          Gradient returned can be INFINITY.

+(double)C:(CGPoint)a :(CGPoint)b;
    //EFFECT: Returns the c component of y=mx+c of line segment joining a & b.

+(NSArray*)radialSort:(NSArray*)arrayOfNSValueCGPoints WithExtremePointAtIndex:(int)extremePointIndex;
    //REQUIRES: An array of NSValue,CGPoint objects.
    //           Non-zero extreme point index.
    //EFFECT: Radially sorts the array w.r.t the extreme point. Outputs immutable sorted array.
    //UNCHANGED: Array size


+(NSMutableArray*)orderMinimumYPointToBeFirstElementOf:(NSArray*)arrayOfNSValueCGPoints;
    //REQUIRES: An array of NSValue,CGPoint objects.
    //EFFECT: Finds CGPoint object in array that has minimum y value. Remove this object. Insert this object at index 0. Outputs mutable array.
    //UNCHANGED: Array size


+(NSMutableArray*)threeCoinAlgorithm:(NSArray*)arrayOfRadiallySortedNSValueCGPoints;
    //REQUIRES: An array of radially sorted NSValue, CGPoint objects with extreme CGpoint at index 0.
    //  Arg should have minimum of 3 elements.
    //EFFECT: Performs the 3-coin algo as described in Graham's Scan on the input array. Outputs a mutable array.
    //EFFECT (elaboration): returns an array consisting of points that are on the perimeter of the convex hull.
    /*
     Do :
     If  the 3 coins form a right turn (or if the 3 coins lie on collinear vertices),
     - Take "back", place it on the vertex ahead of "front".
     -  Relabel : "back" becomes "front", "front" becomes "center", "center" becomes "back".
     Else (the 3 coins form a left hand turn)
     - Take "center", place it on the vertex behind "back".
     - Remove (or ignore hereafter) the vertex that "center" was on.
     - Relabel : "center" becomes "back", "back" becomes "center".
     
     Until  "front" is on vertex p0 (our start vertex) and the 3 coins form a right turn.
     */


+(BOOL)formsARightTurnOrIsCollinear:(CGPoint)a :(CGPoint)b :(CGPoint)c;
    //REQUIRES: 3 CGPoint objects. a,b,c should describe unidirectional path A->B->C.
    //EFFECT: Determine whether path A->B->C forms a right turn or is collinear.

@end
