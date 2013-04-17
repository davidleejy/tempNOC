//
//  DropboxViewController.h
//  VinoCharts
//
//  Created by Ang Civics on 30/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//
/****************************/
// This is a singleton class

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import <CoreData/CoreData.h>
#import "DropboxImageViewController.h"
#import "CoreDataConstant.h"
#import "Project.h"
#import "Model.h"

@protocol DropboxDelegate <NSObject>

-(void)accountInfoLoaded:(NSString*)userName;

@end
@interface DropboxViewController : UITableViewController<DBRestClientDelegate, UIAlertViewDelegate, UIScrollViewDelegate>

@property(nonatomic) DBRestClient *restClient;
@property DBMetadata* metadata;
@property NSString* path;
@property NSManagedObjectContext* context;
@property Project* project;
@property id<DropboxDelegate> delegate;

+(id)sharedDropbox;

- (id)initWithPath:(NSString*)path;
- (void)uploadImageAtTemporaryDirectoryToFolder:(NSString*)folderName;
- (void) loadDropboxAccountInfo;
- (void)uploadPersistentStore;

@end
