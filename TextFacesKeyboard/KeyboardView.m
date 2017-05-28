//
//  KeyboardView.m
//  TextFaces
//
//  Created by Neo Ighodaro on 11/10/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import "KeyboardView.h"
#import "KeyboardTexfFacesListViewController.h"

@interface KeyboardView ()
- (void)buildAllListView;
- (void)buildFavsListView;
- (void)standardizeListTableViewForController:(KeyboardTexfFacesListViewController *)ctrl;
- (void)buildKeyboardTitleSubview;
- (void)buildKeyboardSegmentControl;
- (void)buildGlobeButton;
- (void)buildBackspaceButton;
- (void)setConstraintsForKeyboardTitleComponents:(id)view options:(NSArray *)options;
- (id)applyBlurToView:(KeyboardView *)view withEffectStyle:(UIBlurEffectStyle)style andConstraints:(BOOL)addConstraints;
- (BOOL)useFavAsSegmentCtrlStartingPoint;
@end


@implementation KeyboardView

@synthesize globeButton = _globeButton;
@synthesize backspaceButton = _backspaceButton;
@synthesize keyboardAllList = _keyboardAllList;
@synthesize keyboardTitleView = _keyboardTitleView;
@synthesize keyboardSegmentedControl = _keyboardSegmentedControl;


- (id)init {
    return [[KeyboardView alloc] initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.4];
        self = [self applyBlurToView:self withEffectStyle:UIBlurEffectStyleDark andConstraints:YES];
        
        [self buildAllListView];
        [self buildFavsListView];
        [self buildKeyboardTitleSubview];
        [self buildKeyboardSegmentControl];
        [self buildGlobeButton];
        [self buildBackspaceButton];
    }
    
    return self;
}



#pragma mark - Build Subviews

- (void)buildAllListView {
    KeyboardTexfFacesListViewController* ctrl = [KeyboardTexfFacesListViewController initWithModel:[TextFaces findList:TEXTFACES_LIST_ALL]];
    ctrl.view.hidden = [self useFavAsSegmentCtrlStartingPoint] ? YES : NO;
    
    [self standardizeListTableViewForController:(self.keyboardAllList = ctrl)];
    [self addSubview:ctrl.view];
}

- (void)buildFavsListView {
    KeyboardTexfFacesListViewController* ctrl = [KeyboardTexfFacesListViewController initWithModel:[TextFaces findList:TEXTFACES_LIST_FAVS]];
    ctrl.view.hidden = [self useFavAsSegmentCtrlStartingPoint] ? NO : YES;
    
    [self addSubview:ctrl.view];
    [self standardizeListTableViewForController:(self.keyboardFavsList = ctrl)];
}

- (void)standardizeListTableViewForController:(KeyboardTexfFacesListViewController *)ctrl {
    ctrl.view.backgroundColor = [UIColor clearColor];
    
    // Override frame
    CGRect frame = CGRectZero;
    frame.origin.y = 40;
    ctrl.view.frame = frame;
    
    ctrl.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.3];
    ctrl.tableView.contentInset = UIEdgeInsetsMake(0, -7.5, 40, 0);
}

- (void)buildKeyboardTitleSubview {
    self.keyboardTitleView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.keyboardTitleView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f]];
    [self.keyboardTitleView setFrame:self.bounds];
    
    [self addSubview:self.keyboardTitleView];
    [self setConstraintsForKeyboardTitleComponents:self.keyboardTitleView options:@[@"fullWidth"]];
}

- (BOOL)useFavAsSegmentCtrlStartingPoint {
    return [[TextFaces findList:TEXTFACES_LIST_FAVS].listItems count] >= 3;
}

- (void)buildKeyboardSegmentControl {
    UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:@[
                                                                                       [NSLocalizedString(@"TextFaces", nil) uppercaseString],
                                                                                       [NSLocalizedString(@"Favorites", nil) uppercaseString]
                                                                                       ]];


    [segmentedControl setSelectedSegmentIndex:[self useFavAsSegmentCtrlStartingPoint] ? 1 : 0];
    [segmentedControl setTintColor:[UIColor clearColor]];
    
    NSDictionary* segmentedControlTextAttributes = @{
                                       NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18],
                                       NSForegroundColorAttributeName:[UIColor whiteColor]
                                    };

    [segmentedControl setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateHighlighted];
    [segmentedControl setTitleTextAttributes:segmentedControlTextAttributes forState:UIControlStateSelected];
    
    [segmentedControl setTitleTextAttributes:@{
                         NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18],
              NSForegroundColorAttributeName: [UIColor colorWithWhite:1 alpha:0.2]}
                                    forState:UIControlStateNormal];
    
    [self.keyboardTitleView addSubview:(self.keyboardSegmentedControl = segmentedControl)];
    [self setConstraintsForKeyboardTitleComponents:segmentedControl options:@[@"center", @"halfHeight"]];
}

- (void)buildGlobeButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [btn.titleLabel.font fontWithSize:10];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"GlobeIcon"] forState:UIControlStateNormal];
    
    [self.keyboardTitleView addSubview:(self.globeButton = btn)];
    [self setConstraintsForKeyboardTitleComponents:self.globeButton options:@[@"padLeft"]];
}

- (void)buildBackspaceButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [btn.titleLabel.font fontWithSize:10];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"BackspaceIcon"] forState:UIControlStateNormal];

    [self.keyboardTitleView addSubview:(self.backspaceButton = btn)];
    [self setConstraintsForKeyboardTitleComponents:self.backspaceButton options:@[@"padRight"]];
}


#pragma mark - Delegate methods

-(BOOL)enableInputClicksWhenVisible {
    return YES;
}

#pragma mark - Constraints

- (void)setConstraintsForKeyboardTitleComponents:(id)view options:(NSArray *)options {
    UIEdgeInsets padding = UIEdgeInsetsMake(10, 10, 10, -10);
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    float height = [options containsObject:@"halfHeight"] ? 20.0 : 40.0;
    
    [self.keyboardTitleView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:height]];

    if ([options containsObject:@"center"] || [options containsObject:@"centerX"]) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.keyboardTitleView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
    }

    if ([options containsObject:@"center"] || [options containsObject:@"centerY"]) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.keyboardTitleView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];
    }

    
    if ([options containsObject:@"fullWidth"]) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1.0
                                                          constant:0]];
    }
    
    
    if ([options containsObject:@"padLeft"]) {
        [self.keyboardTitleView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                           attribute:NSLayoutAttributeLeft
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.keyboardTitleView
                                                                           attribute:NSLayoutAttributeLeft
                                                                          multiplier:1.0
                                                                            constant:padding.left]];
    
    }

    if ([options containsObject:@"padRight"]) {
        [self.keyboardTitleView addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                                           attribute:NSLayoutAttributeRight
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.keyboardTitleView
                                                                           attribute:NSLayoutAttributeRight
                                                                          multiplier:1.0
                                                                            constant:padding.right]];

    }
}


#pragma mark - Blur Keyboard Background

- (id)applyBlurToView:(KeyboardView *)view withEffectStyle:(UIBlurEffectStyle)style andConstraints:(BOOL)addConstraints {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = view.bounds;

    [view addSubview:blurEffectView];
    
    if(addConstraints) {
        [blurEffectView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:0]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:0]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1
                                                          constant:0]];
        
        [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEffectView
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1
                                                          constant:0]];
    }
    
    return view;
}

@end
