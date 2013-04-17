//
//  EditDiagramController.h
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/24/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <quartzcore/CADisplayLink.h>
#import <dispatch/dispatch.h>
#import "Note.h"
#import "NoteM.h"
#import "Diagram.h"
#import "CanvasSettingController.h"
#import "GridView.h"

#import "ColorViewController.h"
#import "WEPopoverController.h"

#import "UserOptionsLoadPicker.h"

#import "MinimapView.h"
#import"FramingLinesView.h"

@protocol EditDiagramControllerDelegate

-(void)saveANewDiagram:(Diagram*)diagram;
-(void)updateDiagram:(Diagram*)diagram;

@end


@interface EditDiagramController : UIViewController
<UIScrollViewDelegate,
UITextViewDelegate,
UIPopoverControllerDelegate,
CanvasSettingControllerDelegate,
WEPopoverControllerDelegate,
ColorViewControllerDelegate,
UserOptionsLoadPickerDelegate>

/*Outlets*/
@property (weak, nonatomic) IBOutlet UIScrollView *canvasWindow;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *gridSnappingButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *unplacedNotesButton;


/*Actions*/
- (IBAction)addNewNoteButton:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)resetZoomButton:(id)sender;
- (IBAction)gridSnappingButton:(id)sender;
- (IBAction)minimapButton:(id)sender;
- (IBAction)unplacedNotesButton:(id)sender;
- (IBAction)saveButton:(id)sender;



/*States*/
@property (readwrite) BOOL editingANote;
@property (readwrite) Note *noteBeingEdited;
@property (readwrite) int singlySelectedPannedNotesCount; // number of notes being panned via single touch pan gesture.
@property (readwrite) BOOL snapToGridEnabled;
@property (readwrite) BOOL minimapEnabled;



/*Properties*/
@property (readwrite, nonatomic, weak) IBOutlet id<EditDiagramControllerDelegate>delegate;
@property (readwrite) CADisplayLink *displayLink;
@property (readwrite) ChipmunkSpace *space;
@property (readwrite) NSMutableArray *notesArray; //TODO change name to placedNotesarry
@property (readwrite) NSMutableArray *temporaryHoldingAreaForNotes; //TODO change this to represent a holder for notes floating in front of canvas window.
@property (readwrite) NSMutableArray *unplacedNotesArray; //TODO change this to hold content-filled unplaced notes.
@property (readwrite) UIView *canvas;
@property (readwrite) NSString* canvasColorHexValue; //TODO temporary fix.

/* Editing a note */
// Contents of note
@property (readwrite) UITextView *editNoteTextPlatform;
// Edit toolbar
@property (readwrite) UIToolbar *editNoteToolBar;
// Font Color
@property (nonatomic, strong) WEPopoverController *wePopoverController;
// Font Family
@property (readwrite) UserOptionsLoadPicker* fontPicker;
// Note's material
@property (readwrite) UserOptionsLoadPicker* materialPicker;
// Droplist Popover controller
@property (nonatomic) UIPopoverController *optionsPickerPopOver;

// Memorise canvasWindow's height. Need this when desummoning keyboarding.
@property (readwrite) double canvasWindowOrigHeight;

/* Data from another view controller's summoning of this view controller. Only used ONCE when initialising this view controller. */
// Data from createNewDiagramController ...
@property (readwrite) double requestedCanvasWidth;
@property (readwrite) double requestedCanvasHeight;
// Data from ProjectDiagramsViewController ...
@property (readwrite) Diagram* requestedDiagram;
@property (readwrite) BOOL requestToLoadDiagramModel;


// Canvas Setting Controller. Popover kind.
@property (readwrite) CanvasSettingController *canvasSettingController;
@property (readwrite) UIStoryboardPopoverSegue *currentPopoverSegue;

// Actual width and height of canvas. Not affected by zooming of _canvasWindow.  _canvasWindow will affect the width and height of _canvas (a UIView* that is attached to a UIScrollView*, _canvasWindow.)
@property (readwrite) double actualCanvasWidth; //TODO DEL
@property (readwrite) double actualCanvasHeight; //TODO DEL

// Grid
@property (readwrite) GridView *grid;

// Minimap
//TODO
@property (readwrite) UIView *minimap; //TODO del
@property (readwrite) UIView *minimap2; //TODO del
@property (readwrite) UIView *minimapDisplay; //TODO del
@property (readwrite) FramingLinesView *flv1; //TODO del
@property (readwrite) MinimapView *minimapView;

// Note Model //TODO DEL
@property (readwrite) NSMutableArray* NoteMArr1;

//Diagram Model //TODO DEL
@property (readwrite) Diagram* diagramModel;

// Mass Select Notes
@property (readwrite) NSMutableArray* lineSegmentsOfConvexHull;
@property (readwrite) NSMutableArray* notesBeingMassSelected;

/*Gesture Recognizer Methods*/

-(void)unplacedNotePanResponse:(UIPanGestureRecognizer*)recognizer;

-(void)notePanResponse:(UIPanGestureRecognizer*)recognizer;
// EFFECTS: Executes what a note is supposed to do during panning.

-(void)noteDoubleTapResponse:(UITapGestureRecognizer*)recognizer;
// EFFECTS: Executes what a note is supposed to do when the button at the bottom left of the note is double tapped.

//-(void)massSelectNotes:(UITapGestureRecognizer*)recognizer; //TODO
//// EFFECTS: Selects >1 notes.

- (void)singleTapResponse:(UITapGestureRecognizer *)recognizer;
// EFFECTS: Executes what a single tap is supposed to do.

/*Methods*/


@end
