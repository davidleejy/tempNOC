//
//  ProjectDiagramsViewController.h
//  VinoCharts
//
//  Created by Hendy Chua on 1/4/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "SingleProjectViewController.h"
#import "DiagramOverviewViewController.h"
#import "EditDiagramController.h"

@interface ProjectDiagramsViewController : SingleProjectViewController <TileControllerDelegate,EditDiagramControllerDelegate> {
    Diagram *diagramSelected;
}

@end
