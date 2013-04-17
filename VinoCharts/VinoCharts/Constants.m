//
//  Constants.m
//  MySurvey
//
//  Created by Roy Huang Purong on 3/24/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Constants.h"

/* Limits */

//Notes
NSUInteger NOTE_CONTENT_CHAR_LIM = 140;
NSString *STR_WITH_140_CHARS =
@"\"Imagine a world in which every single human being can freely share in the sum of all knowledge. That's our commitment.\" –Wikipedia VisState";
NSUInteger NOTE_DEFAULT_WIDTH = 250;
NSUInteger NOTE_DEFAULT_HEIGHT = 250;
//Notes,material
NSString *NOTE_MATERIAL_YELLOW_PAPER = @"yellow-note.png";
NSString *NOTE_MATERIAL_YELLOW_PAPER_PRETTYNAME = @"Yellow";
NSString *NOTE_MATERIAL_RED_PAPER = @"red-note.png";
NSString *NOTE_MATERIAL_RED_PAPER_PRETTYNAME = @"Red";
NSString *NOTE_MATERIAL_GREEN_PAPER = @"green-note.png";
NSString *NOTE_MATERIAL_GREEN_PAPER_PRETTYNAME = @"Green";
NSString *NOTE_MATERIAL_WHITE_PAPER = @"white-note.png";
NSString *NOTE_MATERIAL_WHITE_PAPER_PRETTYNAME = @"White";
NSString *NOTE_MATERIAL_BLUE_PAPER = @"blue-note.png";
NSString *NOTE_MATERIAL_BLUE_PAPER_PRETTYNAME = @"Blue";

//Canvas Window
NSUInteger CANVAS_WINDOW_UNPLACED_FRESH_NOTE_LIM = 5;

//Canvas
NSUInteger CANVAS_NOTE_COUNT_LIM = 100;
NSUInteger CANVAS_WIDTH_UPPERLIM = 10000;
NSUInteger CANVAS_HEIGHT_UPPERLIM = 10000;

//Easel (Easel is the thing that holds up the canvas)
double EASEL_BORDER_CANVAS_BORDER_OFFSET = 260;


/* Constants that aren't limits */

//Notes


/* Font Families*/
NSString *FONT_HELVETICA = @"Helvetica";
NSString *FONT_TIMESNEWROMAN = @"Times New Roman";
NSString *FONT_COURIER = @"Courier";
NSString *FONT_NOTEWORTHY = @"Noteworthy";
NSString *FONT_VERDANA = @"Verdana";
NSString *FONT_ARIAL = @"Arial";
NSString *FONT_TREBUCHETMS = @"Trebuchet MS";
NSString* const fBASKERVILLE = @"Baskerville";
NSString* const fCOCHIN = @"Cochin";
NSString* const fGEORGIA = @"Georgia";
NSString* const fGILLSANS = @"GillSans";
NSString* const fHELVETICA_NEUE = @"HelveticaNeue";
NSString* const fOPTIMA = @"Optima";
NSString* const fPALATINO = @"Palatino";
NSString* const fVERDANA = @"Verdana";

NSString* const fBOLD = @"-Bold";
NSString* const fITALIC = @"-Italic";
NSString* const fBOLD_ITALIC = @"-BoldItalic";
CGFloat FONT_DEFAULT_SIZE = 15;

// Tiles related
const CGFloat TITLE_LABEL_WIDTH = 170.0f;
const CGFloat TITLE_LABEL_HEIGHT = 30.0f;
const CGFloat TITLE_X_PADDING = 10.0f;
const CGFloat TITLE_Y_PADDING = 25.0f;
const int DESC_LENGTH = 250;

const CGFloat TILE_VERTICAL_PADDING = 50.0f;
const CGFloat TILE_HORIZONTAL_PADDING = 60.0f;
const int NUM_TILES_IN_A_ROW = 4;

// Dropbox visual information
NSString *LOADING = @"Loading...";


/*******************Survey and Feedback contant************************/
const int MAX_OPTION = 10;
const int MAX_QUESTION = 15;

const CGFloat OPTION_SPACE = 15.0f;

const CGFloat OPTION_WITH = 875.0f;
const CGFloat OPTION_HEIGHT = 40.0f;

const CGFloat OPEN_END_TEXT_VIEW_WIDTH = 875.0f;
const CGFloat OPEN_END_TEXT_VIEW_HEIGHT = 500.0f;
const CGFloat OPEN_END_TEXT_VIEW_SPACE = 15.0f;

const CGFloat QUESTION_VIEW_LEFT_ALLIGNMENT_SPACE = 5.0f;

const CGFloat QUESTION_TITLE_INVIEW_WIDTH = 40.0f;
const CGFloat QUESITON_TITLE_INVIEW_HEIGHT = 20.0f;

const CGFloat QUESTION_CONTENT_WIDTH = 875.0f;
const CGFloat QUESTION_CONTENT_HEIGHT = 71.0f;

const CGFloat START_X_AXIS = 15.0f;
const CGFloat START_Y_AXIS = 15.0f;

const CGFloat SECTION_HEIGHT = 112.0f;
const CGFloat SECTION_WEIGH = 1000.0f;

const CGFloat SECTION_SPACE = 20.0f;

const CGFloat SPACE_BETWEEN_TITLE_AND_FREEENTRYBOX = 30.0f;



@implementation Constants

//Notes,material
+(NSString*)prettyNameOfNoteMaterial:(NSString*)FileNameOfNoteMaterial{
    if ([FileNameOfNoteMaterial isEqualToString:NOTE_MATERIAL_YELLOW_PAPER])
        return NOTE_MATERIAL_YELLOW_PAPER_PRETTYNAME;
    else if ([FileNameOfNoteMaterial isEqualToString:NOTE_MATERIAL_RED_PAPER])
        return NOTE_MATERIAL_RED_PAPER_PRETTYNAME;
    else if ([FileNameOfNoteMaterial isEqualToString:NOTE_MATERIAL_GREEN_PAPER])
        return NOTE_MATERIAL_GREEN_PAPER_PRETTYNAME;
    else if ([FileNameOfNoteMaterial isEqualToString:NOTE_MATERIAL_WHITE_PAPER])
        return NOTE_MATERIAL_WHITE_PAPER_PRETTYNAME;
    else if ([FileNameOfNoteMaterial isEqualToString:NOTE_MATERIAL_BLUE_PAPER])
        return NOTE_MATERIAL_BLUE_PAPER_PRETTYNAME;
    else {
        [NSException raise:@"FileNameOfNoteMaterial does not match any constant.m records." format:@"%s given %@.",__FUNCTION__,FileNameOfNoteMaterial];
    return [NSString stringWithFormat:@"File Name: \"%@\".",FileNameOfNoteMaterial];
    }
}


+(NSString*)FileNameOfNoteMaterial:(NSString*)prettyNameOfNoteMaterial{
    if ([prettyNameOfNoteMaterial isEqualToString: NOTE_MATERIAL_YELLOW_PAPER_PRETTYNAME])
        return NOTE_MATERIAL_YELLOW_PAPER;
    else if ([prettyNameOfNoteMaterial isEqualToString: NOTE_MATERIAL_RED_PAPER_PRETTYNAME])
        return NOTE_MATERIAL_RED_PAPER;
    else if ([prettyNameOfNoteMaterial isEqualToString: NOTE_MATERIAL_GREEN_PAPER_PRETTYNAME])
        return NOTE_MATERIAL_GREEN_PAPER;
    else if ([prettyNameOfNoteMaterial isEqualToString: NOTE_MATERIAL_WHITE_PAPER_PRETTYNAME])
        return NOTE_MATERIAL_WHITE_PAPER;
    else if ([prettyNameOfNoteMaterial isEqualToString: NOTE_MATERIAL_BLUE_PAPER_PRETTYNAME])
        return NOTE_MATERIAL_BLUE_PAPER;
    else {
        [NSException raise:@"prettyNameOfNoteMaterial does not match any constant.m records." format:@"%s given %@.",__FUNCTION__,prettyNameOfNoteMaterial];
        return [NSString stringWithFormat:@"Pretty Name: \"%@\".",prettyNameOfNoteMaterial];
    }
}

@end
