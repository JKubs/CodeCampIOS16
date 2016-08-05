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
#import "Constants.h"

@class GameViewController;

@interface Saver : NSObject

+(BOOL)saveChangeOn:(NSString*)key withValue:(id)value atSaveSlot:(NSString*)saveSlot;
+(BOOL)completeSave:(GameViewController*)controller;
+(BOOL)saveNotificationSchedules:(NSArray*)notifications toSlot:(NSString*)saveSlot;
+(BOOL)deleteSlot:(NSString*)saveSlot;

@end
