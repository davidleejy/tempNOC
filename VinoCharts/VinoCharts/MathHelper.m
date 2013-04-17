//
//  MathHelper.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MathHelper.h"
#import "lineSegment.h"


@implementation MathHelper



#pragma mark - Floating Point Numbers

+(BOOL)approxEq:(double)a :(double)b Precision:(uint)decPlaces{
    if (fabs(a-b) < powf(1, -decPlaces))
        return YES;
    else
        return NO;
}


#pragma mark - Geometry

+(double)radiansOfLine:(CGPoint)u :(CGPoint)v{
    double diffX = v.x-u.x;
    double diffY = v.y-u.y;
    
    if (diffY == 0) {
        if (diffX >= 0) {
            return 0;
        }
        else if (diffX<0){
            return M_PI;
        }
    }
    
    if (diffX < 0) { //2nd and 3rd quadrant
        return M_PI + atan(diffY/diffX);
    }
    else if (diffY < 0){ //4th quadrant.
        return 2.0*M_PI + atan(diffY/diffX);
    }
    else // 1st quadrant.
        return atan(diffY/diffX);
}


+(BOOL)plumblineFrom:(CGPoint)point intersectsLineSegmentFrom:(CGPoint)a To:(CGPoint)b {
    
    double gradientAB = [self gradient:a :b];
    
    // If line segment AB has infinite gradient.
    if (gradientAB == INFINITY) {
        if ([MathHelper approxEq:a.x :point.x Precision:6] &&
            MIN(a.y, b.y) <= point.y &&
            point.y <= MAX(a.y, b.y)) return YES;
        else return NO;
    }
    
    // If line segment AB has non-infinite gradient.
    if (MIN(a.x, b.x) <= point.x &&
        point.x <= MAX(a.x, b.x) &&
        point.y >= (gradientAB*point.x + (a.y-gradientAB*a.x)) ) {
        return YES;
    }
    else
        return NO;
}

+(BOOL)plumblineFrom:(CGPoint)point intersectsLineSegment:(lineSegment*)l{
    // If line segment l has infinite gradient.
    if (l.m == INFINITY) {
        if ([MathHelper approxEq:l.a.x :point.x Precision:6] &&
            l.minY <= point.y &&
            point.y <= l.maxY) return YES;
        else return NO;
    }
    
    // If line segment l has non-infinite gradient.
    if (l.minX <= point.x &&
        point.x <= l.maxX &&
        point.y >= (l.m*point.x + l.extrapolatedYIntercept) ) {
        return YES;
    }
    else
        return NO;
}


+(double)gradient:(CGPoint)a :(CGPoint)b{
    if ([self approxEq:a.x :b.x Precision:6])
        return INFINITY;
    else
        return ((a.y-b.y)/(a.x-b.x));
}


+(double)C:(CGPoint)a :(CGPoint)b{
    if ([self approxEq:a.x :b.x Precision:6])
        return INFINITY;
    else
        return a.y-[self gradient:a :b]*a.x;
}


+(NSArray*)radialSort:(NSArray*)arrayOfNSValueCGPoints WithExtremePointAtIndex:(int)extremePointIndex{
    NSMutableArray* array = [[NSMutableArray alloc]initWithArray:arrayOfNSValueCGPoints];
    
    NSValue *extreme = (NSValue *)[array objectAtIndex:extremePointIndex];
    CGPoint extremePoint = [extreme CGPointValue];
    
    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSValue *first = (NSValue *)a;
        NSValue *second = (NSValue *)b;
        CGPoint firstPoint = [first CGPointValue];
        CGPoint secondPoint = [second CGPointValue];
        
        double radiansOfFirstLine = [self radiansOfLine:extremePoint :firstPoint];
        double radiansOfSecondLine = [self radiansOfLine:extremePoint :secondPoint];
        
        if (radiansOfFirstLine < radiansOfSecondLine)
            return NSOrderedAscending;
        else if (radiansOfFirstLine > radiansOfSecondLine)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
    
    return sortedArray;
}


+(NSMutableArray*)orderMinimumYPointToBeFirstElementOf:(NSArray*)arrayOfNSValueCGPoints{
    if (arrayOfNSValueCGPoints.count == 0) {
        return nil; //empty array.
    }
    NSMutableArray* array = [[NSMutableArray alloc]initWithArray:arrayOfNSValueCGPoints];
    
    NSValue* p = (NSValue*)[array objectAtIndex:0];
    
    int idxOfExtremePt = 0; //assume first point is extreme point.
    
    double minY = [p CGPointValue].y; // Let maxY be of first point in array.
    
    for (int i = 1; i<arrayOfNSValueCGPoints.count; i++) {
        if ([(NSValue*)[array objectAtIndex:i] CGPointValue].y < minY) {
            minY = [(NSValue*)[array objectAtIndex:i] CGPointValue].y;
            idxOfExtremePt = i;
        }
    }
    
    NSValue* confirmedExtremePt = [array objectAtIndex:idxOfExtremePt];
    [array removeObjectAtIndex:idxOfExtremePt];
    [array insertObject:confirmedExtremePt atIndex:0];
    
    return array;
}


+(NSMutableArray*)threeCoinAlgorithm:(NSArray*)arrayOfRadiallySortedNSValueCGPoints{
    
    NSMutableArray* array = [[NSMutableArray alloc]initWithArray:arrayOfRadiallySortedNSValueCGPoints];
    
    int back=0, center=1, front=2; //initialisation

    for (int satisfyingMoves = 0; satisfyingMoves < (array.count)+3;) {
        
        if (VERBOSE) NSLog(@"back %d center %d front %d",back,center,front);
        
        if ([self formsARightTurnOrIsCollinear:[(NSValue*)[array objectAtIndex:back] CGPointValue]
                                                 :[(NSValue*)[array objectAtIndex:center] CGPointValue]
                                                 :[(NSValue*)[array objectAtIndex:front] CGPointValue]]) {
            if (VERBOSE) NSLog(@"ABC form a right turn or are collinear.");
            // Only when A->B->C form a right turn or are collinear, then this movement of coins is counted as "satisfying".
            satisfyingMoves++;
            //Take "back", place it on the vertex ahead of "front".
            back = (front+1)%array.count;
            //Relabel : back position is assigned "front", front pos is assigned "center", center pos is assigned "back".
            int former_front = front;
            front = back;
            back = center;
            center = former_front;
            
        }
        else { //3 coins take a left turn. NOT A SATISFYING MOVE.
            
            //     - Take "center", place it on the vertex behind "back".
            if (VERBOSE) NSLog(@"ABC from a left turn.");
            int center_to_be_removed = center;
            
            center = (center-1)%array.count;
            back = (back-1)%array.count;
            
            //     - Remove (or ignore hereafter) the vertex that "center" _was_ on.
            [array removeObjectAtIndex:center_to_be_removed];
            if (VERBOSE) NSLog(@"removed %d pt",center_to_be_removed);
            // Adjust the indices.
            if (front > center_to_be_removed) {
                front--;
            }
            if (center > center_to_be_removed) {
                center--;
            }
            if (back > center_to_be_removed) {
                back--;
            }
        }
        
    }
    
    return array;
}


+(BOOL)formsARightTurnOrIsCollinear:(CGPoint)a :(CGPoint)b :(CGPoint)c{
    double radiansABLine = [self radiansOfLine:a :b];
    double radiansACLine = [self radiansOfLine:a :c];
    
    if (VERBOSE)  NSLog(@"AB %.2f AC %.2f",radiansABLine, radiansACLine);
    
    // Idea of algorithm:
    // 1. Let A be the origin on an x-y plane.
    // 2. Then lines AB and AC would be lines starting from the origin.
    // 3. Idea is that if AC lies to the right of AB, moving A->B->C would be taking a right turn.
    // 4. A numerical realization of this idea is that if angleWRTXAxis(AC) lies within angleWRTXAxis(AB) to angleWRTXAxis(AB)+M_PI , then moving A->B->C would be taking a right turn.
    // 5. Recall that this function returns YES if ABC are collinear. We have to take care of this “boundary case”.
    
    // Algorithm implementation:
    // Find angle of AB w.r.t. x-axis. This is the lower bound. See point 4 above.
    double lowerBound = radiansABLine;
    
    // Find upper bound. Upper bound is lowerBound+M_PI.
    double upperBound = radiansABLine+M_PI;
    
    
    // If line AB lies in the 1st and 2nd quadrants. More quantitatively, 0 <= angleWRTXAxis(AB) < M_PI.
    if (0 <= radiansABLine && radiansABLine < M_PI ) {
        if  (lowerBound <= radiansACLine && radiansACLine <= upperBound )
            return YES;
        else
            return NO;
    }
    // If line AB lies in the 3rd and 4th quadrants. More quantitatively, M_PI <= angleWRTXAxis(AB) < 2*M_PI.
    else if (M_PI <= radiansABLine && radiansABLine < 2.0*M_PI ) {
        // Since the radiansOfLine only returns a radians between 0~(2*M_PI)^- , endpoints inclusive, we
        // have to adjust upperBounds that are greater or equals to 2*M_PI
        // to given an equivalent radians that is in the range of 0~(2*M_PI)^-.  These kinds of upper bounds only occur for AB lines
        // that lie in the 3rd and 4th quadrants.
        
        upperBound -= 2.0*M_PI;
        if  ((lowerBound <= radiansACLine && radiansACLine < 2.0*M_PI) ||
             (0 <= radiansACLine && radiansACLine <= upperBound) )
            return YES;
        else
            return NO;
    }
    else {
        [NSException raise:@"Line AB of path A->B->C is not in 1st,2nd,3rd,4th quadrants. Probably a problem with calculating radians" format:@"%s",__FUNCTION__];
        return NO;
    }
}

@end
