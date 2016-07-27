//
//  Saver.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameViewController.h"
#import "NotificationRequest.h"

#define SAVE_SLOT_1 @"ss1"
#define SAVE_SLOT_2 @"ss2"
#define SAVE_SLOT_3 @"ss3"
#define SAVE_SLOT_4 @"ss4"
#define NOTIFICATION_REQUESTS @"notireq"
#define OWNER @"owner"
#define OWNER_NAME @"ownername"
#define OWNER_MONEY @"ownermoney"
#define OWNER_STORAGE @"ownerstorage"
#define PET @"pet"
#define PET_NAME @"petname"
#define PET_HEALTH @"pethealth"
#define PET_LIVES @"petlives"
#define PET_WISHES @"petwishes"
#define CURRENT_WISH @"wish"

@class GameViewController;

@interface Saver : NSObject

+(BOOL)saveChangeOn:(NSString*)key withValue:(id)value atSaveSlot:(NSString*)saveSlot;
+(BOOL)completeSave:(GameViewController*)controller;
+(BOOL)saveNotificationSchedules:(NSArray*)notifications;

@end
