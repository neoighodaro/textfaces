//
//  ViewController.h
//  TextFaces
//
//  Created by Neo Ighodaro on 11/10/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Common.h"

@interface RootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property(nonatomic,weak) IBOutlet UIView* headerView;
@property(nonatomic,weak) IBOutlet UIImageView* headerLogo;
@property(nonatomic,strong) IBOutlet UITableView* tableView;

@end

