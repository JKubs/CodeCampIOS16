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
    
    if(owner != nil) {
        controller.owner = owner;
    }
    if(pet != nil) {
        controller.pet = pet;
    }
    
    return YES;
}

+(NSString *)loadLastUsedSlot {
    NSData *encodedSlot = [[NSUserDefaults standardUserDefaults] dataForKey:CURRENT_SLOT];
    return [NSKeyedUnarchiver unarchiveObjectWithData:encodedSlot];
}

+(NSArray *)loadSavedNotifications {
    NSArray *encodedArray = [[NSUserDefaults standardUserDefaults] arrayForKey:NOTIFICATION_REQUESTS];
    NSMutableArray *decodedArray = [[NSMutableArray alloc] init];
    for (NSData *element in encodedArray) {
        [decodedArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:element]];
    }
    return decodedArray;
}

@end
