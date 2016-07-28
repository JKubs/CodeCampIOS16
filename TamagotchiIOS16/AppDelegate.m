//
//  AppDelegate.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    if(self.gameController == nil) {
        [self findGameController];
    }
    
    [self checkForMissedNotifications];
    
    int dist = 1800;
    Boolean passedSleepingTime = false;
    NSInteger sleepHourStart = 23*3600;
    NSInteger sleepTime = 8*3600;
    NSInteger sleepHourEnd = (sleepHourStart + sleepTime) % (24*3600);
    NSInteger timeTillSleepOver = 0;
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if([localNotifications count] == 0){
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
            [randDates addObject: [NSNumber numberWithInt: arc4random_uniform(maxRand)]];
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES];
        [randDates sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        //NSString * result = [[randDates valueForKey:@"description"] componentsJoinedByString:@" "];
        //NSLog(result);
        
        
        for (int i = 0; i < numberOfNotifications; i++) {
            NSInteger rand = [[randDates objectAtIndex:i ] integerValue];
            rand = rand + dist*i;
            rand = rand + timeTillSleepOver;
            
            //NSLog(@"\n rand: %ld \n startSleep: %ld \n endsleep: %ld", rand+currentSecond, sleepHourStart, sleepHourEnd);
            
            if (sleepHourStart >= sleepHourEnd &&
                (rand+currentSecond >= sleepHourStart || rand+currentSecond <= sleepHourEnd)) { // if he sleeps over midnight
                passedSleepingTime = true;
            }else if(rand+currentSecond >= sleepHourStart && rand+currentSecond <= sleepHourEnd){
                passedSleepingTime = true;
            }
            
            if(passedSleepingTime){
                rand = rand + sleepTime;
            }
            
            //NSLog(@"\npassedSleepingTime: %d \n rand: %ld \n startSleep: %ld \n endsleep: %ld", passedSleepingTime, rand +currentSecond, sleepHourStart, sleepHourEnd);

            [self generateRandomNeed:[NSDate dateWithTimeIntervalSinceNow:rand]];
        }
    }else if([localNotifications count] < 5){
        UILocalNotification *first = [localNotifications firstObject];
        UILocalNotification *last = [localNotifications lastObject];
        NSDate *lastDate = [last fireDate];
        NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSInteger timeFromNowToLast = [lastDate timeIntervalSinceDate:currentDate];
        NSInteger timeToFullDay = 24*3600 - (timeFromNowToLast + dist);
        NSInteger numberOfNotifications = 5 - [localNotifications count];
        NSInteger maxTimeAfterWaitForSleep = sleepTime + 5; //to be changed
        Boolean setAllNotisBeforSleep = false;
        
        
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
            
            setAllNotisBeforSleep = true;
            NSLog(@"timeToFullDay < maxTimeAfterWaitForSleep");
        }else{
            //maxrand is last to timeToFullDay and with "passedSleepingTime" stuff
            maxRand = timeToFullDay;
            setAllNotisBeforSleep = false;
            NSLog(@"timeToFullDay > maxTimeAfterWaitForSleep");
        }
        
        
        maxRand = maxRand - dist*erg; // - distance between time
        
        NSLog(@"\n maxRand: %ld \n dist: %ld \n erg: %ld", maxRand, dist, erg);
        
        NSMutableArray *randDates = [NSMutableArray array];
        for (int i = 0; i < numberOfNotifications; i++){
            [randDates addObject: [NSNumber numberWithInt: arc4random_uniform(maxRand)]];
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
                    passedSleepingTime = true;
                }else if(rand+lastTimeInSeconds >= sleepHourStart && rand+lastTimeInSeconds <= sleepHourEnd){
                    passedSleepingTime = true;
                }
                if(passedSleepingTime){
                    rand = rand + sleepTime;
                }
            }
            
            //NSLog(@"\npassedSleepingTime: %d \n rand: %ld \n startSleep: %ld \n endsleep: %ld ", passedSleepingTime, rand +currentSecond, sleepHourStart, sleepHourEnd);
        
            [self generateRandomNeed:[NSDate dateWithTimeInterval:rand sinceDate:lastDate]];
        }
    }
    NSArray *newlocalNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (locationNotification in newlocalNotifications) {
        NSLog(@" %@ --", locationNotification.alertBody);
    }
    
    return YES;
}

- (void)generateRandomNeed:(NSDate*) date{
    NSArray *needs = [NSArray arrayWithObjects:WISH_HUNGRY,WISH_THIRSTY,nil];
    NSInteger needsRand = (int)arc4random_uniform([needs count]);
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.alertBody = [needs objectAtIndex:needsRand];
    localNotification.alertAction = @"Show me the item";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NotificationRequest *newRequest;
    newRequest.message = localNotification.alertBody;
    newRequest.timestamp = localNotification.fireDate;
    newRequest.subject = localNotification.alertBody; //TODO: change to a subject
    [self.gameController.notificationRequests addObject:newRequest];
    
    
    NSInteger tooLate = 1200;
    UILocalNotification* localNotificationEnd = [[UILocalNotification alloc] init];
    localNotificationEnd.fireDate = [date dateByAddingTimeInterval:tooLate];
    localNotificationEnd.alertBody = WISH_TOO_LATE;
    localNotificationEnd.alertAction = @"Show me the item";
    localNotificationEnd.timeZone = [NSTimeZone defaultTimeZone];
    localNotificationEnd.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotificationEnd];

    NotificationRequest *newLateRequest;
    newLateRequest.message = localNotificationEnd.alertBody;
    newLateRequest.timestamp = localNotificationEnd.fireDate;
    newLateRequest.subject = localNotificationEnd.alertBody; //TODO: change to a subject
    [self.gameController.notificationRequests addObject:newLateRequest];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
}

- (void)checkForMissedNotifications{
    
    NSMutableArray *missedNotis;
    //for (UILocalNotification* localNotification  in localNotifications) {
    //    BOOL *gotIt = false;
    //    for (NotificationRequest *notiRequ in self.gameController.notificationRequests) {
    //        if([notiRequ isEqual:localNotification.fireDate]){
    //            gotIt = true;
     //       }
     //   }
     //   if (!gotIt) {
     //       [missedNotis addObject:localNotification];
     //       NSLog(@"missed: %@", localNotification.alertBody);
      //  }
    //}
    
    for (NotificationRequest *notiRequ in self.gameController.notificationRequests) {
        if (notiRequ.timestamp < [NSDate dateWithTimeIntervalSinceNow:0]) {
            [missedNotis addObject:notiRequ];
            [self.gameController.notificationRequests removeObject:notiRequ];
            NSLog(@"missed: %@", notiRequ.message);
        }
    }
    
    int missedHungry = 0;
    for (NotificationRequest *notiR in missedNotis) {
        if([notiR.message isEqualToString:WISH_TOO_LATE] || [notiR isEqual:WISH_THIRSTY] ){
            missedHungry++;
        }
    }
    
    if(missedHungry > 3){
        //TODO write in in savefile
        NSLog(@"your pet died -.- you got %d missed \"hungry\"-Notifications", missedHungry);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if(self.gameController == nil) {
        [self findGameController];
    }
    BOOL saveSucceeded = [Saver completeSave:self.gameController];
    if(saveSucceeded) NSLog(@"Saved game");
    else NSLog(@"Error : saving game failed");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self checkForMissedNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if(self.gameController == nil) {
        [self findGameController];
    }
    
    BOOL saveSucceeded = [Saver completeSave:self.gameController];
    if(saveSucceeded) NSLog(@"Saved game");
    else NSLog(@"Error : saving game failed");
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        //UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Reminder"
         //                                                              message:notification.alertBody
         //                                                       preferredStyle:UIAlertControllerStyleAlert];
        
       // UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
        //                                                      handler:^(UIAlertAction * action) {}];
        
       // [alert addAction:defaultAction];
        //[self.window.rootViewController presentViewController:alert animated:YES completion:nil];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"                                                        message:notification.alertBody
            delegate:self cancelButtonTitle:@"OK"
            otherButtonTitles:nil];
        [alert show];


    }
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
}

-(void)findGameController {
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    GameViewController *result;
    
    //check to see if navbar "get" worked
    if (navigationController.viewControllers)
        
        //look for the nav controller in tab bar views
        for (UINavigationController *view in navigationController.viewControllers) {
            //when found, do the same thing to find the GameViewController under the nav controller
            if ([view isKindOfClass:[GameViewController class]])
                result = (GameViewController *) view;
            if ([view isKindOfClass:[UINavigationController class]])
                for (UIViewController *view2 in view.viewControllers)
                    if ([view2 isKindOfClass:[GameViewController class]])
                        result = (GameViewController *) view2;
        }
    self.gameController = result;
    
}

@end
