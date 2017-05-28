//
//  ManageTextFacesCell.m
//  TextFaces
//
//  Created by Neo Ighodaro on 11/16/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import "ManageTextFacesCell.h"
#import "TextFaces.h"

@implementation ManageTextFacesCell

@synthesize favBtn = _favBtn;
@synthesize textLabel = _textLabel;

- (void)markAsFavorited:(BOOL)favorited {
    NSString* icon = favorited ? @"fav-icon" : @"unfav-icon";
    
    [self.favBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.favBtn setTintColor:favorited ? TEXTFACES_TINT_COLOR : [UIColor lightGrayColor]];
}

- (void)hideFaveButton {
    self.favBtn = nil;
}

@end
