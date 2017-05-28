//
//  ManageTextFacesCell.h
//  TextFaces
//
//  Created by Neo Ighodaro on 11/16/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageTextFacesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *favBtn;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
- (void)markAsFavorited:(BOOL)favorited;
- (void)hideFaveButton;
@end
