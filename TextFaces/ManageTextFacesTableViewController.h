//
//  ManageTextFacesTableViewController.h
//  TextFaces
//
//  Created by Neo Ighodaro on 11/15/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManageTextFacesCell.h"
#import "Common.h"
#import "NSString+Additions.h"

@interface ManageTextFacesTableViewController : UITableViewController
@property(nonatomic,strong) NSMutableArray* textfaces;
@end


@interface ManageTextFacesTableViewController ()
- (IBAction)toggleFavoriteButtonClicked:(id)sender;
- (IBAction)addNewTextFace:(id)sender;
@end
