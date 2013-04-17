//
//  FontHelper.h
//  VinoCharts
//
//  Created by Lee Jian Yi David on 4/11/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontHelper : NSObject

+(BOOL)isBold:(UIFont*)f; // Detects -Bold AND -BoldItalic
+(BOOL)isOnlyItalics:(UIFont*)f; // Detects -Italic
+(BOOL)isBoldAndItalics:(UIFont*)f; // Detects -BoldItalic
+(BOOL)isNotImbuedWithModifier:(UIFont*)f; // Detects the absence of -Bold, -Italic, -BoldItalic.

// EFFECT: Modifies input f.
+(UIFont*)addItalicsTo:(UIFont*)f;
+(UIFont*)addBoldTo:(UIFont*)f;
+(UIFont*)minusItalicsFrom:(UIFont*)f;
+(UIFont*)minusBoldFrom:(UIFont*)f;
+(UIFont*)removeModifiersOf:(UIFont*)f;

@end
