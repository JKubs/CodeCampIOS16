//
//  NotificationCreater.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 29.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "NotificationCreater.h"

@implementation NotificationCreater

+ (NSMutableArray*)generateRandomNeed:(NSDate*) date andNoti:(NSMutableArray *)notificationRequests{
    NSArray *needs = [NSArray arrayWithObjects:WISH_HUNGRY,WISH_THIRSTY,nil];
    NSInteger needsRand = (int)arc4random_uniform((uint32_t)[needs count]);
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.alertBody = [needs objectAtIndex:needsRand];
    localNotification.alertAction = @"Show me the item";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NotificationRequest *newRequest = [[NotificationRequest alloc] init];
    newRequest.message = localNotification.alertBody;
    newRequest.timestamp = localNotification.fireDate;
    newRequest.subject = localNotification.alertBody; //TODO: change to a subject
    [notificationRequests addObject:newRequest];

    
    NSInteger tooLate = 1200;
    UILocalNotification* localNotificationEnd = [[UILocalNotification alloc] init];
    localNotificationEnd.fireDate = [date dateByAddingTimeInterval:tooLate];
    localNotificationEnd.alertBody = WISH_TOO_LATE;
    localNotificationEnd.alertAction = @"Show me the item";
    localNotificationEnd.timeZone = [NSTimeZone defaultTimeZone];
    localNotificationEnd.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotificationEnd];
    
    NotificationRequest *newLateRequest = [[NotificationRequest alloc] init];
    newLateRequest.message = localNotificationEnd.alertBody;
    newLateRequest.timestamp = localNotificationEnd.fireDate;
    newLateRequest.subject = localNotificationEnd.alertBody; //TODO: change to a subject
    [notificationRequests addObject:newLateRequest];
    
    //    NSLog(@"notiRequ to save:");
    //    NSLog(@"%@", newLateRequest);
    //    NSLog(@"notiRequ Saved:");
    //    NSLog(@"%@", self.gameController.notificationRequests);
    //    for (NotificationRequest *noti in self.gameController.notificationRequests) {
    //        NSLog(@"%@", noti);
    //    }
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    NSLog(@"created: %@", newRequest);
    return notificationRequests;
}

+ (NSMutableArray*)deleteMissedNotifications:(NSMutableArray*) notificationRequests{
    
    NSMutableArray *missedNotis = [[NSMutableArray alloc] init];
    NSMutableArray *deleteShit = [[NSMutableArray alloc]init];
    
    for (NotificationRequest *notiRequ in notificationRequests) {
//        if (notiRequ.timestamp < [NSDate dateWithTimeIntervalSinceNow:0]) {
        if ([notiRequ.timestamp timeIntervalSinceNow] < 0) {
            [missedNotis addObject:notiRequ];
            [deleteShit addObject:notiRequ];
            NSLog(@"missed: %@ , %@, %@", notiRequ, notiRequ.timestamp, notiRequ.message);
        }
    }
    for (NotificationRequest *del in deleteShit) {
        [notificationRequests removeObject:del];
    }
    return missedNotis;
}

+ (void)generateFromNotiRequests:(NSMutableArray*) notificationRequests{
    for (NotificationRequest *nR in notificationRequests) {
        NSLog(@"got %@ to create a new local notification", nR);
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = nR.timestamp;
        localNotification.alertBody = nR.message;
        localNotification.alertAction = @"Show me the item";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
}


+ (NSMutableArray*)createNotifications:(NSMutableArray*) notificationRequests{
    int dist = 1800;
    BOOL passedSleepingTime = NO;
    NSInteger sleepHourStart = 23*3600;
    NSInteger sleepTime = 8*3600;
    NSInteger sleepHourEnd = (sleepHourStart + sleepTime) % (24*3600);
    NSInteger timeTillSleepOver = 0;
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    NSMutableArray *wishLocNoti = [[NSMutableArray alloc] init];
    for (UILocalNotification *noti in localNotifications) {
        if([noti.alertBody isEqualToString:WISH_HUNGRY] || [noti.alertBody isEqualToString:WISH_THIRSTY]){
            [wishLocNoti addObject:noti];
        }
    }
    
    
    NSLog(@"locnotiCount %ld (+TooLateNotis)", [wishLocNoti count]);
    NSLog(@"notiReqCount %ld", [notificationRequests count]);
    if([wishLocNoti count] == 0){
        //same stuff as in testmodeViewControllwe TODO make a global method
        int numberOfNotifications = 5;
        
        int erg = 1;
        for (int i = 1; i < numberOfNotifications-1; i++) {
            erg += i;
        }
        NSInteger maxRand = 3600 * 24;
        maxRand = maxRand - dist*erg; // - distance between time
        
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
        NSInteger currentSecond = [components hour] * 3600 + [components minute] * 60 + [components second];
        
        
        
        if (sleepHourStart >= sleepHourEnd) { // if he sleeps over midnight
            if(currentSecond >= sleepHourStart){ // you are in sleepTime b4 midnight
                timeTillSleepOver = 24*3600 - currentSecond + sleepHourEnd;
            }else if(currentSecond <= sleepHourEnd){ // you are in sleep Time after midnight
                timeTillSleepOver = sleepHourEnd - currentSecond;
            }
        }else if(currentSecond >= sleepHourStart && currentSecond <= sleepHourEnd){
            timeTillSleepOver = sleepHourEnd - currentSecond;
        }
        //NSLog(@"\n ttso: %ld--------------------------", timeTillSleepOver);
        maxRand = maxRand - (sleepTime-timeTillSleepOver);
        
        NSMutableArray *randDates = [NSMutableArray array];
        for (int i = 0; i < numberOfNotifications; i++){
            [randDates addObject: [NSNumber numberWithInt: arc4random_uniform((uint32_t)maxRand)]];
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        [randDates sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        //NSString * result = [[randDates valueForKey:@"description"] componentsJoinedByString:@" "];
        //NSLog(result);
        
        
        for (int i = 0; i < numberOfNotifications; i++) {
            NSInteger rand = [[randDates objectAtIndex:i ] integerValue];
            rand = rand + dist*i;
            rand = rand + timeTillSleepOver;
            
            if (sleepHourStart >= sleepHourEnd &&
                (rand+currentSecond >= sleepHourStart || rand+currentSecond <= sleepHourEnd)) { // if he sleeps over midnight
                passedSleepingTime = YES;
            }else if(rand+currentSecond >= sleepHourStart && rand+currentSecond <= sleepHourEnd){
                passedSleepingTime = YES;
            }
            
            if(passedSleepingTime){
                rand = rand + sleepTime;
            }
            
            notificationRequests =
                [self generateRandomNeed:[NSDate dateWithTimeIntervalSinceNow:rand] andNoti:notificationRequests];
        }
    }else if([wishLocNoti count] < 5){
        UILocalNotification *last = [wishLocNoti lastObject];
        NSDate *lastDate = [last fireDate];
        NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSInteger timeFromNowToLast = [lastDate timeIntervalSinceDate:currentDate]; //sometimes its realy high
        NSLog(@" lD: %@, cD: %@, tFNTL: %ld", lastDate, currentDate, timeFromNowToLast);
        NSInteger timeToFullDay = 24*3600 - (timeFromNowToLast + dist);
        NSInteger numberOfNotifications = 5 - [wishLocNoti count];
        NSInteger maxTimeAfterWaitForSleep = sleepTime + 5; //to be changed
        BOOL setAllNotisBeforSleep = NO;
        
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:lastDate];
        NSInteger lastTimeInSeconds = [components hour] * 3600 + [components minute] * 60 + [components second];
        
        int erg = 1;
        for (int i = 1; i < numberOfNotifications-1; i++) {
            erg += i;
        }
        NSInteger maxRand;
        if (timeToFullDay < maxTimeAfterWaitForSleep) {
            // maxRand is last to sleepstart
            maxRand = (sleepHourStart < lastTimeInSeconds) ?
            sleepHourStart + 24*3600 - lastTimeInSeconds : sleepHourStart - lastTimeInSeconds;
            maxRand = (maxRand > timeToFullDay) ? timeToFullDay : maxRand;
            
            setAllNotisBeforSleep = YES;
         //   NSLog(@"timeToFullDay < maxTimeAfterWaitForSleep");
        }else{
            //maxrand is last to timeToFullDay and with "passedSleepingTime" stuff
            maxRand = timeToFullDay;
            setAllNotisBeforSleep = NO;
        //    NSLog(@"timeToFullDay > maxTimeAfterWaitForSleep");
        }
        
        
        maxRand = maxRand - dist*erg; // - distance between time
        
      //  NSLog(@"\n maxRand: %ld \n dist: %d \n erg: %d", maxRand, dist, erg);
        
        NSMutableArray *randDates = [NSMutableArray array];
        for (int i = 0; i < numberOfNotifications; i++){
            [randDates addObject: [NSNumber numberWithInt: arc4random_uniform((uint32_t)maxRand)]];
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        [randDates sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        
        
        for (int i = 0; i < numberOfNotifications; i++) {
            NSInteger rand = [[randDates objectAtIndex:i ] integerValue];
            rand = rand + dist*i;
            
            NSLog(@"\n rand: %ld \n lastTimeInSec: %ld \n startSleep: %ld \n endsleep: %ld \n lasttimetillsleep: %ld \n maxRand: %ld \n timetofullday: %ld", rand, lastTimeInSeconds, sleepHourStart, sleepHourEnd, lastTimeInSeconds, maxRand, timeToFullDay);
            
            if(!setAllNotisBeforSleep){
                if (sleepHourStart >= sleepHourEnd &&
                    (rand+lastTimeInSeconds >= sleepHourStart || rand+lastTimeInSeconds <= sleepHourEnd)) { // if he sleeps over midnight
                    passedSleepingTime = YES;
                }else if(rand+lastTimeInSeconds >= sleepHourStart && rand+lastTimeInSeconds <= sleepHourEnd){
                    passedSleepingTime = YES;
                }
                if(passedSleepingTime){
                    rand = rand + sleepTime;
                }
            }
            
            //NSLog(@"\npassedSleepingTime: %d \n rand: %ld \n startSleep: %ld \n endsleep: %ld ", passedSleepingTime, rand +currentSecond, sleepHourStart, sleepHourEnd);
            
            notificationRequests =
                [self generateRandomNeed:[NSDate dateWithTimeInterval:rand sinceDate:lastDate] andNoti:notificationRequests];
        }
    }
    //NSArray *newlocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //for (UILocalNotification *locationNotification in newlocalNotifications) {
    //    NSLog(@"Existing Notification: %@", locationNotification.alertBody);
    //}
    //NSLog(@"%@", notificationRequests);
    
    return notificationRequests;
}
@end