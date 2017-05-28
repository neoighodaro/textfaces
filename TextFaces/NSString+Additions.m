//
//  NSString+Additions.m
//  TextFaces
//
//  Created by Neo Ighodaro on 11/19/15.
//  Copyright (c) 2015 TapSharp Interactive. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

+ (BOOL)isEmpty:(NSString *)string {
    if([string length] == 0) {
        return YES;
    }
    
    if(![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]) {
        return YES;
    }
    
    return NO;
}

@end
