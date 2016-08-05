//
//  NotificationCreater.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 29.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationRequest.h"
#import "Saver.h"
#import "Constants.h"

@interface NotificationCreater : NSObject

+ (NSMutableArray*)generateRandomNeed:(NSDate*) date andNoti: (NSMutableArray*) notificationRequests;
+ (NSMutableArray*)createNotifications:(NSMutableArray*) notificationRequests;
+ (NSMutableArray*)deleteMissedNotifications:(NSMutableArray*) notificationRequests;

@end
