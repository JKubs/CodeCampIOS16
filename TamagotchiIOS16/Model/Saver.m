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
    //NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSString *filePath = [documentsDirectory stringByAppendingString:SAVE_FILE_NAME];
    NSMutableDictionary *save;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        save = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
    else {
        save = [[NSMutableDictionary alloc] init];
    }
    
    if([key isEqualToString:GLOBAL_ACHIEVEMENTS]) {
        NSData *encodedValue = [NSKeyedArchiver archivedDataWithRootObject:value];
        [save setObject:encodedValue forKey:GLOBAL_ACHIEVEMENTS];
    }
    else {
        NSMutableDictionary *slot;
        if([save objectForKey:saveSlot] == nil) {
            slot = [[NSMutableDictionary alloc] init];
        }
        else {
            slot = [save objectForKey:saveSlot];
        }
        NSData *encodedValue = [NSKeyedArchiver archivedDataWithRootObject:value];
        [slot setValue:encodedValue forKey:key];
        [save setObject:slot forKey:saveSlot];
    }
    
    return [save writeToFile:filePath atomically:YES];
}

+(BOOL)completeSave:(GameViewController *)controller {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSString *filePath = [documentsDirectory stringByAppendingString:SAVE_FILE_NAME];
    NSMutableDictionary *save;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        save = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
    else {
        save = [[NSMutableDictionary alloc] init];
    }
    
    if(controller.saveSlot != nil) {
        NSMutableDictionary *slot;
        if([save objectForKey:controller.saveSlot] == nil) {
            slot = [[NSMutableDictionary alloc] init];
        }
        else {
            slot = [save objectForKey:controller.saveSlot];
        }
        
        [slot setObject:[NSKeyedArchiver archivedDataWithRootObject:controller.owner] forKey:OWNER];
        [slot setObject:[NSKeyedArchiver archivedDataWithRootObject:controller.pet] forKey:PET];
        NSData *encodedStorage = [NSKeyedArchiver archivedDataWithRootObject:controller.storage];
        [slot setObject:encodedStorage forKey:STORAGE];
        [slot setObject:[NSKeyedArchiver archivedDataWithRootObject:controller.localAchievements] forKey:LOCAL_ACHIEVEMENTS];
        
        [save setObject:[NSKeyedArchiver archivedDataWithRootObject:controller.globalAchievements] forKey:GLOBAL_ACHIEVEMENTS];
        [save setObject:slot forKey:controller.saveSlot];
        [save setObject:controller.saveSlot forKey:CURRENT_SLOT];
    }
    
    //NSLog(@"%@",[[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    if([save writeToFile:filePath atomically:YES]) {
        NSLog(@"Saved game");
        return YES;
    }
    else {
        NSLog(@"Error : saving game failed");
        return NO;
    }
}

+(BOOL)saveNotificationSchedules:(NSMutableArray*)notifications toSlot:(NSString*)saveSlot{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
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
    NSData *encodedNotifications = [NSKeyedArchiver archivedDataWithRootObject:notifications];

    [slot setObject:encodedNotifications forKey:NOTIFICATION_REQUESTS];
    
    [save setObject:slot forKey:saveSlot];
    
    
    BOOL succeed = [save writeToFile:filePath atomically:YES];
    if (!succeed){
        //error handling
        NSLog(@"Error: notification schedules of %@ could not be saved", saveSlot);
        return NO;
    }
    return YES;
    /*
     NSData *encodedNotifications = [NSKeyedArchiver archivedDataWithRootObject:notifications];
    NSMutableDictionary *slot = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] dictionaryForKey:saveSlot]];
    [slot setValue:encodedNotifications forKey:NOTIFICATION_REQUESTS];
    
    [[NSUserDefaults standardUserDefaults] setValue:slot forKey:saveSlot];
    return [[NSUserDefaults standardUserDefaults] synchronize];*/
}

+(BOOL)deleteSlot:(NSString *)saveSlot {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSString *filePath = [documentsDirectory stringByAppendingString:SAVE_FILE_NAME];
    NSMutableDictionary *save = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    [save removeObjectForKey:saveSlot];
    [save removeObjectForKey:CURRENT_SLOT];
    BOOL succeed = [save writeToFile:filePath atomically:YES];
    if (!succeed){
        //error handling
        NSLog(@"Error: %@ could not be deleted", saveSlot);
        return NO;
    }
    return YES;
    
}

@end
