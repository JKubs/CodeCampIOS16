//
//  Saver.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "Saver.h"


@implementation Saver

+(BOOL)saveChangeOn:(NSString*)key withValue:(id)value atSaveSlot:(NSString*)saveSlot {
    NSDictionary *slot = [[NSUserDefaults standardUserDefaults] dictionaryForKey:saveSlot];
    [slot setValue:value forKey:key];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)completeSave:(GameViewController *)controller {
    return NO;
}

+(BOOL)saveNotificationSchedulesOnExiting:(NSArray*)notifications {
    [[NSUserDefaults standardUserDefaults] setValue:notifications forKey:NOTIFICATION_REQUESTS];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
