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
    NSMutableDictionary *slot = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:saveSlot]];
    NSData *encodedValue = [NSKeyedArchiver archivedDataWithRootObject:value];
    [slot setValue:encodedValue forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:slot forKey:saveSlot];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)completeSave:(GameViewController *)controller {
    NSMutableDictionary *slot = [[NSMutableDictionary alloc] init];
    
    [slot setObject:[NSKeyedArchiver archivedDataWithRootObject:controller.owner] forKey:OWNER];
    [slot setObject:[NSKeyedArchiver archivedDataWithRootObject:controller.pet] forKey:PET];
    NSData *encodedStorage = [NSKeyedArchiver archivedDataWithRootObject:controller.storage];
    
    [slot setObject:encodedStorage forKey:STORAGE];
    [[NSUserDefaults standardUserDefaults] setObject:slot forKey:controller.saveSlot];
    [[NSUserDefaults standardUserDefaults] setObject:controller.saveSlot forKey:CURRENT_SLOT];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)saveNotificationSchedules:(NSMutableArray*)notifications toSlot:(NSString*)saveSlot{
 /*   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSString *filePath = [documentsDirectory stringByAppendingString:SAVE_FILE_NAME];
    NSMutableDictionary *save;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        save = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
    else {
        save = [[NSMutableDictionary alloc] init];
    }
    NSMutableDictionary *slot;
    if([save objectForKey:saveSlot] == nil) {
        slot = [[NSMutableDictionary alloc] init];
    }
    else {
        slot = [save objectForKey:saveSlot];
    }
    [slot setObject:notifications forKey:NOTIFICATION_REQUESTS];
    
    [save setObject:slot forKey:saveSlot];
    
    
    BOOL succeed = [save writeToFile:filePath atomically:YES];
    if (!succeed){
        return NO;
    }
    return YES;*/

    NSData *encodedNotifications = [NSKeyedArchiver archivedDataWithRootObject:notifications];
    
    NSMutableDictionary *slot = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:saveSlot]];
    [slot setValue:encodedNotifications forKey:NOTIFICATION_REQUESTS];
    
    [[NSUserDefaults standardUserDefaults] setValue:slot forKey:saveSlot];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
