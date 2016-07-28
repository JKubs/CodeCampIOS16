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
    NSData *encodedNotifications = [slot objectForKey:NOTIFICATION_REQUESTS];
    NSMutableArray *notifications = [NSKeyedUnarchiver unarchiveObjectWithData:encodedNotifications];
    
    if(owner != nil) {
        controller.owner = owner;
    }
    if(pet != nil) {
        controller.pet = pet;
    }
    if(notifications != nil) {
        controller.notificationRequests = notifications;
    }
    
    return YES;
}

+(NSString *)loadLastUsedSlot {
    NSData *encodedSlot = [[NSUserDefaults standardUserDefaults] dataForKey:CURRENT_SLOT];
    return [NSKeyedUnarchiver unarchiveObjectWithData:encodedSlot];
}

+(NSArray *)loadSavedNotificationsFromSlot:(NSString*)saveSlot {
    NSDictionary *slot = [[NSUserDefaults standardUserDefaults] dictionaryForKey:saveSlot];
    NSArray *encodedArray = [slot mutableArrayValueForKey:NOTIFICATION_REQUESTS];
    NSMutableArray *decodedArray = [[NSMutableArray alloc] init];
    for (NSData *element in encodedArray) {
        [decodedArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:element]];
    }
    return decodedArray;
}

@end
