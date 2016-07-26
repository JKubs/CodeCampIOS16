//
//  Saver.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "Saver.h"

@implementation Saver

+(BOOL)saveChangeOn:(id)instance withValue:(id)value {
    NSURL *URL = nil;
    NSError *error;
    NSMutableString *oldSave = [[NSMutableString alloc]
                                     initWithContentsOfURL:URL
                                     encoding:NSUTF8StringEncoding
                                     error:&error];
    if (oldSave == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              URL, [error localizedFailureReason]);
        return NO;
    }
    
    return YES;
}

@end
