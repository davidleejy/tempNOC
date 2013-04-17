//
//  Model.m
//  VinoCharts
//
//  Created by Ang Civics on 10/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "Model.h"

@interface Model()

@property (readwrite) NSMutableArray* allProjects;

@end

@implementation Model

static Model *sharedModel = nil;

+(Model*)sharedModel{
    if(sharedModel == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedModel = [[Model alloc] init];
        });
    }
    return sharedModel;
}

-(Project *)createProjectModel{
    ProjectModel* coreDataProject = [NSEntityDescription insertNewObjectForEntityForName:kProject inManagedObjectContext:self.database.managedObjectContext];
    Project* project = [[Project alloc] initWithCoreData:coreDataProject];
    [self.allProjects addObject:project];
    
    return project;
}

//for core data
-(id)init{
    self = [super init];
    if(self){
        self.allProjects = [[NSMutableArray alloc]init];
        [self initContext];
    }
    return self;
}

-(void)initContext{
 //   [self.indicator startAnimating];
    
    NSURL* url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
    url= [url URLByAppendingPathComponent:kDatabase];
    
    self.database = [[UIManagedDocument alloc]initWithFileURL:url];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        [self.database openWithCompletionHandler:^(BOOL success) {
            
            NSArray* fetchProject = [self loadProject];
            for (ProjectModel* p in fetchProject) {
                Project* pro = [[Project alloc] initWithCoreData:p];
                [self.allProjects addObject:pro];
                NSLog(@"%@",pro.title);
            }
            [self.delegate projectLoaded];
                 NSLog(@"document exist and opened at %@",[url path]);
        }];
    }else{
        [self.database saveToURL:self.database.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
              NSLog(@"document created at %@",[url path]);
        }];
    }
}

-(NSArray*)loadProject{
    //EFFECTS: return all project object
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:kProject inManagedObjectContext:self.database.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSArray* fetchedObjects = [self.database.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    return fetchedObjects;
}

-(void)removeProjectAtIndex:(int)index{
    Project* pro = [self.allProjects objectAtIndex:index];
    [pro removeFromCoreData];
    [self.allProjects removeObjectAtIndex:index];
}

-(void)importProjectFromTemporaryDirectoryPersistentStore{
    NSURL* url = [NSURL fileURLWithPath:NSTemporaryDirectory()];
    
    UIManagedDocument* doc = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        [doc openWithCompletionHandler:^(BOOL success) {
            NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
            
            NSEntityDescription* entity = [NSEntityDescription entityForName:kProject inManagedObjectContext:doc.managedObjectContext];
            
            [fetchRequest setEntity:entity];
            
            NSArray* fetchedObjects = [doc.managedObjectContext executeFetchRequest:fetchRequest error:nil];
            for(ProjectModel* pro in fetchedObjects){
                ProjectModel* model = [NSEntityDescription insertNewObjectForEntityForName:kProject inManagedObjectContext:self.database.managedObjectContext];
                Project* project = [[Project alloc]initWithCoreData:[model copyProjectData:pro]];
                [self.allProjects addObject:project];
            }
            [[NSFileManager defaultManager] removeItemAtURL:[url URLByAppendingPathComponent:STORE_CONTENT isDirectory:YES] error:nil];
            [self.delegate projectLoaded];
        }];
    }
}
@end
