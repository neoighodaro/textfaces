//
//  AppDelegate.m
//  TextFaces
//
//  Created by Neo Ighodaro on 11/10/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import "Common.h"
#import "TextFaces.h"
#import "AppDelegate.h"
#import "RootViewController.h"
#import "ManageTextFacesTableViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()
- (void)launchAddTextFace:(ManageTextFacesTableViewController *)ctrl;
- (BOOL)handleShortcutItem:(UIApplicationShortcutItem *)shortcutItem;
- (void)configurePushNotifications:(UIApplication *)application withOptions:(NSDictionary *)launchOptions;
- (void)clearPushBadgeNotifications;
- (void)configureAppirater;
- (void)configureParse:(NSDictionary *)launchOptions;
- (void)handleNotificationToControllerProcess:(NSDictionary *)notificationPayload withHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self configureAppirater];
    [self configureParse:launchOptions];
    [self configurePushNotifications:application withOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self clearPushBadgeNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - App iRater

- (void)configureAppirater {
    [Appirater setAppId:TEXTFACES_ITUNES_APP_ID];
    [Appirater setDaysUntilPrompt:3];
    [Appirater setUsesUntilPrompt:7];
    [Appirater setSignificantEventsUntilPrompt:5];
    [Appirater setTimeBeforeReminding:2];
    [Appirater appLaunched:YES];
}

#pragma mark - Parse

- (void)configureParse:(NSDictionary *)launchOptions {
    [Parse setApplicationId:TF_PARSE_APPLICATION_ID clientKey:TF_PARSE_CLIENT_KEY];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

#pragma mark - Push Notifications

- (void)handleNotificationToControllerProcess:(NSDictionary *)notificationPayload withHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSString* menu = [notificationPayload objectForKey:@"goto"];
    
    if ([menu isEqualToString:@"suggested"]) {
        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * ctrl = [storyboard instantiateViewControllerWithIdentifier:@"CommunityTextFacesViewController"];
        [(UINavigationController * )self.window.rootViewController pushViewController:ctrl animated:YES];
        
        if (completionHandler) {
            completionHandler(UIBackgroundFetchResultNewData);
        }
    }
}

- (void)clearPushBadgeNotifications {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];

    if (currentInstallation.badge != 0) {
        currentInstallation.badge = 0;
        [currentInstallation saveEventually];
    }
}

- (void)configurePushNotifications:(UIApplication *)application withOptions:(NSDictionary *)launchOptions {
    UIUserNotificationType userNotificationTypes = (
        UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound
    );
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    [self handleNotificationToControllerProcess:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] withHandler:nil];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    
    [self handleNotificationToControllerProcess:userInfo withHandler:completionHandler];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
    
    [PFPush handlePush:userInfo];
}

#pragma mark - Shortcut Item Support

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    if (completionHandler != nil) {
        completionHandler([self handleShortcutItem:shortcutItem]);
    }
}

- (BOOL)handleShortcutItem:(UIApplicationShortcutItem *)shortcutItem {
    BOOL handledSuccessfully = NO;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    NSInteger shortcutType = [kTextFacesShortCutItems indexOfObject:shortcutItem.type];
    
    if (shortcutType == TextFacesShortCutManageFavorites) {
        handledSuccessfully = YES;
        id ctrl = [storyboard instantiateViewControllerWithIdentifier:@"ManageFavoritesTableViewController"];
        [(UINavigationController*)self.window.rootViewController pushViewController:ctrl animated:YES];
    }

    if (shortcutType == TextFacesShortCutSuggested) {
        handledSuccessfully = YES;
        id ctrl = [storyboard instantiateViewControllerWithIdentifier:@"CommunityTextFacesViewController"];
        [(UINavigationController*)self.window.rootViewController pushViewController:ctrl animated:YES];
    }

    
    if (shortcutType == TextFacesShortCutManage || shortcutType == TextFacesShortCutAddNew) {
        handledSuccessfully = YES;
        id ctrl = [storyboard instantiateViewControllerWithIdentifier:@"ManageTextFacesTableViewController"];
        [(UINavigationController*)self.window.rootViewController pushViewController:ctrl animated:YES];

        if (shortcutType == TextFacesShortCutAddNew) {
            [self performSelector:@selector(launchAddTextFace:) withObject:ctrl afterDelay:1];
        }
    }
    
    return handledSuccessfully;
}

- (void)launchAddTextFace:(ManageTextFacesTableViewController *)ctrl {
    [ctrl addNewTextFace:nil];
}

@end
