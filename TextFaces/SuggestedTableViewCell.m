//
//  SuggestedTableViewCell.m
//  TextFaces
//
//  Created by Neo Ighodaro on 11/28/15.
//  Copyright © 2015 TapSharp Interactive. All rights reserved.
//

#import "TextFaces.h"
#import "SuggestedTableViewCell.h"

@implementation SuggestedTableViewCell

@synthesize textLabel = _textLabel;
@synthesize addSuggestionBtn = _addSuggestionBtn;

- (void)markAsAdded:(BOOL)added {
    self.userInteractionEnabled = (added == NO);
    self.textLabel.enabled = (added == NO);
    [self.addSuggestionBtn setTintColor:added ? [UIColor clearColor] : TEXTFACES_TINT_COLOR];
}

- (void)hideAddButton {
    self.addSuggestionBtn = nil;
}

@end
