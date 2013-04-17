//
//  lineSegment.h
//  VinoCharts
//
//  Created by Lee Jian Yi David on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lineSegment : NSObject

// a and b are points joining the line segment. The line segment does not exist beyond a and b.
@property(readonly) CGPoint a;
@property(readonly) CGPoint b;

@property(readonly) double m; //gradient

@property(readonly) double extrapolatedYIntercept; // The c component of y=mx+c formed by extending this line segment ot infinity.

//Some limits
@property(readonly) double maxX;
@property(readonly) double minX;
@property(readonly) double maxY;
@property(readonly) double minY;

- (id)initWith:(CGPoint)a :(CGPoint)b;
//EFFECT: ctor

- (void)NSLogWithPrefixText:(NSString*)prefixText;
//EFFECT: prints the properties

@end
