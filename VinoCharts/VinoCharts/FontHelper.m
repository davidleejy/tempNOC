//
//  FontHelper.m
//  VinoCharts
//
//  Created by Lee Jian Yi David on 4/11/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "FontHelper.h"
#import "Constants.h"

@implementation FontHelper

+(BOOL)isBold:(UIFont*)f{
    NSString* name = [f fontName];
    if([name hasSuffix:fBOLD])
		return YES;
	else
		return NO;
}

+(BOOL)isOnlyItalics:(UIFont*)f{
	NSString* name = [f fontName];
    if([name hasSuffix:fITALIC])
		return YES;
	else
		return NO;
}

+(BOOL)isBoldAndItalics:(UIFont*)f{
	NSString* name = [f fontName];
    if([name hasSuffix:fBOLD_ITALIC])
		return YES;
	else
		return NO;
}

+(BOOL)isNotImbuedWithModifier:(UIFont*)f{
    if (![FontHelper isBold:f]
        && ![FontHelper isOnlyItalics:f]
        && ![FontHelper isBoldAndItalics:f]) {
        return YES;
    }
    else
        return NO;
}

+(UIFont*)addItalicsTo:(UIFont*)f{
	if ([FontHelper isOnlyItalics:f] || [FontHelper isBoldAndItalics:f])
		return f;
    else if ([FontHelper isBold:f]){
        NSString* name = [f fontName];
        return [UIFont fontWithName:[name stringByAppendingString:@"Italic"] size:FONT_DEFAULT_SIZE];
    }
	else {
		NSString* name = [f fontName];
		return [UIFont fontWithName:[name stringByAppendingString:fITALIC] size:FONT_DEFAULT_SIZE];
	}
}

+(UIFont*)addBoldTo:(UIFont*)f{
	if ([FontHelper isBold:f] || [FontHelper isBoldAndItalics:f])
		return f;
    else if ([FontHelper isOnlyItalics:f]){
        UIFont* g = [FontHelper removeModifiersOf:f];
        NSString* name = [g fontName];
        return [UIFont fontWithName:[name stringByAppendingString:fBOLD_ITALIC] size:FONT_DEFAULT_SIZE];
    }
	else {
		NSString* name = [f fontName];
		return [UIFont fontWithName:[name stringByAppendingString:fBOLD] size:FONT_DEFAULT_SIZE];
	}
}

+(UIFont*)minusItalicsFrom:(UIFont*)f{
	if ([FontHelper isOnlyItalics:f]) {
        return [FontHelper removeModifiersOf:f];
    }
    else if ([FontHelper isBoldAndItalics:f]){
        UIFont* g = [FontHelper removeModifiersOf:f];
        return [FontHelper addBoldTo:g];
    }
    else //f is not italicised to begin with.
    {
        return f;
    }
}

+(UIFont*)minusBoldFrom:(UIFont*)f{
    if ([FontHelper isBoldAndItalics:f]) {
        UIFont* g = [FontHelper removeModifiersOf:f];
        return [FontHelper addItalicsTo:g];
    }
    else if ([FontHelper isBold:f]) // Detecting only -Bold and not -BoldItalic
    {
        return [FontHelper removeModifiersOf:f];
    }
    else //f is not bold to begin with.
    {
        return f;
    }
}

+(UIFont*)removeModifiersOf:(UIFont*)f{
    NSString* name = [f fontName];
    if ([FontHelper isBold:f]) {
        name = [name substringToIndex:name.length-fBOLD.length];                          
        return [UIFont fontWithName:name size:FONT_DEFAULT_SIZE];
    }
    else if ([FontHelper isOnlyItalics:f]) {
        name = [name substringToIndex:name.length-fITALIC.length];
        return [UIFont fontWithName:name size:FONT_DEFAULT_SIZE];
    }
    else if ([FontHelper isBoldAndItalics:f]) {
        name = [name substringToIndex:name.length-fBOLD_ITALIC.length];
        return [UIFont fontWithName:name size:FONT_DEFAULT_SIZE];
    }
    else{ // f has no modifiers to begin with.
        return f;
    }
        
}

@end
