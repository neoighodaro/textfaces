//
//  AppDelegate.h
//  TextFaces
//
//  Created by Neo Ighodaro on 11/10/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootNavigationController.h"

#ifndef TF_PARSE_APPLICATION_SETTINGS
#define TF_PARSE_APPLICATION_ID @"ZvIUfxPy4CuRBQ2KhaPo6pZ6Y2ei4VByOz117xwb"
#define TF_PARSE_CLIENT_KEY @"cv2k3EQtZXhbohGMx0BglYI1aeYaWHwDfAV7hNxT"
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) RootNavigationController* navigationController;

@end

