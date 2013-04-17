//
//  DropboxViewController.m
//  VinoCharts
//
//  Created by Ang Civics on 30/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "DropboxViewController.h"

@interface DropboxViewController ()

@property NSString* currentPath;
@property NSString* localPath;//temp use to set the segue destination location

@end

@implementation DropboxViewController

static DropboxViewController* sharedDropbox = nil;

+(DropboxViewController*)sharedDropbox{
    if(sharedDropbox == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedDropbox = [[DropboxViewController alloc] initWithPath:DROPBOX_ROOT_PATH];
        });
    }
    return sharedDropbox;
}

//must to access dropbox
@synthesize restClient;
- (DBRestClient *)restClient {
    if (!restClient) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || (interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithPath:(NSString*)path{
    self.currentPath = path;
    [self.restClient loadMetadata:DROPBOX_ROOT_PATH];
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    if(!self.currentPath){
        self.currentPath = DROPBOX_ROOT_PATH;// situation when push with storyboard
    }
    
    [[self restClient] loadMetadata:self.currentPath];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = [self.currentPath isEqual:DROPBOX_ROOT_PATH] ? @"Dropbox" : self.currentPath;
}

-(void)setNavBar {
    NSString *controllerTitle = @"Dropbox Files";
    UILabel *navBarTitle = (UILabel *)self.navigationItem.titleView;
    if (!navBarTitle) {
        navBarTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        navBarTitle.backgroundColor = [UIColor clearColor];
        navBarTitle.font = [UIFont boldSystemFontOfSize:20.0];
        navBarTitle.textColor = [UIColor blackColor];
        [navBarTitle setText:controllerTitle];
        [navBarTitle sizeToFit];
        self.tabBarController.navigationItem.titleView = navBarTitle;
    }
    
    // Set the right bar button
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [self setNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.metadata){
        return [self.metadata.contents count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
    DBMetadata *info = [self.metadata.contents objectAtIndex:[indexPath row]];
	cell.textLabel.text = info.filename;
	if (info.isDirectory) {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	} else {
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.metadata.contents count] <= [indexPath row]) return;
    
	DBMetadata *info = [self.metadata.contents objectAtIndex:[indexPath row]];
    
    if (info.isDirectory) {
        DropboxViewController *controller = [[DropboxViewController alloc] initWithPath:[self.currentPath stringByAppendingPathComponent:info.filename]];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if([info.filename hasSuffix:PNG_SUFFIX] || [info.filename hasSuffix:JPEG_SUFFIX]){
        [self.restClient loadFile:[self.currentPath stringByAppendingPathComponent:info.filename] intoPath:[NSTemporaryDirectory() stringByAppendingPathComponent:info.filename]];
    }
    else if([info.filename isEqualToString:PERSISTENT_STORE]){
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"Load Project" message:@"Do you want to proceed to load all of the project from this database?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alertView show];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex == alertView.cancelButtonIndex){
        return;
    }else{
        NSURL* url = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:STORE_CONTENT];
        [[NSFileManager defaultManager] createDirectoryAtURL:url withIntermediateDirectories:YES attributes:nil error:nil];
        [self.restClient loadFile:[self.currentPath stringByAppendingPathComponent:PERSISTENT_STORE]
                         intoPath:[url.path stringByAppendingPathComponent:PERSISTENT_STORE]];
    }
}

/********** account info ************/
- (void) loadDropboxAccountInfo{
    [[self restClient] loadAccountInfo];
}

- (void)restClient:(DBRestClient*)client loadedAccountInfo:(DBAccountInfo*)info {
    //load user dropbox account info and set left bar button
    NSLog(@"UserID: %@ %@", [info displayName], [info userId]);
    [self.delegate accountInfoLoaded:[info displayName]];
}

/************ folder ***************/

- (void)restClient:(DBRestClient*)client createdFolder:(DBMetadata*)folder{
    // Folder is the metadata for the newly created folder
    [self.restClient loadMetadata:DROPBOX_ROOT_PATH];
    [self startUploadTo:folder.filename at:(DBMetadata*)folder];
    NSLog(@"Folder created succesfully in dropbox at %@",folder.path);
    
}
- (void)restClient:(DBRestClient*)client createFolderFailedWithError:(NSError*)error{
    // [error userInfo] contains the root and path
    NSLog(@"Folder failed to create in dropbox");
}

- (void)changeProjectName:(NSString*)old To:(NSString*)new{
    [self.restClient moveFrom:[DROPBOX_ROOT_PATH stringByAppendingPathComponent:old] toPath:[DROPBOX_ROOT_PATH stringByAppendingPathComponent:new]];
}

/************ upload file ***************/


- (NSString*)getRevWithName:(NSString*)name InMetadata:(DBMetadata*)data{
    for(DBMetadata* info in data.contents){
        if([info.filename isEqualToString:name] && !info.isDirectory){
            return info.rev;
        }
    }
    return nil;
}

-(void)uploadImageAtTemporaryDirectoryToFolder:(NSString *)folderName{
    for(DBMetadata* file in self.metadata.contents){
        if([file.filename isEqualToString:folderName] && [file isDirectory]){
            [self.restClient loadMetadata:file.path];
            return;
        }
    }
    
    [restClient createFolder:[DROPBOX_ROOT_PATH stringByAppendingPathComponent:folderName]];
}

-(void)startUploadTo:(NSString*)folder at:(DBMetadata*)folderMetadata{
    
    NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:nil];
    for(NSString* file in files){
        if([file hasSuffix:PNG_SUFFIX] || [file hasSuffix:JPEG_SUFFIX]){
            NSString* rev = [self getRevWithName:file.lastPathComponent InMetadata:folderMetadata];
            [self.restClient uploadFile:file.lastPathComponent toPath:folderMetadata.path withParentRev:rev fromPath:[NSTemporaryDirectory() stringByAppendingPathComponent:file]];
        }
    }
}

- (void)uploadPersistentStore{
    NSURL* url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    url= [url URLByAppendingPathComponent:@"Database/StoreContent/persistentStore"];
    
    [[self restClient] uploadFile:PERSISTENT_STORE toPath:DROPBOX_ROOT_PATH withParentRev:[self getRevWithName:PERSISTENT_STORE InMetadata:self.metadata] fromPath:[url path]];
}

#pragma mark - Dropbox uploadFileDelegate

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath
              from:(NSString*)srcPath metadata:(DBMetadata*)metadata {
    NSLog(@"%@",metadata.path);
    if(![srcPath hasSuffix:PERSISTENT_STORE]){
        [[NSFileManager defaultManager] removeItemAtPath:srcPath error:nil];
    }
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error {
    NSLog(@"File upload failed with error - %@", error);
}

/************ metadata ***************/

#pragma mark - Dropbox loadMetadata delegate

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (![metadata.path isEqualToString:DROPBOX_ROOT_PATH]) {
        [self startUploadTo:metadata.filename at:metadata];
        return;
    }
    self.metadata = metadata;
    [self.tableView reloadData];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}

/************ download file ***************/

#pragma mark - Dropbox downloadFile delegate

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)localPath {
    NSLog(@"File loaded into path: %@", localPath);
    
    if([localPath hasSuffix:PNG_SUFFIX] || [localPath hasSuffix:JPEG_SUFFIX]){
        DropboxImageViewController* preview = [[DropboxImageViewController alloc] initWithPath:localPath];
        [self.navigationController pushViewController:preview animated:YES];
    }else if([localPath.lastPathComponent isEqualToString:PERSISTENT_STORE]){
        //delegate
        [[Model sharedModel] importProjectFromTemporaryDirectoryPersistentStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error {
    NSLog(@"There was an error loading the file - %@", error);
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


@end