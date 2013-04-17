//
//  AllProjectsViewController.m
//  VinoCharts
//
//  Created by Hendy Chua on 24/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "AllProjectsViewController.h"

@interface AllProjectsViewController ()

//needed to load user dropbox account info
@property NSTimer* timer;

@end

@implementation AllProjectsViewController

@synthesize optionsPicker;
@synthesize optionsPickerPopOver;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*
-(UIActivityIndicatorView *)indicator{
    //show loading sign to user and prevent user using the app while loading
    if(!_indicator){
        _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.frame = self.view.bounds;
        _indicator.center = self.view.center;
        [_indicator.layer setFrame:self.view.bounds];
        [_indicator.layer setContentsCenter:self.view.bounds];
        [_indicator.layer setBackgroundColor:[[UIColor colorWithWhite: 0.0 alpha:0.30] CGColor]];
        [self.view addSubview:_indicator];
        [_indicator bringSubviewToFront:self.view];
    }
    return _indicator;
}
*/
/*
- (void)saveState{
    //currently not in used, maybe not needed cause got autosaving
    //EFFECTS: save current data in context
    [self.database saveToURL:self.database.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // customizing the navigation bar
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    UILabel *navBarTitle = (UILabel *)self.navigationItem.titleView;
    if (!navBarTitle) {
        navBarTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        navBarTitle.backgroundColor = [UIColor clearColor];
        navBarTitle.font = [UIFont boldSystemFontOfSize:20.0];        
        navBarTitle.textColor = [UIColor blackColor];
        [navBarTitle setText:@"All Projects"];
        [navBarTitle sizeToFit];
        self.navigationItem.titleView = navBarTitle;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"chalkboard_frame.png"] forBarMetrics:UIBarMetricsDefault];
    }
    [self setRightBarButtonToDefaultMode];
    
    // background image
    UIImage *backgroundImage = [UIImage imageNamed:@"chalkboard_board.png"];
	UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
    [self.view addSubview:background];
    [self.view sendSubviewToBack:background];
    
    // if user did not sign in with dropbox, provide a leftbarbuttonitem in the navigation bar for the user to tap and sign in
    // else if user signed in, provide a leftbarbuttonitem addressing his email/name and provide logout option when tapped
    if (![[DBSession sharedSession] isLinked]) {
        // not signed in
        UIBarButtonItem *syncButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign-in with Dropbox"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(signInWithDropBox)];
        [self.navigationItem setLeftBarButtonItem:syncButton];
    } else {
        // signed in
        [[DropboxViewController sharedDropbox] loadDropboxAccountInfo];
        [[DropboxViewController sharedDropbox]setDelegate:self];
        
        UIBarButtonItem *ackButton = [[UIBarButtonItem alloc] initWithTitle:LOADING
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                     action:@selector(displaySignedInOptions)];
        [self.navigationItem setLeftBarButtonItem:ackButton];
    }
    
    self.modelsArray = [[Model sharedModel] allProjects];
}

//load data delegate
-(void)projectLoaded{
    //will rerender view with newly added project
    self.modelsArray = self.model.allProjects;
    NSLog(@"project loaded");
    [self reloadModelsArrayAndRepresentationArray];
    [self fillUpTiles];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"transitToCreateProjectModal"]) {
        [[segue destinationViewController] setDelegate:self];
    } else if ([[segue identifier] isEqualToString:@"transToSingleProjectView"]) {
        for (SingleProjectViewController* spvc in [[segue destinationViewController] viewControllers]) {
            [spvc setProject:selectedProject];
        }
    }
}

-(void)createNewProject {
    [self performSegueWithIdentifier:@"transitToCreateProjectModal" sender:self];
}

- (void)newProjectCreated:(Project *)project {
    self.modelsArray  = self.model.allProjects;
    [self reloadModelsArrayAndRepresentationArray];
    [self fillUpTiles];
}

-(void)signInWithDropBox {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                      target:self
                                                    selector:@selector(checkAndReloadAccountInfo)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

-(void)displaySignedInOptions {
    if (self.optionsPicker == nil) {
        self.optionsPicker = [[UserOptionsLoadPicker alloc]
                           initWithStyle:UITableViewStylePlain];
        self.optionsPicker.delegate = self;
        self.optionsPickerPopOver = [[UIPopoverController alloc]
                                  initWithContentViewController:self.optionsPicker];
    }
    [self.optionsPickerPopOver presentPopoverFromRect:self.navigationItem.leftBarButtonItem.accessibilityFrame inView:self.view
                          permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}

- (void)optionSelected:(NSString *)option {
    [self.optionsPickerPopOver dismissPopoverAnimated:YES];
    if([option isEqualToString:@"Logout"]){
        [[DBSession sharedSession] unlinkAll];
    
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if([option isEqualToString:@"Sync"]){
        [[DropboxViewController sharedDropbox] uploadPersistentStore];
//        UIImage* tempImage = [UIImage imageNamed:@"introbox.png"];
//        PreviewDiagramViewController* pr = [[PreviewDiagramViewController alloc] initWithImage:tempImage Title:@"diagram" ProjectTitle:@"project"];
//        [self.navigationController pushViewController:pr animated:YES];
    }
}

-(void)tileSelected:(id)model {
    selectedProject = model;
    [self performSegueWithIdentifier:@"transToSingleProjectView" sender:self];
}

-(void)longPressActivated {
    [self setRightBarButtonToDeletingMode];
    [self showDeleteButtonOnTiles];
}

-(void)finishDeletingMode {
    [super finishDeletingMode];
    [self setRightBarButtonToDefaultMode];
}

//changed to delete with index
-(void)deleteTile:(id)model {
    Project*proj = model;
    
    // delete the actual project object
    for (int i=0; i<[self.modelsArray count]; i++) {
        Project *p = (Project*)[self.modelsArray objectAtIndex:i];
        if (p == proj) {
            [self.model removeProjectAtIndex:i];
            break;
        }
    }
    self.modelsArray = self.model.allProjects;

    [self reloadModelsArrayAndRepresentationArray];
    [self fillUpTiles];
    [self showDeleteButtonOnTiles];
}

-(void)reloadModelsArrayAndRepresentationArray {
    if (self.modelsRepresentationArray != nil) {
        for (ProjectOverviewViewController* p in self.modelsRepresentationArray) {
            [p.tileImageView removeFromSuperview];
        }
    }
    self.modelsRepresentationArray = nil;
    self.modelsRepresentationArray = [NSMutableArray array];
    
    // creating the project overviews
    for (int i=0; i<[self.modelsArray count]; i++) {
        Project *proj = (Project *)[self.modelsArray objectAtIndex:i];
        
        ProjectOverviewViewController *p = [[ProjectOverviewViewController alloc] initWithModel:proj Delegate:self];
        [self.modelsRepresentationArray addObject:p];
    }
}

-(void)setRightBarButtonToDeletingMode {
    UIBarButtonItem *doneDeleting = [[UIBarButtonItem alloc] initWithTitle:@"Done Deleting"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(finishDeletingMode)];
    [doneDeleting setTintColor:[UIColor redColor]];
    [self.navigationItem setRightBarButtonItem:doneDeleting];
}

- (void)setRightBarButtonToDefaultMode {
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(createNewProject)];
    [self.navigationItem setRightBarButtonItem:addButton];
}

-(void)viewDidAppear:(BOOL)animated {    
    //for load data
    self.model = [Model sharedModel];
    self.model.delegate = self;
    self.modelsArray = [[Model sharedModel] allProjects];
    //render view
    [self reloadModelsArrayAndRepresentationArray];
    [self fillUpTiles];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Override to allow orientations other than the default portrait orientation.
// Rotation for v. 5.1.1
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)viewDidUnload {    
    [super viewDidUnload];
}

/**************************** Dropbox ****************************/

-(void)accountInfoLoaded:(NSString *)userName{
    UIBarButtonItem *ackButton = [[UIBarButtonItem alloc] initWithTitle:userName
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(displaySignedInOptions)];
    [self.navigationItem setLeftBarButtonItem:ackButton];
}

- (void)checkAndReloadAccountInfo{
    //account info may not be loaded if sign in process not yet complete
    if ([[DBSession sharedSession] isLinked]) {
        [[DropboxViewController sharedDropbox] loadDropboxAccountInfo];
        [[DropboxViewController sharedDropbox] setDelegate:self];
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
