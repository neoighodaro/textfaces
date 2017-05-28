//
//  RootMenuTableViewCell.h
//  TextFaces
//
//  Created by Neo Ighodaro on 11/13/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootMenuTableViewCell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel* menuSubtitle;
@property(nonatomic,weak) IBOutlet UILabel* menuTitle;
@property(nonatomic,strong) IBOutlet UIImageView* menuIcon;

@end
