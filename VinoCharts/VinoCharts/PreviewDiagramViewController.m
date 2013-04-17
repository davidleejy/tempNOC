//
//  PreviewDiagramViewController.m
//  VinoCharts
//
//  Created by Ang Civics on 14/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PreviewDiagramViewController.h"

@interface PreviewDiagramViewController ()

@end

@implementation PreviewDiagramViewController

-(id)initWithImage:(UIImage *)image Title:(NSString *)title ProjectTitle:(NSString *)projectTitle{
    self = [super init];
    if(self){
        self.imageView = [[UIImageView alloc] initWithImage:image];
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        self.title = title;
        self.projectTitle = projectTitle;
    }
    
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *syncButton = [[UIBarButtonItem alloc] initWithTitle:@"Upload To Dropbox" style:UIBarButtonItemStyleBordered target:self action:@selector(uploadToDropbox)];
    [self.navigationItem setRightBarButtonItem:syncButton];
}

-(void)uploadToDropbox{
    [self saveScreenShot];
    [[DropboxViewController sharedDropbox] uploadImageAtTemporaryDirectoryToFolder:self.projectTitle];
}

- (void)saveScreenShot{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(self.scrollView.contentSize);
    {
        CGPoint savedContentOffset = self.scrollView.contentOffset;
        CGRect savedFrame = self.scrollView.frame;
        
        self.scrollView.contentOffset = CGPointZero;
        self.scrollView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
        
        [self.scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.scrollView.contentOffset = savedContentOffset;
        self.scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        NSString* path = [NSTemporaryDirectory() stringByAppendingPathComponent:self.title];
        [UIImagePNGRepresentation(image) writeToFile: [path stringByAppendingPathExtension:PNG_SUFFIX] atomically: YES];
        [UIImageJPEGRepresentation(image, 1) writeToFile:[path stringByAppendingPathExtension:JPEG_SUFFIX] atomically:YES];
     }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
