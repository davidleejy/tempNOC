//
//  Constants.h
//  MySurvey
//
//  Created by Roy Huang Purong on 3/24/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const int MAX_OPTION;

extern const CGFloat OPTION_SPACE;

extern const CGFloat OPTION_WIDTH;
extern const CGFloat OPTION_HEIGHT;

extern const CGFloat OPEN_END_TEXT_VIEW_WIDTH;
extern const CGFloat OPEN_END_TEXT_VIEW_HEIGHT;
extern const CGFloat OPEN_END_TEXT_VIEW_SPACE;

extern const CGFloat QUESTION_VIEW_LEFT_ALLIGNMENT_SPACE;

extern const int MAX_QUESTION;

extern const CGFloat QUESTION_TITLE_INVIEW_WIDTH;
extern const CGFloat QUESITON_TITLE_INVIEW_HEIGHT;

extern const CGFloat QUESTION_CONTENT_WIDTH;
extern const CGFloat QUESTION_CONTENT_HEIGHT;

/* Limits */

//Notes
FOUNDATION_EXPORT NSUInteger NOTE_CONTENT_CHAR_LIM;
FOUNDATION_EXPORT NSString *STR_WITH_140_CHARS;
FOUNDATION_EXPORT NSUInteger NOTE_DEFAULT_WIDTH;
FOUNDATION_EXPORT NSUInteger NOTE_DEFAULT_HEIGHT;
//Notes,material
FOUNDATION_EXPORT NSString *NOTE_MATERIAL_YELLOW_PAPER;
FOUNDATION_EXPORT NSString *NOTE_MATERIAL_YELLOW_PAPER_PRETTYNAME;
FOUNDATION_EXPORT NSString *NOTE_MATERIAL_RED_PAPER;
FOUNDATION_EXPORT NSString *NOTE_MATERIAL_RED_PAPER_PRETTYNAME;
FOUNDATION_EXPORT NSString *NOTE_MATERIAL_GREEN_PAPER;
FOUNDATION_EXPORT NSString *NOTE_MATERIAL_GREEN_PAPER_PRETTYNAME;
FOUNDATION_EXPORT NSString *NOTE_MATERIAL_WHITE_PAPER;
FOUNDATION_EXPORT NSString *NOTE_MATERIAL_WHITE_PAPER_PRETTYNAME;
FOUNDATION_EXPORT NSString *NOTE_MATERIAL_BLUE_PAPER;
FOUNDATION_EXPORT NSString *NOTE_MATERIAL_BLUE_PAPER_PRETTYNAME;

//Canvas Window
FOUNDATION_EXPORT NSUInteger CANVAS_WINDOW_UNPLACED_FRESH_NOTE_LIM;

//Canvas
FOUNDATION_EXPORT NSUInteger CANVAS_NOTE_COUNT_LIM;
FOUNDATION_EXPORT NSUInteger CANVAS_WIDTH_UPPERLIM;
FOUNDATION_EXPORT NSUInteger CANVAS_HEIGHT_UPPERLIM;

//Easel (Thing that holds up canvas)
FOUNDATION_EXPORT double EASEL_BORDER_CANVAS_BORDER_OFFSET;


/* Constants that aren't limits */

//Notes
FOUNDATION_EXPORT NSUInteger NOTE_DEFAULT_FONT_SIZE;


/* Font Families */
FOUNDATION_EXPORT NSString *FONT_HELVETICA;
FOUNDATION_EXPORT NSString *FONT_TIMESNEWROMAN;
FOUNDATION_EXPORT NSString *FONT_COURIER;
FOUNDATION_EXPORT NSString *FONT_NOTEWORTHY;
FOUNDATION_EXPORT NSString *FONT_VERDANA;
FOUNDATION_EXPORT NSString *FONT_ARIAL;
FOUNDATION_EXPORT NSString *FONT_TREBUCHETMS;
extern NSString* const fBASKERVILLE;
extern NSString* const fCOCHIN;
extern NSString* const fGEORGIA;
extern NSString* const fGILLSANS;
extern NSString* const fHELVETICA_NEUE;
extern NSString* const fOPTIMA;
extern NSString* const fPALATINO;
extern NSString* const fVERDANA;

extern NSString* const fBOLD;
extern NSString* const fITALIC;
extern NSString* const fBOLD_ITALIC;
FOUNDATION_EXPORT CGFloat FONT_DEFAULT_SIZE;

// Tiles related
extern const CGFloat TITLE_LABEL_WIDTH;
extern const CGFloat TITLE_LABEL_HEIGHT;
extern const CGFloat TITLE_X_PADDING;
extern const CGFloat TITLE_Y_PADDING;
extern const int DESC_LENGTH;

extern const CGFloat TILE_VERTICAL_PADDING;
extern const CGFloat TILE_HORIZONTAL_PADDING;
extern const int NUM_TILES_IN_A_ROW;

// Dropbox visual information
FOUNDATION_EXPORT NSString *LOADING;


/**************Survey and Feedback constant******************/
extern const int MAX_OPTION;
extern const int MAX_QUESTION;

extern const CGFloat OPTION_SPACE;

extern const CGFloat OPTION_WITH;
extern const CGFloat OPTION_HEIGHT;

extern const CGFloat OPEN_END_TEXT_VIEW_WIDTH;
extern const CGFloat OPEN_END_TEXT_VIEW_HEIGHT;
extern const CGFloat OPEN_END_TEXT_VIEW_SPACE;

extern const CGFloat QUESTION_VIEW_LEFT_ALLIGNMENT_SPACE;

extern const CGFloat QUESTION_TITLE_INVIEW_WIDTH;
extern const CGFloat QUESITON_TITLE_INVIEW_HEIGHT;

extern const CGFloat QUESTION_CONTENT_WIDTH;
extern const CGFloat QUESTION_CONTENT_HEIGHT;

extern const CGFloat START_X_AXIS;
extern const CGFloat START_Y_AXIS;

extern const CGFloat SECTION_HEIGHT;
extern const CGFloat SECTION_WEIGH;

extern const CGFloat SECTION_SPACE;

extern const CGFloat SPACE_BETWEEN_TITLE_AND_FREEENTRYBOX;




@interface Constants : NSObject

//Notes,material
+(NSString*)prettyNameOfNoteMaterial:(NSString*)FileNameOfNoteMaterial;

+(NSString*)FileNameOfNoteMaterial:(NSString*)prettyNameOfNoteMaterial;

@end
