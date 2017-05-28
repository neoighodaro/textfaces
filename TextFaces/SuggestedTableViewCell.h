//
//  SuggestedTableViewCell.h
//  TextFaces
//
//  Created by Neo Ighodaro on 11/28/15.
//  Copyright © 2015 TapSharp Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestedTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *addSuggestionBtn;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;

- (void)hideAddButton;
- (void)markAsAdded:(BOOL)added;

@end
