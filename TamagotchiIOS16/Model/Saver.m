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
    [[NSUserDefaults standardUserDefaults] setObject:controller.saveSlot forKey:CURRENT_SLOT];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)saveNotificationSchedules:(NSArray*)notifications toSlot:(NSString*)saveSlot{
    NSMutableArray *encodedNotifications = [[NSMutableArray alloc] init];
    
    for (NotificationRequest *notireq in notifications) {
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:notireq];
        [encodedNotifications addObject:encodedObject];
    }
    
    NSDictionary *slot = [[NSUserDefaults standardUserDefaults] dictionaryForKey:saveSlot];
    
    [slot setValue:encodedNotifications forKey:NOTIFICATION_REQUESTS];
    
    [[NSUserDefaults standardUserDefaults] setValue:slot forKey:saveSlot];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
