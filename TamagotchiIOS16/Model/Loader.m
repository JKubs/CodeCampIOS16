//
//  Loader.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "Loader.h"

@implementation Loader

+(BOOL)loadSaveStateTo:(GameViewController *)controller {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSString *filePath = [documentsDirectory stringByAppendingString:SAVE_FILE_NAME];
    NSMutableDictionary *save;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        save = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
    else {
        //create empty save file
        save = [[NSMutableDictionary alloc] init];
        [save writeToFile:filePath atomically:YES];
    }
    if([save objectForKey:controller.saveSlot] != nil) {
        
        NSDictionary *slot = [save objectForKey:controller.saveSlot];
        //NSLog(@"slot loaded: %@", slot);
        NSData *encodedOwner = [slot objectForKey:OWNER];
        Owner *owner =  [NSKeyedUnarchiver unarchiveObjectWithData:encodedOwner];
        NSData *encodedPet = [slot objectForKey:PET];
        Pet *pet =  [NSKeyedUnarchiver unarchiveObjectWithData:encodedPet];
        NSData *encodedNotifications = [slot objectForKey:NOTIFICATION_REQUESTS];
        NSMutableArray *notifications = (NSMutableArray*) [NSKeyedUnarchiver unarchiveObjectWithData:encodedNotifications];
        NSData *encodedStorage = [slot objectForKey:STORAGE];
        NSMutableDictionary *storage = (NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:encodedStorage];

        //NSLog(@"%@",notifications);
        if(owner != nil) {
            controller.owner = owner;
        }
        if(pet != nil) {
            controller.pet = pet;
        }
        if(notifications != nil) {
            controller.notificationRequests = notifications;
        }
        if(storage != nil) {
            controller.storage = storage;
        }
    
        return YES;
    }
    return NO;
}

+(NSString *)loadLastUsedSlotString {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSString *filePath = [documentsDirectory stringByAppendingString:SAVE_FILE_NAME];
    NSMutableDictionary *save =[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    return [save objectForKey:CURRENT_SLOT];
}

+(NSDictionary *)loadSlot:(NSString*)slot{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents directory
    NSString *filePath = [documentsDirectory stringByAppendingString:SAVE_FILE_NAME];
    NSMutableDictionary *save;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        save = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }
    else {
        //create empty save file
        save = [[NSMutableDictionary alloc] init];
        [save writeToFile:filePath atomically:YES];
    }
    if([save objectForKey:slot] != nil) {
        NSDictionary *encodedSlot = [save objectForKey:slot];
        //NSLog(@"slot loaded: %@", slot);
    
        NSData *encodedOwner = [encodedSlot objectForKey:OWNER];
        Owner *owner =  [NSKeyedUnarchiver unarchiveObjectWithData:encodedOwner];
        NSData *encodedPet = [encodedSlot objectForKey:PET];
        Pet *pet =  [NSKeyedUnarchiver unarchiveObjectWithData:encodedPet];
        NSData *encodedNotifications = [encodedSlot objectForKey:NOTIFICATION_REQUESTS];
        NSMutableArray *notifications = (NSMutableArray*) [NSKeyedUnarchiver unarchiveObjectWithData:encodedNotifications];
        NSData *encodedStorage = [encodedSlot objectForKey:STORAGE];
        NSMutableDictionary *storage = (NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:encodedStorage];
        return [NSDictionary dictionaryWithObjectsAndKeys:owner,OWNER,pet,PET,notifications,NOTIFICATION_REQUESTS,
            storage,STORAGE,nil];

    }
    return nil;
}

+(NSMutableArray *)loadSavedNotificationsFromSlot:(NSString*)saveSlot {
    NSDictionary *slot = [[NSUserDefaults standardUserDefaults] dictionaryForKey:saveSlot];
    NSData *encodedNotifications = [slot objectForKey:NOTIFICATION_REQUESTS];
    NSMutableArray *notifications = (NSMutableArray*) [NSKeyedUnarchiver unarchiveObjectWithData:encodedNotifications];
    return notifications;
}

@end
