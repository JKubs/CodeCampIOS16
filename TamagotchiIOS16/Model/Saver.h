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

@interface Saver : NSObject

+(BOOL)saveChangeOn:(NSString*)key withValue:(id)value;
+(BOOL)completeSave:(GameViewController*)controller;
+(BOOL)saveNotificationSchedulesOnExiting:(NSArray*)notifications;

@end
