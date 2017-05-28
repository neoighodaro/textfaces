//
//  Common.h
//  TextFaces
//
//  Created by Neo Ighodaro on 11/17/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#ifndef TextFaces_Common_h
#define TextFaces_Common_h

#import <Appirater/Appirater.h>
#import "TextFaces.h"

typedef enum {
    TextFacesShortCutAddNew,
    TextFacesShortCutManage,
    TextFacesShortCutManageFavorites,
    TextFacesShortCutSuggested
} TextFacesShortCutItem;

#define kTextFacesShortCutItems @[ \
    @"com.tapsharp.TextFaces.add-textface", \
    @"com.tapsharp.TextFaces.manage-all", \
    @"com.tapsharp.TextFaces.manage-favorites", \
    @"com.tapsharp.TextFaces.suggested-textfaces" \
]

#endif

#ifdef DEBUG
#define DLog(...) NSLog((@”%s %s:%d ” s), __func__, basename(__FILE__), __LINE__, ## __VA_ARGS__)
#else
#define DLog(...) /* Nothing */
#endif
#define ALog(...) NSLog((@”%s %s:%d ” s), __func__, basename(__FILE__), __LINE__, ## __VA_ARGS__)