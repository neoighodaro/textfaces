//
//  KeyboardViewController.m
//  Keyboard
//
//  Created by Neo Ighodaro on 11/10/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import "KeyboardViewController.h"
#import "TextFaces.h"

NSUInteger tempCharCounter;

@interface KeyboardViewController ()
@property(nonatomic,strong) NSTimer* timer;
- (void)textfaceButtonTappedSoInsertFaceToInput:(NSNotification *)notification;
- (void)textfaceButtonPressedSoInsertFaceAndSwitchKeyboard:(NSNotification *)notification;
- (void)textfacesDataDidChange:(NSNotification *)notification;
- (IBAction)keyboardSegmentedControlClicked:(id)control;
- (void)registerKeyboardButtonPressedEvents;
- (void)switchKeyboardButtonPressed;
- (void)backspaceButtonPressed;
- (void)registerNotificationObserver:(SEL)selector name:(NSString *)name;
- (void)unregisterNotificationObserver:(NSString *)name;
- (void)registerNotificationObservers;
- (void)unregisterNotificationObservers;
@end


@implementation KeyboardViewController

@synthesize keyboardView = _keyboardView;
@synthesize timer = _timer;

- (void)updateViewConstraints {
    [super updateViewConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.keyboardView.keyboardAllList viewWillAppear:YES];
    [self.keyboardView.keyboardFavsList viewWillAppear:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.keyboardView.keyboardAllList viewWillDisappear:YES];
    [self.keyboardView.keyboardFavsList viewWillDisappear:YES];

    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];

     [self setKeyboardView:[[KeyboardView alloc] init]];
     [self registerKeyboardButtonPressedEvents];
    
     self.inputView = self.keyboardView;
    
     [self registerNotificationObservers];
}


#pragma mark - Keyboard Interactions

- (void)textfaceButtonTappedSoInsertFaceToInput:(NSNotification *)notification {
    [[UIDevice currentDevice] playInputClick];
    NSDictionary* payload = notification.userInfo;
    [self.textDocumentProxy insertText:[NSString stringWithFormat:@"%@ ", payload[@"text"]]];
}

- (void)textfaceButtonPressedSoInsertFaceAndSwitchKeyboard:(NSNotification *)notification {
    [self textfaceButtonTappedSoInsertFaceToInput:notification];
    [self switchKeyboardButtonPressed];
}

- (void)registerKeyboardButtonPressedEvents {
    [self.keyboardView.globeButton addTarget:self
                                      action:@selector(switchKeyboardButtonPressed)
                            forControlEvents:UIControlEventTouchUpInside];
    
    [self.keyboardView.backspaceButton addTarget:self
                                          action:@selector(backspaceButtonPressed)
                                forControlEvents:UIControlEventTouchUpInside];

    [self.keyboardView.keyboardSegmentedControl addTarget:self
                                                   action:@selector(keyboardSegmentedControlClicked:)
                                         forControlEvents:UIControlEventValueChanged];

    UILongPressGestureRecognizer *delLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(longPressBackspaceButton:)];
    delLongPress.numberOfTouchesRequired = 1.0f;
    delLongPress.minimumPressDuration = 0.5f;
    [self.keyboardView.backspaceButton addGestureRecognizer:delLongPress];
}

- (IBAction)keyboardSegmentedControlClicked:(UISegmentedControl *)control {
    if (control.selectedSegmentIndex == 0) {
        [self.keyboardView.keyboardAllList.view setHidden:NO];
        [self.keyboardView.keyboardFavsList.view setHidden:YES];
    } else if (control.selectedSegmentIndex == 1) {
        [self.keyboardView.keyboardAllList.view setHidden:YES];
        [self.keyboardView.keyboardFavsList.view setHidden:NO];
    }
    [[UIDevice currentDevice] playInputClick];
}

- (void)switchKeyboardButtonPressed {
    [self advanceToNextInputMode];
    [[UIDevice currentDevice] playInputClick];
}

- (void)backspaceButtonPressed {
    tempCharCounter ++;
    if (tempCharCounter >= 8) {
        NSArray *tokens = [self.textDocumentProxy.documentContextBeforeInput componentsSeparatedByString:@" "];
        for (int i = 0; i <= [[tokens lastObject] length];i++) {
            [self.textDocumentProxy deleteBackward];
            [[UIDevice currentDevice] playInputClick];
        }
    }else{
        [self.textDocumentProxy deleteBackward];
        [[UIDevice currentDevice] playInputClick];
    }
}

-(IBAction)longPressBackspaceButton:(UIGestureRecognizer*)gesture{
    tempCharCounter = 0;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2f
                                                          target:self
                                                        selector:@selector(backspaceButtonPressed)
                                                        userInfo:nil
                                                         repeats:YES];
            break;
        case UIGestureRecognizerStateEnded:
            [self.timer invalidate];
            self.timer = nil;
            return;
        default:
            break;
    }
}

- (void)dealloc {
    //[self unregisterNotificationObservers];
}


#pragma mark - Other Events

- (void)textfacesDataDidChange:(NSNotification *)notification {
    [self.keyboardView.keyboardAllList reloadTableData:notification];
    [self.keyboardView.keyboardFavsList reloadTableData:notification];
}


#pragma mark - Notification Observers

- (void)registerNotificationObserver:(SEL)selector name:(NSString *)name {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:name object:nil];
}

- (void)unregisterNotificationObserver:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
}

- (void)registerNotificationObservers {
    [self registerNotificationObserver:@selector(textfaceButtonTappedSoInsertFaceToInput:)
                                  name:TEXTFACE_TAP_NOTIFICATION];
    [self registerNotificationObserver:@selector(textfaceButtonPressedSoInsertFaceAndSwitchKeyboard:)
                                  name:TEXTFACE_PRESS_NOTIFICATION];
}

- (void)unregisterNotificationObservers {
    [self unregisterNotificationObserver:TEXTFACE_TAP_NOTIFICATION];
    [self unregisterNotificationObserver:TEXTFACE_PRESS_NOTIFICATION];
}

@end