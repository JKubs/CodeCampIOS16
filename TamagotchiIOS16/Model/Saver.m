//
//  Saver.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "Saver.h"

@implementation Saver

+(BOOL)saveChangeOn:(NSString*)key withValue:(id)value {
    //bundle
    //NSString *dataFile = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"txt"];

    //sandbox
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"SaveFile.tsv"];
   // NSString *dataFile = [NSString stringWithContentsOfFile:docPath encoding: NSUTF8StringEncoding error:nil];
    
    NSError *error;
    NSMutableString *oldSave = [[NSMutableString alloc]
                                     initWithContentsOfFile:docPath
                                     encoding:NSUTF8StringEncoding
                                     error:&error];
    if (oldSave == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              docPath, [error localizedFailureReason]);
        return NO;
    }
    NSArray *lines = [oldSave componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSMutableString *line in lines) {
        NSString *tmp = [[line componentsSeparatedByString:@":"] objectAtIndex:0];
        if([tmp containsString:key]) {
            NSString *newValue = [value string];
            NSString *newLine = [tmp stringByAppendingString:newValue];
            NSUInteger occ = [oldSave replaceOccurrencesOfString:line withString:newLine options:NSCaseInsensitiveSearch range:NSMakeRange(0, [oldSave length])];
            return occ > 0;
        }
    }
    //write file
    return [oldSave writeToFile:docPath
               atomically:YES
                 encoding:NSUTF8StringEncoding
                    error:&error];
    
}

+(BOOL)completeSave:(GameViewController *)controller {
    return NO;
}

+(BOOL)saveNotificationSchedulesOnExiting:(NSArray*)notifications {
    
    //bundle
    //NSString *dataFile = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"txt"];
    
    //sandbox
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"SaveFile.tsv"];
    // NSString *dataFile = [NSString stringWithContentsOfFile:docPath encoding: NSUTF8StringEncoding error:nil];
    
    NSError *error;
    NSMutableString *oldSave = [[NSMutableString alloc]
                                initWithContentsOfFile:docPath
                                encoding:NSUTF8StringEncoding
                                error:&error];
    if (oldSave == nil) {
        // an error occurred
        NSLog(@"Error reading file at %@\n%@",
              docPath, [error localizedFailureReason]);
        return NO;
    }
    NSString *newSave = oldSave;
    for (NotificationRequest *noti in notifications) {
        newSave = [[[[[[[newSave stringByAppendingString:@"noti:"] stringByAppendingString:noti.subject]
                   stringByAppendingString:@"§"] stringByAppendingString:noti.message] stringByAppendingString:@"§"]
                   stringByAppendingString:[noti.timestamp description]] stringByAppendingString:@"\n"];
    }
    newSave = [newSave stringByAppendingString:@"\n"];
    
    
    return [newSave writeToFile:docPath
                     atomically:YES
                       encoding:NSUTF8StringEncoding
                          error:nil];
}

@end
