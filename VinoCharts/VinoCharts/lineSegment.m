//
//  lineSegment.m
//  VinoCharts
//
//  Created by Lee Jian Yi David on 4/9/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "lineSegment.h"
#import "MathHelper.h"

@implementation lineSegment

- (id)initWith:(CGPoint)a :(CGPoint)b{
    // No need self = super init;
    
    _a = a;
    _b = b;
    _m = [MathHelper gradient:a :b];
    _extrapolatedYIntercept = [MathHelper C:a :b];
    
    // Set max and min X.
    if (a.x >= b.x) {
        _maxX = a.x; _minX = b.x;
    }
    else {
        _maxX = b.x; _minX = a.x;
    }
    
    // Set max and min Y.
    if (a.y >= b.y) {
        _maxY = a.y; _minY = b.y;
    }
    else {
        _maxY = b.y; _minY = a.y;
    }
    
    return self;
}

- (void)NSLogWithPrefixText:(NSString*)prefixText {
    NSLog(@"%@ a(%.2f, %.2f) b(%.2f, %.2f) m %.2f eYInt %.2f",prefixText, _a.x, _a.y, _b.x, _b.y, _m, _extrapolatedYIntercept);
    NSLog(@"    maxX %.2f minX %.2f maxY %.2f minY %.2f", _maxX, _minX, _maxY, _minY);
}


@end
