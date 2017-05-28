//
//  KeyboardView.h
//  TextFaces
//
//  Created by Neo Ighodaro on 11/10/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardTexfFacesListViewController.h"

@interface KeyboardView : UIInputView<UIInputViewAudioFeedback>
@property(nonatomic,strong) UIView* keyboardTitleView;
@property(nonatomic,strong) UIButton* globeButton;
@property(nonatomic,strong) UIButton* backspaceButton;
@property(nonatomic,strong) UISegmentedControl* keyboardSegmentedControl;
@property(nonatomic,strong) KeyboardTexfFacesListViewController* keyboardAllList;
@property(nonatomic,strong) KeyboardTexfFacesListViewController* keyboardFavsList;
- (id)init;
@end
