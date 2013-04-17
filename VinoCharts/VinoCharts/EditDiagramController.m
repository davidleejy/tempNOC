//
//  EditDiagramController.m
//  vinocharts_diagrams
//
//  Created by Lee Jian Yi David on 3/24/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#define DEBUG 1

#import <math.h> // Good ol' math.h
#import <dispatch/dispatch.h> // Grand Central Dispatch

#import "EditDiagramController.h" // That's my header!
#import "EditDiagramController+MassSelectNotes.h"

#import "Note.h"
#import "NoteM.h"
#import "Diagram.h"

#import "GridView.h"
#import "AlignmentLineView.h"
#import "FramingLinesView.h"
#import "MinimapView.h"

#import "Constants.h"
#import "ViewHelper.h"
#import "DebugHelper.h"
#import "FontHelper.h"

#import "ColorViewController.h"
#import "WEPopoverController.h"
#import "CanvasSettingController.h"
#import "UserOptionsLoadPicker.h"


// An object to use as a collision type for the screen border.
// Class objects and strings are easy and convenient to use as collision types.
static NSString *borderType = @"borderType";



@implementation EditDiagramController

@synthesize minimapView = _minimapView;
@synthesize temporaryHoldingAreaForNotes = _temporaryHoldingAreaForNotes;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(DEBUG) NSLog(@"Requested w & h are %.2f , %.2f", _requestedCanvasWidth, _requestedCanvasHeight);
    
    // Set up keyboard management.
    [self setupKeyboardMgmt];
    
    // Initialise arrays of notes
    _notesArray = [[NSMutableArray alloc]init];
    _temporaryHoldingAreaForNotes = [[NSMutableArray alloc]init];
    _unplacedNotesArray = [[NSMutableArray alloc]init];
    _unplacedNotesButton.title = [NSString stringWithFormat:@"%d Unplaced Notes",_unplacedNotesArray.count];
    
    // Initialise toolbar that appears when editing notes
    [self createEditNoteToolBar];
    
    // Initialise the platform that keyboard will be tied to when editing a note's textual content.
    _editNoteTextPlatform = [[UITextView alloc]initWithFrame:CGRectMake(0, 400-100, NOTE_DEFAULT_WIDTH, 100)];
    [_editNoteTextPlatform setDelegate:self];
    
    // Initialise actual dimensions of canvas.
    // The actual dimensions of the canvas differ from the frame of _canvas when zooming
    // takes place in the _canvasWindow.
    _actualCanvasHeight = _requestedCanvasHeight;
    _actualCanvasWidth = _requestedCanvasWidth;
    /*TODO see if you can delete requestedcanvaswidth and requestedcanvasheight.
     And replace them with actualcanvaswidth and actualcanvasheight.*/
    
    // Initialise _canvasWindow
//    CGSize easelSize = CGSizeMake(_requestedCanvasWidth+EASEL_BORDER_CANVAS_BORDER_OFFSET*2.0, _requestedCanvasHeight+EASEL_BORDER_CANVAS_BORDER_OFFSET*2.0);
//    [_canvasWindow setContentSize:easelSize];
    
    [_canvasWindow setBackgroundColor:[UIColor grayColor]];
    // Zooming
    [_canvasWindow setDelegate:self];
    [_canvasWindow setMaximumZoomScale:2.0];
    [_canvasWindow setMinimumZoomScale:0.1];
    [_canvasWindow setClipsToBounds:YES];
    
    
    // Initialise _canvas
//    _canvas = [[UIView alloc]initWithFrame:CGRectMake(EASEL_BORDER_CANVAS_BORDER_OFFSET,
//                                                     EASEL_BORDER_CANVAS_BORDER_OFFSET,
//                                                      _requestedCanvasWidth,
//                                                      _requestedCanvasHeight)];
    //todo clear up the initialisation of canvaswindow. Namely, decide on whether setting content insets is good anot.
    _canvas = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                      0,
                                                      _requestedCanvasWidth,
                                                      _requestedCanvasHeight)];
    
    // Do not set _canvasWindow contentSize, let it vary freely.
    
//    [_canvasWindow setContentSize:_canvas.frame.size];
//    [_canvasWindow setContentInset:UIEdgeInsetsMake(EASEL_BORDER_CANVAS_BORDER_OFFSET,
//                                                    EASEL_BORDER_CANVAS_BORDER_OFFSET,
//                                                    EASEL_BORDER_CANVAS_BORDER_OFFSET,
//                                                    EASEL_BORDER_CANVAS_BORDER_OFFSET)];
    
    [_canvas setBackgroundColor:[UIColor whiteColor]];
    _canvasColorHexValue = White;
    [_canvasWindow addSubview:_canvas];
    
    // Center content view in _canvasWindow
    // _canvasWindow.contentSize is 0,0 now.
    [_canvasWindow setZoomScale:0.98 animated:NO];
    [_canvasWindow setZoomScale:1 animated:YES];
    // _canvasWindow.contentSize is _canvas.bounds now.
    
    //Memorise original canvasWindow height.
    _canvasWindowOrigHeight = 704;
    
    
    
    // Initialise states
    _editingANote = NO;
    _noteBeingEdited = nil;
    _snapToGridEnabled = NO;
    _minimapEnabled = NO;
    
    // Initialise _space (Chipmunk physics space)
    _space = [[ChipmunkSpace alloc] init];
    [_space addBounds:_canvas.bounds
            thickness:1000000.0f elasticity:0.2f friction:0.8 layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
    [_space setGravity:cpv(0, 0)];
    [self createCollisionHandlers];

    
    // Initialise gridView
        //No need
    
    /* Attach gesture recognizers */
    // Single tapping on canvas window (the UIScrollView)
    UITapGestureRecognizer *singleTapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapResponse:)];
    [_canvasWindow addGestureRecognizer:singleTapRecog];
    
    // Mass selection of notes
//    [self attachGestureRecognizersForMassSelectionOfNotes];
    
    // Initialise diagram model in case of saving later.
    _diagramModel = [[Diagram alloc]init];
    
    // Load diagram model
    if (_requestToLoadDiagramModel) {
        [self loadWithDiagramModel:_requestedDiagram];
        _diagramModel = _requestedDiagram;
        _requestToLoadDiagramModel = NO;
    }
    
    //TODO remove. testing.
//    UIView* x = [[UIView alloc]initWithFrame:CGRectMake(10, 10, 500,500)];
//    [x setBackgroundColor:[UIColor blackColor]];
//    [_canvas addSubview:x];
//    [ViewHelper embedMark:CGPointMake(15, 15) WithColor:[ViewHelper invColorOf:[UIColor blackColor]] DurationSecs:0 In:_canvas];
//    [ViewHelper embedMark:CGPointMake(30, 30) WithColor:[ViewHelper invColorOf:[UIColor brownColor]] DurationSecs:0 In:_canvas];
//    [ViewHelper embedMark:CGPointMake(45, 45) WithColor:[ViewHelper invColorOf:[UIColor greenColor]] DurationSecs:0 In:_canvas];
//    [ViewHelper embedMark:CGPointMake(60, 60) WithColor:[ViewHelper invColorOf:[UIColor blueColor]] DurationSecs:0 In:_canvas];
//    AlignmentLineView *a = [[AlignmentLineView alloc]initToDemarcateFrame:CGRectMake(15, 15, 50, 50) In:_canvas.bounds LineColor:[UIColor purpleColor] Thickness:1];
//    [a addTo:_canvas];
//    _flv1 = [[FramingLinesView alloc]initToDemarcateFrame:CGRectMake(10, 10, 100, 100) LineColor:[UIColor purpleColor] Thickness:8];
//    [_flv1 addTo:_canvas];
//    Note* x = [[Note alloc]initWithText:@"hedge"];
//    Note* y = [[Note alloc]initWithText:@"spa"];
//    Note* z = [[Note alloc]initWithText:@"apple"];
//    Note* w = [[Note alloc]initWithText:@"dichotomy"];
//    
//    [_unplacedNotesArray addObject:x];
//    [_unplacedNotesArray addObject:y];
//    [_unplacedNotesArray addObject:z];
//    [_unplacedNotesArray addObject:w];
//   
}


// =============== Segues ==================
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"CanvasSettingController"]) {
        _currentPopoverSegue = (UIStoryboardPopoverSegue *)segue; // Will be used in dismissing this popover.
        _canvasSettingController = [segue destinationViewController];
        [_canvasSettingController setDelegate:self]; //Set delegate. IMPORTANT!
        // Initialise popover view's information.
        NSString *currCanvasW = [NSString stringWithFormat:@"%.0f",_actualCanvasWidth];
        NSString *currCanvasH = [NSString stringWithFormat:@"%.0f",_actualCanvasHeight];
        _canvasSettingController.widthDisplay.text = currCanvasW;
        _canvasSettingController.heightDisplay.text = currCanvasH;
    }
}


#pragma mark - Canvas Settings

// CanvasSettingControllerDelegate callback function
- (void)CanvasSettingControllerDelegateOkButton:(double)newWidth :(double)newHeight{
    
    //TODO can optimise grid drawing.
    
    // Display alert if canvas dimensions have changed.
    if (_actualCanvasHeight != newHeight || _actualCanvasWidth != newWidth) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Canvas settings successfully changed.\nWidth:%.2f Height:%.2f",newWidth,newHeight]
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
    // Update actual canvas height and width.
    _actualCanvasHeight = newHeight;
    _actualCanvasWidth = newWidth;
    
    
    if (_snapToGridEnabled) {
        [_grid removeFromSuperview]; //hide.
        _grid = [[GridView alloc]initWithFrame:CGRectMake(0, 0, _actualCanvasWidth, _actualCanvasHeight)
                                          Step:50
                                     LineColor:[ViewHelper invColorOf:[_canvas backgroundColor]]];
        [_canvas addSubview:_grid]; //Show.
        [_canvas sendSubviewToBack:_grid]; //Don't block notes.
    }
    
    
    
    // Modify _canvas.
    [_canvas setFrame:CGRectMake(_canvas.frame.origin.x,
                                _canvas.frame.origin.y,
                                 _actualCanvasWidth*[_canvasWindow zoomScale],
                                 _actualCanvasHeight*[_canvasWindow zoomScale])];
    
    // Center content view in _canvasWindow. Don't know why this works. But it does.
    [_canvasWindow setZoomScale:[_canvasWindow zoomScale]-0.01 animated:NO]; //Scale to something slightly smaller than zoomscale that we used before segueing to canvas settings controller.
    [_canvasWindow setZoomScale:[_canvasWindow zoomScale] animated:YES]; //Reinstate zoomScale before changing canvas settings
    
    // Remove all notes from space.
    for (Note* eachNote in _notesArray) {
        [_space remove:eachNote];
    }
    
    // Modify _space. (Destroy and make anew);
    _space = nil;
    _space = [[ChipmunkSpace alloc] init];
    [_space addBounds:_canvas.bounds
            thickness:100000.0f elasticity:0.0f friction:1.0f layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
    [_space setGravity:cpv(0, 0)];
    [self createCollisionHandlers];//MUST ALSO REASSIGN COLLISION HANDLERS.
    
    // Add notes to new space.
    for (Note* eachNote in _notesArray) {
        [_space add:eachNote];
    }
    
    // Redo minimap
    if (_minimapEnabled) {
        [_minimapView removeFromSuperview];
        _minimapView = [[MinimapView alloc]initWithMinimapDisplayFrame:CGRectMake(800, 480, 200, 200) MapOf:_canvas PopulateWith:_notesArray];
        [_minimapView setAlpha:0.8]; // make transparent.
        [self.view addSubview:_minimapView];
    }
    //Set thickness of screen tracker on minimap regardless.
//    [_mV1.screenTracker setThickness:(_canvas.bounds.size.height*_canvas.bounds.size.width)/10000];
    
    
    [[_currentPopoverSegue popoverController] dismissPopoverAnimated: YES]; // dismiss the popover.
}

// CanvasSettingControllerDelegate callback function
- (void)CanvasSettingControllerDelegateCancelButton{
    [_canvas setBackgroundColor:_canvasSettingController.beginningCanvasColor];
    [[_currentPopoverSegue popoverController] dismissPopoverAnimated: YES]; // dismiss the popover.
}

// CanvasSettingControllerDelegate callback function
- (void) CanvasSettingControllerDelegateTappedColor:(UIColor*)tappedColor{
    [_canvas setBackgroundColor:tappedColor];
}

- (void) CanvasSettingControllerDelegateTappedGZColorHexValue:(NSString*)hexValue{
    _canvasColorHexValue = hexValue;
}

// CanvasSettingControllerDelegate callback function
- (UIColor*) CanvasSettingControllerAsksForCanvasColor{
    return _canvas.backgroundColor;
}


#pragma mark - Gestures


-(void)unplacedNotePanResponse:(UIPanGestureRecognizer*)recognizer{
    
    /* Gesture begins ...    */
    if (recognizer.state == UIGestureRecognizerStateBegan){
        
        NoteView* v = (NoteView*)recognizer.view;
        Note* n = (Note*)v.delegate;
        
        [_canvasWindow setScrollEnabled:NO]; //disable scrollview.
        
        //Find coordinates of note's view's center w.r.t canvas.
        CGPoint vFrameCenterOnCanvas = [_canvas convertPoint:v.center fromView:v.superview];
        
        [ViewHelper embedRect:CGRectMake(vFrameCenterOnCanvas.x, vFrameCenterOnCanvas.y, 50, 50) WithColor:[UIColor blackColor] DurationSecs:9 In:_canvas];
        
        [_canvas addSubview:v];
       
        //Set body and align view.
        n.body.pos = vFrameCenterOnCanvas;
        v.frame = CGRectMake(-v.frame.size.width/2.0,
                             -v.frame.size.height/2.0,
                             v.frame.size.width,
                             v.frame.size.height);
        
        [DebugHelper printCGPoint:v.center :@"view frame center"];
        [DebugHelper printCGPoint:CGPointMake(n.body.pos.x, n.body.pos.y) :@"body pos"];
        
        [_notesArray addObject:n];
        
        //don't add to physics engine yet.
        
        //Remove note from unplaced notes array.
        [_temporaryHoldingAreaForNotes removeObjectIdenticalTo:n]; //MUST UNCOMMENT
        
        [self commonCodeForStateBeganNotePanResponse:recognizer]; //COMMON CODE!
    }

    /* Gesture continues changing ...    */
    
    NoteView* v = (NoteView*)recognizer.view;
    Note* n = (Note*)v.delegate;
    
    // Move body.
    cpVect origBodyPos = n.body.pos;
    
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    
    n.body.pos = cpv(origBodyPos.x+translation.x,
                     origBodyPos.y+translation.y);
    
        //Adjust view part to match up with body part.
        double finBodyCenterX = n.body.pos.x;
        double finBodyCenterY = n.body.pos.y;
        double finBodyTLX = finBodyCenterX - v.frame.size.width/2.0;
        double finBodyTLY = finBodyCenterY - v.frame.size.height/2.0;
        double finBodyBLX = finBodyCenterX + v.frame.size.width/2.0;
        double finBodyBLY = finBodyCenterY + v.frame.size.height/2.0;

        // If note's body will be panned to outside the canvas, then do not effect the translation.
        if (finBodyTLX < 0
            ||finBodyTLY < 0
            ||finBodyBLX > _canvas.bounds.size.width
            ||finBodyBLY > _canvas.bounds.size.height) {
            n.body.pos = origBodyPos;
        }
    
        [self commonCodeForStateChangedNotePanResponse:recognizer]; //COMMON CODE!
        
        //Reset recognizer
        [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];

//    [DebugHelper printCGPoint:v.center :@"view frame center cont"];
//    [DebugHelper printCGPoint:CGPointMake(n.body.pos.x, n.body.pos.y) :@"body pos cont"];
    
    
    /* Gesture ends ...    */
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        NoteView* noteViewToBePlaced = ((NoteView*)recognizer.view);
        Note* noteToBePlaced = ((Note*)noteViewToBePlaced.delegate);
        
        [_space add:noteToBePlaced]; //visible to physics engine.
        
        [self commonCodeForStateEndedNotePanResponse:recognizer]; // COMMON CODE!
        
        // Undim note
        [noteViewToBePlaced setAlpha:1];
        
        // Attach pan gesture recognizers for placed note.
        UIPanGestureRecognizer *panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(notePanResponse:)];
        [noteViewToBePlaced addGestureRecognizer:panRecog];
        
        [_canvasWindow setScrollEnabled:YES]; //re-enable scrolling
        
        // Remove this gesture recognizer.
        [noteViewToBePlaced removeGestureRecognizer:recognizer];
    }
}


-(void)notePanResponse:(UIPanGestureRecognizer*)recognizer {
    
    /* Gesture begins ...    */
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _canvasWindow.scrollEnabled = NO; //Disable scrolling
        
        NoteView* recognizerView = (NoteView*)recognizer.view;
        Note* noteBeingPanned = (Note*)recognizerView.delegate;
        
        [_space remove:noteBeingPanned]; //Remove note from space
        recognizerView.alpha = 0.7; //Dim note's appearance.
        [_canvas bringSubviewToFront:recognizerView]; //Give illusion of lifting note up from canvas.
        
        [self commonCodeForStateBeganNotePanResponse:recognizer]; //COMMON CODE!
    }
    
    /* Gesture continues changing ...    */
    
    NoteView* recognizerView = (NoteView*)recognizer.view;
    Note* noteBeingPanned = (Note*)recognizerView.delegate;
    
    cpVect origBodyPos = noteBeingPanned.body.pos;
    
    CGPoint translation = [recognizer translationInView:recognizer.view.superview];
    
    // Move only the body. Somehow the view is constantly updated by _displayLink. Wow.
    noteBeingPanned.body.pos = cpv(origBodyPos.x+translation.x,
                                   origBodyPos.y+translation.y);
    
    // If note's body will be panned to outside the canvas, then do not effect the translation.
    double finBodyCenterX = noteBeingPanned.body.pos.x;
    double finBodyCenterY = noteBeingPanned.body.pos.y;
    double finBodyTLX = finBodyCenterX - recognizerView.frame.size.width/2.0;
    double finBodyTLY = finBodyCenterY - recognizerView.frame.size.height/2.0;
    double finBodyBLX = finBodyCenterX + recognizerView.frame.size.width/2.0;
    double finBodyBLY = finBodyCenterY + recognizerView.frame.size.height/2.0;
    if (finBodyTLX < 0
        ||finBodyTLY < 0
        ||finBodyBLX > _canvas.bounds.size.width
        ||finBodyBLY > _canvas.bounds.size.height) {
        noteBeingPanned.body.pos = origBodyPos;
    }
    
    [self commonCodeForStateChangedNotePanResponse:recognizer]; //COMMON CODE!
    
    [recognizer setTranslation:CGPointZero inView:recognizer.view.superview];
    
    
    /* Gesture ends ...    */
	if(recognizer.state == UIGestureRecognizerStateEnded) {
        
        NoteView* recognizerView = (NoteView*)recognizer.view;
        Note* noteBeingPanned = (Note*)recognizerView.delegate;
        
        [self commonCodeForStateEndedNotePanResponse:recognizer]; //COMMON CODE!
        
        _canvasWindow.scrollEnabled = YES; //enable scrolling
        [_space add:noteBeingPanned]; //Re-add note into space
        recognizerView.alpha = 1; //Un-dim note's appearance.
    }
}


-(void)commonCodeForStateBeganNotePanResponse:(UIPanGestureRecognizer*)recognizer {
    NoteView* noteView = (NoteView*)recognizer.view;
    
    _singlySelectedPannedNotesCount++; // increment count. Useful in regulating disabling/re-enabling of grid snapping button.
    
    if ([_gridSnappingButton isEnabled]) [_gridSnappingButton setEnabled:NO]; //disable grid snapping button. Safety reasons.
    
    // Prepare alignment lines.
    noteView.alignmentLines = [[AlignmentLineView alloc]initToDemarcateFrame:((NoteView*)recognizer.view).frame In:_canvas.bounds LineColor:[ViewHelper invColorOf:_canvas.backgroundColor] Thickness:1.6/_canvasWindow.zoomScale];
    
    // Show the alignment lines.
    [noteView.alignmentLines addToBottommostOf:_canvas];
    
    if (_snapToGridEnabled){
        
        //Prepare foreshadow.
        noteView.foreShadow = [[UIImageView alloc]initWithFrame:CGRectMake(((NoteView*)recognizer.view).frame.origin.x,
                                                                                   noteView.frame.origin.y,
                                                                                   noteView.bounds.size.width,
                                                                                   noteView.bounds.size.height)];
        [noteView.foreShadow setBackgroundColor:[ViewHelper invColorOf:[_canvas backgroundColor]]]; //set color of foreshadow.
        [noteView.foreShadow setAlpha:0.3]; //set alpha of foreshadow.
        //Show foreshadow.
        [_canvas addSubview:noteView.foreShadow];
    }
}

-(void)commonCodeForStateChangedNotePanResponse:(UIPanGestureRecognizer*)recognizer {
    NoteView* noteView = (NoteView*)recognizer.view;
    Note* note = (Note*)noteView.delegate;
    
    if (_snapToGridEnabled) {
        
        // The purpose of this block is to mark out where the note would snap to upon releasing your finger.
        double step = _grid.step; //Find out the stepping involved.
        // Perform rounding algo. This algo finds out where the note's frame's origin would end after releasing your finger.
        double unsnappedX = noteView.frame.origin.x;
        double unsnappedY = noteView.frame.origin.y;
        double snappedX = ((int)(unsnappedX/step))*step;
        double snappedY = ((int)(unsnappedY/step))*step;
        // Move foreShadow to help user visualize where the note will rest after he releases his finger.
        [noteView.foreShadow setFrame:CGRectMake(snappedX, snappedY, noteView.foreShadow.frame.size.width, noteView.foreShadow.frame.size.height)];
        
        // With snap to grid, alignment lines redraw to demarcate foreshadow.
        [noteView.alignmentLines redrawWithDemarcatedFrame:noteView.foreShadow.frame];
    }
    else{
        //Without snap to grid, alignment lines redraw to demarcate note itself.
        [noteView.alignmentLines
         redrawWithDemarcatedFrame:CGRectMake(note.body.pos.x - noteView.frame.size.width/2.0,
                                              note.body.pos.y - noteView.frame.size.height/2.0,
                                              noteView.frame.size.width,
                                              noteView.frame.size.height)];
    }
}

-(void)commonCodeForStateEndedNotePanResponse:(UIPanGestureRecognizer*)recognizer {
    NoteView* noteView = ((NoteView*)recognizer.view);
    Note* note = ((Note*)noteView.delegate);
    
    _singlySelectedPannedNotesCount--; // Decrement count. Useful in regulating disabling/re-enabling of grid snapping button.
    
    if (_singlySelectedPannedNotesCount == 0) { //Implies no notes being singly selected and panned.
        [_gridSnappingButton setEnabled:YES]; //re-enable grid snapping button.
    }
    
    if (_snapToGridEnabled) {
        double step = _grid.step; //Find out the stepping involved.
        //Perform snap rounding algo. This algo focuses on snapping the origin of the note.
        //The origin of the note refers to the top left hand corner of the note.
        double unsnappedXcenter = note.body.pos.x;
        double unsnappedYcenter = note.body.pos.y;
        double unsnappedXorigin = unsnappedXcenter - noteView.bounds.size.width/2.0;
        double unsnappedYorigin = unsnappedYcenter - noteView.bounds.size.height/2.0;
        double snappedXorigin = ((int)(unsnappedXorigin/step))*step;
        double snappedYorigin = ((int)(unsnappedYorigin/step))*step;
        double snappedXcenter = snappedXorigin + noteView.bounds.size.width/2.0;
        double snappedYcenter = snappedYorigin + noteView.bounds.size.height/2.0;
        //Apply new coordinates ONLY to body
        note.body.pos = cpv(snappedXcenter,
                                      snappedYcenter);
        
        //Remove foreshadow.
        [noteView.foreShadow removeFromSuperview];
    }
    
    [noteView.alignmentLines removeLines]; // Hide alignment lines.
}


-(void)noteDoubleTapResponse:(UITapGestureRecognizer*)recognizer {
    //Adjusting states below.
    _editingANote = YES;
    _noteBeingEdited = ((Note*)((NoteView*)(recognizer.view)).delegate);
    
    //Show platform for user to edit text.
    [_editNoteTextPlatform setText:[_noteBeingEdited content]];
    [_editNoteTextPlatform setBackgroundColor:[ViewHelper invColorOf:_canvas.backgroundColor]];
    [_editNoteTextPlatform setTextColor:[ViewHelper invColorOf:_editNoteTextPlatform.backgroundColor]];
    [_editNoteTextPlatform setFont:[_noteBeingEdited getFont]];
    [self.view addSubview:_editNoteTextPlatform];
    
    //Summon keyboard w.r.t UITextView.
    [_editNoteTextPlatform becomeFirstResponder];
    
    //Show tool bar related to editing notes.
    [self.view addSubview:_editNoteToolBar];
}




- (void)singleTapResponse:(UITapGestureRecognizer *)recognizer {
    if (_editingANote)
    {
        [self.view endEditing:YES]; // Dismiss keyboard.
    }
}

#pragma mark - Main Toolbar & its BarButtons

- (IBAction)addNewNoteButton:(id)sender {
    
    // Limit the number of notes a canvas can have.
    if (_notesArray.count > CANVAS_NOTE_COUNT_LIM) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Cannot exceed %d notes on one diagram.",CANVAS_NOTE_COUNT_LIM]
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        return; //terminate adding new note
    }
    
    // Limit the number of fresh UNplaced notes that can be floating in front of the canvas window.
    if (_temporaryHoldingAreaForNotes.count >= CANVAS_WINDOW_UNPLACED_FRESH_NOTE_LIM) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"You should arrange your fresh new notes before adding more new notes. Your stack of notes building up in front of your screen is blocking a vital part of your screen."]
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"OK I'll clear up my fresh new notes."
                                             otherButtonTitles:nil];
        [alert show];
        return; //terminate adding new note
    }
    
    Note *newN = [[Note alloc]initWithText:@"new"];
    
    // Determine coordinates of new note
    CGPoint centerOfNewNote = CGPointMake(_canvasWindow.bounds.size.width/2.0, _canvasWindow.bounds.size.height/2.0);
    [newN.view setCenter:centerOfNewNote];
    
    [_temporaryHoldingAreaForNotes addObject:(Note*)newN]; // Stored in property
    [self.view addSubview:newN.view]; // Visible to user
    newN.view.alpha = 0.6; //Dim note's appearance.
    
    /*Attach gesture recognizers*/
    
    // New UNplaced notes can be dragged and placed.
    UIPanGestureRecognizer *panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(unplacedNotePanResponse:)];
    [newN.view addGestureRecognizer:panRecog];
    
    // New UNplaced notes are editable.
    UITapGestureRecognizer *doubleTapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteDoubleTapResponse:)];
    doubleTapRecog.numberOfTapsRequired = 2;
    [newN.view addGestureRecognizer:doubleTapRecog];
    
    
    //TODO del
    CGPoint centerWRTCanvas = [_canvas convertPoint:newN.view.center fromView:self.view];
    [ViewHelper embedRect:CGRectMake(centerWRTCanvas.x, centerWRTCanvas.y, 50, 50) WithColor:[UIColor greenColor] DurationSecs:2 In:_canvas];
}


- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)resetZoomButton:(id)sender {
    if (DEBUG) {
        NSLog(@"_canvasWindow's zoomscale (before): %.2f",[_canvasWindow zoomScale]);
    }
    [_canvasWindow setZoomScale:1];
    if (DEBUG) {
        NSLog(@"_canvasWindow's zoomscale (after): %.2f",[_canvasWindow zoomScale]);
    }
}

- (IBAction)gridSnappingButton:(id)sender {
    // Toggles snapping to grid feature.
    if (_snapToGridEnabled) {
        // Grid snapping: ON -> OFF
        [_grid removeFromSuperview]; //hide.
        _snapToGridEnabled = NO; //toggle.
    }
    else {
        // Grid snapping: OFF -> ON
        _grid = [[GridView alloc]initWithFrame:CGRectMake(0, 0, _actualCanvasWidth, _actualCanvasHeight)
                                          Step:50
                                     LineColor:[ViewHelper invColorOf:[_canvas backgroundColor]]];
        [_canvas addSubview:_grid]; //Show.
        [_canvas sendSubviewToBack:_grid]; //Don't block notes.
        _snapToGridEnabled = YES; //Toggle.
    }
}

- (IBAction)minimapButton:(id)sender {
    
    if (_minimapEnabled) { 
        [_minimapView removeFromSuperview];
        _minimapEnabled = NO; //toggle.
    }
    else {
        _minimapView = [[MinimapView alloc]initWithMinimapDisplayFrame:CGRectMake(800, 480, 200, 200) MapOf:_canvas PopulateWith:_notesArray];
        [_minimapView setAlpha:0.8]; // make transparent.
        [self.view addSubview:_minimapView];
        _minimapEnabled = YES; //toggle.
    }
    
}


- (IBAction)unplacedNotesButton:(id)sender {
    // Check if there are any notes in unplaced notes array.
    if (_unplacedNotesArray.count == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"You have no more unplaced notes."]
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [alert show];
        return; //terminate
    }
    
    // Limit the number of fresh UNplaced notes that can be floating in front of the canvas window.
    if (_temporaryHoldingAreaForNotes.count >= CANVAS_WINDOW_UNPLACED_FRESH_NOTE_LIM) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"You should arrange your new notes before adding more new notes. Your stack of notes building up in front of your screen is blocking a vital part of your screen."]
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:@"OK I'll clear up my new notes."
                                             otherButtonTitles:nil];
        [alert show];
        return; //terminate
    }
    
    
    
    // Retrieve
    Note *noteToBePlacedSoon = (Note*)[_unplacedNotesArray objectAtIndex:0];
    // Remove from unplaced notes array.
    [_unplacedNotesArray removeObjectAtIndex:0];
    // decrement count of unplaced notes and display on button.
    _unplacedNotesButton.title = [NSString stringWithFormat:@"%d Unplaced Notes",_unplacedNotesArray.count];
    // Add to holding area
    [_temporaryHoldingAreaForNotes addObject:noteToBePlacedSoon];
    
    // Determine coordinates of new note
    CGPoint centerOfNewNote = CGPointMake(_canvasWindow.bounds.size.width/2.0, _canvasWindow.bounds.size.height/2.0);
    [noteToBePlacedSoon.view setCenter:centerOfNewNote];
    
    [_temporaryHoldingAreaForNotes addObject:(Note*)noteToBePlacedSoon]; // Stored in property
    [self.view addSubview:noteToBePlacedSoon.view]; // Visible to user
    noteToBePlacedSoon.view.alpha = 0.6; //Dim note's appearance.
    
    /*Attach gesture recognizers*/
    
    // UNplaced notes can be dragged and placed.
    UIPanGestureRecognizer *panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(unplacedNotePanResponse:)];
    [noteToBePlacedSoon.view addGestureRecognizer:panRecog];
    
    // UNplaced notes are editable.
    UITapGestureRecognizer *doubleTapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteDoubleTapResponse:)];
    doubleTapRecog.numberOfTapsRequired = 2;
    [noteToBePlacedSoon.view addGestureRecognizer:doubleTapRecog];
}


- (IBAction)saveButton:(id)sender {
    [_delegate updateDiagram:[self generateDiagramModel]];
}


#pragma mark - Edit Note Toolbar

-(void)createEditNoteToolBar{
    _editNoteToolBar = [[UIToolbar alloc]init];
    _editNoteToolBar.frame = CGRectMake(0, 0, 1024, 44);
    //create buttons
    //TODO enhance intuitivity of symbols on buttons.
    UIBarButtonItem *boldButton = [[UIBarButtonItem alloc]initWithTitle:@"B" style:UIBarButtonItemStyleBordered target:self action:@selector(didPressBoldButton:)];
    UIBarButtonItem *italicsButton = [[UIBarButtonItem alloc]initWithTitle:@"I" style:UIBarButtonItemStyleBordered target:self action:@selector(didPressItalicsButton:)];
//    UIBarButtonItem *underlineButton = [[UIBarButtonItem alloc]initWithTitle:@"Underline" style:UIBarButtonItemStyleBordered target:self action:@selector(underlineText:)];
    UIBarButtonItem *fontButton = [[UIBarButtonItem alloc]initWithTitle:@"Font" style:UIBarButtonItemStyleBordered target:self action:@selector(didPressFontButton:Event:)];
    UIBarButtonItem *textColorButton = [[UIBarButtonItem alloc]initWithTitle:@"Text Color" style:UIBarButtonItemStyleBordered target:self action:@selector(didPresstextColorButton:Event:)];
    UIBarButtonItem *noteColorButton = [[UIBarButtonItem alloc]initWithTitle:@"Note Color" style:UIBarButtonItemStyleBordered target:self action:@selector(didPressNoteMaterialButton:Event:)];
    UIBarButtonItem *deleteNoteButton = [[UIBarButtonItem alloc]initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(didPressDeleteNoteButton:)];
    //Put buttons in an array
    NSArray *buttonArr = [NSArray arrayWithObjects:boldButton,italicsButton,fontButton,textColorButton,noteColorButton,deleteNoteButton, nil];
    //Add the array of buttons into toolbar
    [_editNoteToolBar setItems:buttonArr animated:NO];
    
    /*Initialise popover views*/
    
    // Material Picker
    _materialPicker = [[UserOptionsLoadPicker alloc]
                       initWithOptions:[[NSArray alloc] initWithObjects:
                                        NOTE_MATERIAL_BLUE_PAPER_PRETTYNAME,
                                        NOTE_MATERIAL_GREEN_PAPER_PRETTYNAME,
                                        NOTE_MATERIAL_RED_PAPER_PRETTYNAME,
                                        NOTE_MATERIAL_WHITE_PAPER_PRETTYNAME,
                                        NOTE_MATERIAL_YELLOW_PAPER_PRETTYNAME,nil]];
    _materialPicker.delegate = self;
    
    // Font Picker
    self.fontPicker = [[UserOptionsLoadPicker alloc]
                       initWithOptions:[[NSArray alloc] initWithObjects:fBASKERVILLE,fCOCHIN,fGEORGIA,fGILLSANS,fHELVETICA_NEUE,fVERDANA,nil]];
    self.fontPicker.delegate = self;
}

#pragma mark Note Font

- (IBAction)didPressBoldButton:(id)sender{
    UIFont* font = [self.noteBeingEdited getFont];
    
    // Minus bold.
    if ([FontHelper isBold:font] || [FontHelper isBoldAndItalics:font]){
        font = [FontHelper minusBoldFrom:font];
    }
    // Add bold.
    else if ([FontHelper isNotImbuedWithModifier:font] || [FontHelper isOnlyItalics:font]){
        font = [FontHelper addBoldTo:font];
    }
    // Error.
    else
        [NSException raise:@"font does not fall into categories developer thought it would." format:@"%s",__FUNCTION__];
    
    [self.noteBeingEdited setFont:font];
}

- (IBAction)didPressItalicsButton:(id)sender{
    UIFont* font = [self.noteBeingEdited getFont];
    
    // Minus italics.
    if ([FontHelper isOnlyItalics:font] || [FontHelper isBoldAndItalics:font])
        font = [FontHelper minusItalicsFrom:font];

    // Add italics.
    else if ([FontHelper isNotImbuedWithModifier:font] || [FontHelper isBold:font])
        font = [FontHelper addItalicsTo:font];
    
    //Error.
    else
        [NSException raise:@"font does not fall into categories developer thought it would." format:@"%s",__FUNCTION__];
    
    [self.noteBeingEdited setFont:font];
}

//- (IBAction)underlineText:(id)sender{
//    
//}

- (IBAction)didPressFontButton:(id)sender Event:(UIEvent*)event{
    self.optionsPickerPopOver = [[UIPopoverController alloc]
                                 initWithContentViewController:self.fontPicker];
    
    [self.optionsPickerPopOver presentPopoverFromRect:[[event.allTouches anyObject] view].frame
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionUp
                                             animated:YES];
    
    [self.optionsPickerPopOver setPopoverContentSize:CGSizeMake(150,270) animated:NO];
}

-(void)optionSelected:(NSString *)option{
    
    if ([_optionsPickerPopOver.contentViewController isEqual:_fontPicker]) { // If _fontPicker is the popover.
        
        UIFont* beforeFont = [self.noteBeingEdited getFont];
        UIFont* afterFont = [UIFont fontWithName:option size:FONT_DEFAULT_SIZE];
        
        if ([FontHelper isBoldAndItalics:beforeFont]) {
            UIFont* g = [FontHelper addBoldTo:afterFont];
            g = [FontHelper addItalicsTo:g];
            [self.noteBeingEdited setFont:g];
        }
        else if ([FontHelper isOnlyItalics:beforeFont]) {
            UIFont* g = [FontHelper addItalicsTo:afterFont];
            [self.noteBeingEdited setFont:g];
        }
        else if ([FontHelper isBold:beforeFont]) //Only -Bold, since -BoldItalic has been checked in first conditional statement.
        {
            UIFont* g = [FontHelper addBoldTo:afterFont];
            [self.noteBeingEdited setFont:g];
        }
        else {
            [self.noteBeingEdited setFont:[UIFont fontWithName:option size:FONT_DEFAULT_SIZE]];
        }
    }
    
    else if ([_optionsPickerPopOver.contentViewController isEqual:_materialPicker]){ // If _materialPicker is the popover.
        [_noteBeingEdited setMaterialWithPictureFileName:[Constants FileNameOfNoteMaterial:option]];
    }
    
}

#pragma mark Note Text Color

- (IBAction)didPresstextColorButton:(id)sender Event:(UIEvent*)event{
    if (!self.wePopoverController) {
        
		ColorViewController *contentViewController = [[ColorViewController alloc] init];
        contentViewController.delegate = self;
		self.wePopoverController = [[WEPopoverController alloc] initWithContentViewController:contentViewController];
		self.wePopoverController.delegate = self;
        
		[self.wePopoverController presentPopoverFromRect:[[event.allTouches anyObject] view].frame
                                                  inView:self.view
                                permittedArrowDirections:(UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown)
                                                animated:YES];
        
	} else {
		[self.wePopoverController dismissPopoverAnimated:YES];
        self.wePopoverController = nil;
	}
}

-(void) colorPopoverControllerDidSelectColor:(NSString *)hexColor{
    [_noteBeingEdited setTextColor:[GzColors colorFromHex:hexColor]];
    [_noteBeingEdited setTextColorGZColorString:hexColor];//TODO temporary fix.
}

- (void)popoverControllerDidDismissPopover:(WEPopoverController *)thePopoverController {
	//Safe to release the popover here
	self.wePopoverController = nil;
}

- (BOOL)popoverControllerShouldDismissPopover:(WEPopoverController *)thePopoverController {
	//The popover is automatically dismissed if you click outside it, unless you return NO here
	return YES;
}

#pragma mark Note Material

- (IBAction)didPressNoteMaterialButton:(id)sender Event:(UIEvent*)event{
    
        _optionsPickerPopOver = [[UIPopoverController alloc]
                                     initWithContentViewController:_materialPicker];
    
    [_optionsPickerPopOver presentPopoverFromRect:[[event.allTouches anyObject] view].frame
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionUp
                                             animated:YES];
    
    [_optionsPickerPopOver setPopoverContentSize:CGSizeMake(120,220) animated:NO];
}

- (IBAction)didPressDeleteNoteButton:(id)sender{
    
    if ([_notesArray containsObject:_noteBeingEdited]) {
        [self removePlacedNote:_noteBeingEdited];
    }
    else if ([_temporaryHoldingAreaForNotes containsObject:_noteBeingEdited]){
        [self removeUNplacedFreshNote:_noteBeingEdited];
    }
    else{
        [NSException raise:@"Note being edited is neither placed nor unplaced." format:@"%s",__FUNCTION__];
    }
    
    [self.view endEditing:YES];
    _editingANote = NO;
    _noteBeingEdited = nil;
    
    //Reinstate _canvasWindow to original size
    _canvasWindow.frame=CGRectMake(_canvasWindow.frame.origin.x, _canvasWindow.frame.origin.y, _canvasWindow.frame.size.width, _canvasWindowOrigHeight);
    
    //Hide tool bar related to editing notes
    [_editNoteToolBar removeFromSuperview];
}

#pragma mark Note Textual Content

/******* UITextViewDelegate method *******/
/*
 ** The delegate method below concerns editing of the text in a UITextView.
 ** Character limits are enforced here.
 */
-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSUInteger newLength = [textView.text length]+[text length] - range.length;
    
    if (newLength > NOTE_CONTENT_CHAR_LIM) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Cannot exceed %d characters.",NOTE_CONTENT_CHAR_LIM]
                                                       message:nil
                                                      delegate:self
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
        [alert show];
        [alert performSelector:@selector(dismissAnimated:) withObject:(BOOL)NO afterDelay:0.0f];
        
        return NO;
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    [_noteBeingEdited setContent:textView.text];
}

#pragma mark - Generate/Load Diagram Models.

-(Diagram*)generateDiagramModel{
    
    _diagramModel.title = @"david is testing";
    _diagramModel.width = _canvas.bounds.size.width;
    _diagramModel.height = _canvas.bounds.size.height;
    _diagramModel.color = _canvasColorHexValue;//TODO temporary fix.
    
    [_diagramModel.placedNotes removeAllObjects];//IMPT! If this edit diagram VC loaded a diagram from ProjectDiagramVC, then this array is likely to begin non-empty. Clear it first, fill it up with this VC's stuff.
    
    for (Note* eachNote in _notesArray) {
        NoteM* model = [eachNote generateModel];
        [_diagramModel.placedNotes addObject:model];
    }
    
    [_diagramModel.unplacedNotes removeAllObjects];//IMPT! If this edit diagram VC loaded a diagram from ProjectDiagramVC, then this array is likely to begin non-empty. Clear it first, fill it up with this VC's stuff.
    
    for (Note* eachNote in _unplacedNotesArray) {
        NoteM* model = [eachNote generateModel];
        [_diagramModel.unplacedNotes addObject:model];
    }
    
    return _diagramModel;
}

-(void)loadWithDiagramModel:(Diagram*)aDiagramModel
{
    /* Steps
     1. Clear out all note arrays. (Placed, unplaced, etc.)
     2. Remake space of physics engine.
     3. Resize canvas.
     3.5. Color canvas.
     4. Load title
     5. Fill up all note arrays. (Placed, unplaced, etc.)
     */
    
    //1.
    [self clearPlacedNotesArray];
    [self clearUNplacedFreshNotesArray];
    [self clearUNplacedNotesArray];
    
    //2. & 3.
    // Update actual canvas height and width. //TODO DEL
    _actualCanvasHeight = aDiagramModel.height;
    _actualCanvasWidth = aDiagramModel.width;
    
    _canvas.bounds = CGRectMake(0, 0, _actualCanvasWidth, _actualCanvasHeight);
    
    if (_snapToGridEnabled) {
        [_grid removeFromSuperview]; //hide.
        _grid = [[GridView alloc]initWithFrame:CGRectMake(0, 0, _actualCanvasWidth, _actualCanvasHeight)
                                          Step:50
                                     LineColor:[ViewHelper invColorOf:[_canvas backgroundColor]]];
        [_canvas addSubview:_grid]; //Show.
        [_canvas sendSubviewToBack:_grid]; //Don't block notes.
    }
    
    
    
    // Modify _canvas.
    [_canvas setFrame:CGRectMake(_canvas.frame.origin.x,
                                 _canvas.frame.origin.y,
                                 _actualCanvasWidth*[_canvasWindow zoomScale],
                                 _actualCanvasHeight*[_canvasWindow zoomScale])];
    
    // Center content view in _canvasWindow. Don't know why this works. But it does.
    [_canvasWindow setZoomScale:[_canvasWindow zoomScale]-0.01 animated:NO]; //Scale to something slightly smaller than zoomscale that we used before segueing to canvas settings controller.
    [_canvasWindow setZoomScale:[_canvasWindow zoomScale] animated:YES]; //Reinstate zoomScale before changing canvas settings
    
    // Modify _space. (Destroy and make anew);
    _space = nil;
    _space = [[ChipmunkSpace alloc] init];
    [_space addBounds:_canvas.bounds
            thickness:100000.0f elasticity:0.0f friction:1.0f layers:CP_ALL_LAYERS group:CP_NO_GROUP collisionType:borderType];
    [_space setGravity:cpv(0, 0)];
    [self createCollisionHandlers];//MUST ALSO REASSIGN COLLISION HANDLERS.
    
    // Redo minimap
    if (_minimapEnabled) {
        [_minimapView removeFromSuperview];
        _minimapView = [[MinimapView alloc]initWithMinimapDisplayFrame:CGRectMake(800, 480, 200, 200) MapOf:_canvas PopulateWith:_notesArray];
        [_minimapView setAlpha:0.8]; // make transparent.
        [self.view addSubview:_minimapView];
    }
    
    // 3.5
    _canvasColorHexValue = aDiagramModel.color;
    _canvas.backgroundColor = [GzColors colorFromHex:aDiagramModel.color];
    
    // 4. Currently no place to store title in this VC.
    
    // 5.
    for (NoteM* eachNoteModel in aDiagramModel.placedNotes) {
        Note* eachToBePlacedNote = [[Note alloc]initWithText:@""];
        [eachToBePlacedNote loadWithModel:eachNoteModel];
        [self addPlacedNote:eachToBePlacedNote];
    }
    
    for (NoteM* eachNoteModel in aDiagramModel.unplacedNotes) {
        Note* eachToBePlacedNote = [[Note alloc]initWithText:@""];
        [eachToBePlacedNote loadWithModel:eachNoteModel];
        [_unplacedNotesArray addObject:eachToBePlacedNote];
    }

    _unplacedNotesButton.title = [NSString stringWithFormat:@"%d Unplaced Notes",_unplacedNotesArray.count];

}

#pragma mark - Programmatically Removing/Adding notes to holding arrays

// Placed notes.

-(void)addPlacedNote:(Note*)n1{
    
    //Attach gesture recognizers to view part of note
    UIPanGestureRecognizer *panRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(notePanResponse:)];
    [n1.view addGestureRecognizer:panRecog];
    
    UITapGestureRecognizer *doubleTapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteDoubleTapResponse:)];
    doubleTapRecog.numberOfTapsRequired = 2;
    [n1.view addGestureRecognizer:doubleTapRecog];
    
    //Add view part to canvas.
    [_canvas addSubview:n1.view];
    
    //Add to placed notes array.
    [_notesArray addObject:n1];
    
    //Add body part to physics engine.
    [_space add:n1];
}

-(void)removePlacedNote:(Note*)n1{
    
    [n1.view setUserInteractionEnabled:NO]; // for safety reasons.
    [n1.view removeFromSuperview];
    if ([_space contains:n1]) {
        [_space remove:n1];
    }
    [_notesArray removeObjectIdenticalTo:n1];
}

-(void)clearPlacedNotesArray{
    for (Note* eachNote in _notesArray) {
        [eachNote.view setUserInteractionEnabled:NO];//safety reasons
        [eachNote.view removeFromSuperview];
        if ([_space contains:eachNote]) {
            [_space remove:eachNote];
        }
    }
    [_notesArray removeAllObjects];
}

// Unplaced notes with non-trivial content.

-(void)removeUNplacedNote:(Note*)n1{
    [n1.view setUserInteractionEnabled:NO]; // for safety reasons.
    [n1.view removeFromSuperview];
    if ([_space contains:n1]) {
        [_space remove:n1];
    }
    [_unplacedNotesArray removeObjectIdenticalTo:n1];
}

-(void)clearUNplacedNotesArray{
    for (Note* eachNote in _unplacedNotesArray) {
        [eachNote.view setUserInteractionEnabled:NO];//safety reasons
        [eachNote.view removeFromSuperview];
        if ([_space contains:eachNote]) {
            [_space remove:eachNote];
        }
    }
    [_unplacedNotesArray removeAllObjects];
}


// Unplaced fresh notes.

-(void)removeUNplacedFreshNote:(Note*)n1{
    [n1.view setUserInteractionEnabled:NO]; // for safety reasons.
    [n1.view removeFromSuperview];
    if ([_space contains:n1]) {
        [_space remove:n1];
    }
    [_temporaryHoldingAreaForNotes removeObjectIdenticalTo:n1];
}

-(void)clearUNplacedFreshNotesArray{
    for (Note* eachNote in _temporaryHoldingAreaForNotes) {
        [eachNote.view setUserInteractionEnabled:NO];//safety reasons
        [eachNote.view removeFromSuperview];
        if ([_space contains:eachNote]) {
            [_space remove:eachNote];
        }
    }
    [_temporaryHoldingAreaForNotes removeAllObjects];
}

#pragma mark - Chipmunk Physics Engine

// When the view appears on the screen, start the animation timer and tilt callbacks.
- (void)viewDidAppear:(BOOL)animated {
	// Set up the display link to control the timing of the animation.
	_displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
	_displayLink.frameInterval = 1;
	[_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

// The view disappeared. Stop the animation timers and tilt callbacks.
- (void)viewDidDisappear:(BOOL)animated {
	// Remove the timer.
	[_displayLink invalidate];
	_displayLink = nil;
}

// This method is called each frame to update the scene.
// It is called from the display link every time the screen wants to redraw itself.
- (void)update {
	// Step (simulate) the space based on the time since the last update.
	cpFloat dt = _displayLink.duration*_displayLink.frameInterval;
	[_space step:dt];
    
    for (Note* eachNote in _notesArray) {
        [eachNote updatePos];
    }
    
//    for (Note* eachNote in _temporaryHoldingAreaForNotes) {
//        [eachNote updatePos];
//    }
    
    if (_minimapEnabled) {
        [_minimapView removeAllNotes];
        [_minimapView remakeWith:_notesArray];
        
        
        /* Begin algorithm to compute CGRect of visible area in _canvas. (x,y,w,h) of this CGRect is w.r.t _canvas. */
        CGRect visibleRect = [ViewHelper visibleRectOf:_canvas thatIsSubViewOf:_canvasWindow withParentMostView:self.view];
        /* algo ends*/
        
        [_minimapView setScreenTrackerFrame:visibleRect]; //set the rect outline in minimap that depicts the area of _canvas that is visible to user.
        
    }
}

-(void)createCollisionHandlers{
    [_space addCollisionHandler:self
                          typeA:[Note class] typeB:borderType
                          begin:@selector(beginCollision:space:)
                       preSolve:nil
                      postSolve:nil
                       separate:nil
     ];
}

- (bool)beginCollision:(cpArbiter*)arbiter space:(ChipmunkSpace*)space {
	CHIPMUNK_ARBITER_GET_SHAPES(arbiter, noteShape, border);
    ((Note*)(noteShape.data)).body.angle = 0.6; // Hack to get notes that are parallel to wall to bounce off walls.
	return TRUE;
}


#pragma mark - Grid


//empty


#pragma mark - UIScrollView delegate methods

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _canvas;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (DEBUG)
        [DebugHelper printUIScrollView:scrollView :@"scrollview didZoom"];
    
    // Center content view during zooming.
    ((UIView*)[scrollView.subviews objectAtIndex:0]).frame = [ViewHelper centeredFrameForScrollViewWithNoContentInset:scrollView AndWithContentView: ((UIView*)[scrollView.subviews objectAtIndex:0])];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (DEBUG){
//        [DebugHelper printUIScrollView:scrollView :@"scrollview didScroll"];
//        NSLog(@"canvas didScroll %@",_canvas);
//    }
//}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    // Center content view during zooming.
    ((UIView*)[scrollView.subviews objectAtIndex:0]).frame = [ViewHelper centeredFrameForScrollViewWithNoContentInset:scrollView AndWithContentView: ((UIView*)[scrollView.subviews objectAtIndex:0])];
    [DebugHelper printUIScrollView:_canvasWindow :@"canvas window dbg1111"];
}

#pragma mark - Keyboard Management

- (void)setupKeyboardMgmt {
    // Set up to link to do adjustments when showing and hiding the keyboard.
    // An e.g. of an adjustment is resizing the _canvasWindow to occupy the space above the keyboard when the keyboard is shown.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)keyboardWillShow:(NSNotification*)notification{
    
    //Move _canvasWindow to show the note being edited. _canvasWindow is resized.
    _canvasWindow.frame=CGRectMake(_canvasWindow.frame.origin.x, _canvasWindow.frame.origin.y, _canvasWindow.frame.size.width, 400);
    CGRect rc = [_noteBeingEdited.view convertRect:CGRectMake(0, 0, _noteBeingEdited.view.frame.size.width, _noteBeingEdited.view.frame.size.height) toView:_canvasWindow];
    [_canvasWindow scrollRectToVisible:rc animated:YES];
    
}

-(void)keyboardWillHide:(NSNotification*)notification{
    // Adjust the state of this Controller.
    _editingANote = NO;
    // Invalidate pointer to note that was being edited.
    _noteBeingEdited = nil;
    
    
    //Reinstate _canvasWindow to original size.
    _canvasWindow.frame=CGRectMake(_canvasWindow.frame.origin.x, _canvasWindow.frame.origin.y, _canvasWindow.frame.size.width, _canvasWindowOrigHeight);
    
    //Hide tool bar related to editing notes.
    [_editNoteToolBar removeFromSuperview];
    
    //Hide edit note text platform
    [_editNoteTextPlatform removeFromSuperview];
}


#pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if((toInterfaceOrientation == UIDeviceOrientationLandscapeRight) ||
       (toInterfaceOrientation == UIDeviceOrientationLandscapeLeft))
        return YES;
    else
        return NO;
}


#pragma mark - Don't Care

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCanvasWindow:nil];
    [self setGridSnappingButton:nil];
    [self setUnplacedNotesButton:nil];
    [super viewDidUnload];
}

@end
