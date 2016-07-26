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
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    if([localNotifications count] == 0){
        //same stuff as in testmodeViewControllwe TODO make a global method
        int numberOfNotifications = 5;
        
        int dist = 1800;
        Boolean passedSleepingTime = false;
        NSInteger sleepHourStart = 23*3600;
        NSInteger sleepTime = 8*3600;
        NSInteger sleepHourEnd = (sleepHourStart + sleepTime) % (24*3600);
        NSInteger timeTillSleepOver = 0;
        NSInteger maxRand = 3600 * 24;
        
        int erg = 1;
        for (int i = 1; i < numberOfNotifications-1; i++) {
            erg += i;
        }
        
        maxRand = maxRand - dist*erg; // - distance between time
        // maxRand = maxRand - (sleepTime-timeTillSleepOver);
        
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
            
            UILocalNotification* localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:rand];
            localNotification.alertBody = @"FEED ME !!!!";
            localNotification.alertAction = @"Show me the item";
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
        
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        
        // Request to reload table view data
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    }else if([localNotifications count] < 5){
        NSInteger dist = 1800;
        UILocalNotification *first = [localNotifications firstObject];
        UILocalNotification *last = [localNotifications lastObject];
        NSDate *lastDate = [last fireDate];
        NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval timeFromNowToLast = [lastDate timeIntervalSinceDate:currentDate];
        NSInteger timeToFullDay = 24*3600 - (timeFromNowToLast + dist);
        NSInteger numberOfNotifications = 5 - [localNotifications count];
        
        
        
        
        Boolean passedSleepingTime = false;
        NSInteger sleepHourStart = 23*3600;
        NSInteger sleepTime = 8*3600;
        NSInteger sleepHourEnd = (sleepHourStart + sleepTime) % (24*3600);
        NSInteger timeTillSleepOver = 0;
        NSInteger maxRand = 3600 * 24;
        
        int erg = 1;
        for (int i = 1; i < numberOfNotifications-1; i++) {
            erg += i;
        }
        
        maxRand = maxRand - dist*erg; // - distance between time
        
        //TODO generate rand number from lastDate to lastDate+timeToFullDate (if timeToFullDate in or after sleeping time then lastDate+ timeToFullDate + sleepingTime)
        
    }
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

@end
