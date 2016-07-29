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
    NSDictionary *slot = [[NSUserDefaults standardUserDefaults] dictionaryForKey:controller.saveSlot];
    NSData *encodedOwner = [slot objectForKey:OWNER];
    Owner *owner =  [NSKeyedUnarchiver unarchiveObjectWithData:encodedOwner];
    NSData *encodedPet = [slot objectForKey:PET];
    Pet *pet =  [NSKeyedUnarchiver unarchiveObjectWithData:encodedPet];
    //NSArray *encodedNotifications = [slot mutableArrayValueForKey:NOTIFICATION_REQUESTS];
    //NSMutableArray *notifications = [[NSMutableArray alloc] init];
    //for (NSData *element in encodedNotifications) {
    //    [notifications addObject:[NSKeyedUnarchiver unarchiveObjectWithData:element]];
    //}
    NSData *encodedStorage = [slot objectForKey:STORAGE];
    NSMutableDictionary *storage = (NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:encodedStorage];

    //NSLog(@"%@",notifications);
    if(owner != nil) {
        controller.owner = owner;
    }
    if(pet != nil) {
        controller.pet = pet;
    }
    //if(notifications != nil) {
    //    controller.notificationRequests = notifications;
    //}
    if(storage != nil) {
        controller.storage = storage;
    }
    
    return YES;
}

+(NSString *)loadLastUsedSlotString {
    return [[NSUserDefaults standardUserDefaults] stringForKey:CURRENT_SLOT];
}

+(NSDictionary *)loadSlot:(NSString*)slot{
    NSDictionary *encodedSlot = [[NSUserDefaults standardUserDefaults] dictionaryForKey:slot];
    NSData *encodedOwner = [encodedSlot objectForKey:OWNER];
    Owner *owner =  [NSKeyedUnarchiver unarchiveObjectWithData:encodedOwner];
    NSData *encodedPet = [encodedSlot objectForKey:PET];
    Pet *pet =  [NSKeyedUnarchiver unarchiveObjectWithData:encodedPet];
    //NSData *encodedNotifications = [encodedSlot objectForKey:NOTIFICATION_REQUESTS];
    //NSMutableArray *notifications = [NSKeyedUnarchiver unarchiveObjectWithData:encodedNotifications];
    NSData *encodedStorage = [encodedSlot objectForKey:STORAGE];
    NSMutableDictionary *storage = (NSMutableDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:encodedStorage];
    return [NSDictionary dictionaryWithObjectsAndKeys:owner,OWNER,pet,PET,/*notifications,NOTIFICATION_REQUESTS,*/
            storage,STORAGE,nil];
}

+(NSMutableArray *)loadSavedNotificationsFromSlot:(NSString*)saveSlot {
    NSDictionary *slot = [[NSUserDefaults standardUserDefaults] dictionaryForKey:saveSlot];
    NSArray *encodedArray = [slot mutableArrayValueForKey:NOTIFICATION_REQUESTS];
    NSMutableArray *decodedArray = [[NSMutableArray alloc] init];
    for (NSData *element in encodedArray) {
        [decodedArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:element]];
    }
    return decodedArray;
}

@end
