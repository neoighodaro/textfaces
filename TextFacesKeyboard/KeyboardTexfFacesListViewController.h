//
//  KeyboardTexfFacesListViewController.h
//  TextFaces
//
//  Created by Neo Ighodaro on 11/11/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFaces.h"

@interface KeyboardTexfFacesListViewController : UITableViewController
@property(nonatomic,strong) TextFaces* model;
+ (id)initWithModel:(TextFaces *)model;
- (void)reloadTableData:(NSNotification *)notification;
@end
