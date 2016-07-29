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
#define STORAGE @"ownerstorage"
#define PET @"pet"
#define PET_NAME @"petname"
#define PET_HEALTH @"pethealth"
#define PET_LIVES @"petlives"
#define PET_WISHES @"petwishes"
#define CURRENT_WISH @"wish"
#define FOOD_APPLE @"apple"
#define FOOD_SODA @"soda"
#define WISH_HUNGRY @"GIVE ME FOOD!!!"
#define WISH_THIRSTY @"I WANT BEER!!!"
#define CURRENT_SLOT @"currentslot"
#define WISH_TOO_LATE @"you were too l8! i h8 u -.-"
#define SAVE_FILE_NAME @"SaveFile.txt"

@class GameViewController;

@interface Saver : NSObject

+(BOOL)saveChangeOn:(NSString*)key withValue:(id)value atSaveSlot:(NSString*)saveSlot;
+(BOOL)completeSave:(GameViewController*)controller;
+(BOOL)saveNotificationSchedules:(NSArray*)notifications toSlot:(NSString*)saveSlot;

@end
