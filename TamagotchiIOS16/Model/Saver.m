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
    [[NSUserDefaults standardUserDefaults] setObject:slot forKey:saveSlot];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)completeSave:(GameViewController *)controller {
    NSLog(@"complete save gets %@", controller);
    NSLog(@"controller's owner: %@", controller.owner);
    NSLog(@"controller's pet: %@", controller.pet);
    
    NSMutableDictionary *slot = [[NSMutableDictionary alloc] init];
    [slot setObject:controller.owner forKey:OWNER];
    [slot setObject:controller.pet forKey:PET];
    [[NSUserDefaults standardUserDefaults] setObject:slot forKey:controller.saveSlot];
    return [[NSUserDefaults standardUserDefaults] synchronize];;
}

+(BOOL)saveNotificationSchedulesOnExiting:(NSArray*)notifications {
    [[NSUserDefaults standardUserDefaults] setValue:notifications forKey:NOTIFICATION_REQUESTS];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
