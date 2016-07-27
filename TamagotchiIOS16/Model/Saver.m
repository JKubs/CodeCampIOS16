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
    NSData *encodedValue = [NSKeyedArchiver archivedDataWithRootObject:value];
    [slot setValue:encodedValue forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:slot forKey:saveSlot];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)completeSave:(GameViewController *)controller {
    NSMutableDictionary *slot = [[NSMutableDictionary alloc] init];
    [slot setObject:[NSKeyedArchiver archivedDataWithRootObject:controller.owner] forKey:OWNER];
    [slot setObject:[NSKeyedArchiver archivedDataWithRootObject:controller.pet] forKey:PET];
    [[NSUserDefaults standardUserDefaults] setObject:slot forKey:controller.saveSlot];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)saveNotificationSchedules:(NSArray*)notifications {
    NSMutableArray *encodedNotifications = [[NSMutableArray alloc] init];
    
    for (NotificationRequest *notireq in notifications) {
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:notireq];
        [encodedNotifications addObject:encodedObject];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:encodedNotifications forKey:NOTIFICATION_REQUESTS];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
