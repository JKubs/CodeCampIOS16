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


- (void)gotStartedGame{
    self.gotStartedGameBool = YES;
    [self findGameController];
    //NSLog(@"got gamecontroller %@", self.gameController);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotStartedGame) name:@"GameStarted" object: nil];

    // Handle launching from a notification
    
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        // Set icon badge number to zero
        application.applicationIconBadgeNumber = 0;
    }
    
    if(self.gameController == nil) {
        [self findGameController];
    }
    
    if([self isClearStart]){
        self.firstStart = YES;
    }else{
        self.firstStart = NO;
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
    [self findGameController];
    [Saver completeSave:self.gameController];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if(self.gotStartedGameBool){
        NSMutableArray *missedNotis = [NotificationCreater deleteMissedNotifications:self.gameController.notificationRequests];
         [Saver saveNotificationSchedules:self.gameController.notificationRequests toSlot:self.gameController.saveSlot];
        
        NotificationRequest *lastMissed = [missedNotis lastObject];
        
        for (NotificationRequest *notiR in missedNotis) {
            if([notiR.message isEqualToString:WISH_TOO_LATE] && self.gameController.pet.lives >= 0){
                self.gameController.pet.lives--;
                self.gameController.pet.currentWish = NULL;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PetHealth" object:self];
            }
        }
        
        NSLog(@"last missed noti text: %@", lastMissed.message);
        if(self.gameController.pet.lives <= 0){
            NSLog(@"your pet died -.- ");
        }else if ([lastMissed.message isEqualToString:WISH_HUNGRY]){
            int rand = (int)arc4random_uniform((uint32_t)[self.gameController.foodList count]);
            Food *randFood = [self.gameController.foodList objectAtIndex:rand];
            self.gameController.pet.currentWish = randFood.name;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PetHungry" object:self.gameController.pet];
        }else if ([lastMissed.message isEqualToString:WISH_THIRSTY]){
            int rand = (int)arc4random_uniform((uint32_t)[self.gameController.drinkList count]);
            Food *randFood = [self.gameController.drinkList objectAtIndex:rand];
            self.gameController.pet.currentWish = randFood.name;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PetHungry" object:self.gameController.pet];
        }
        
        [NotificationCreater createNotifications:self.gameController.notificationRequests];
        [Saver saveChangeOn:PET withValue:self.gameController.pet atSaveSlot:self.gameController.saveSlot];
       
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self findGameController];
    
    [Saver completeSave:self.gameController];
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"                                                        message:notification.alertBody
            delegate:self cancelButtonTitle:@"OK"
            otherButtonTitles:nil];
        [alert show];
        
        if (self.gotStartedGameBool) {
            if ([notification.alertBody isEqualToString:WISH_HUNGRY]){
                //choose random food for need
                int rand = (int)arc4random_uniform((uint32_t)[self.gameController.foodList count]);
                Food *randFood = [self.gameController.foodList objectAtIndex:rand];
                self.gameController.pet.currentWish = randFood.name;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PetHungry" object:self];
            }else if ([notification.alertBody isEqualToString:WISH_THIRSTY]){
                //choose random drink for need
                int rand = (int)arc4random_uniform((uint32_t)[self.gameController.drinkList count]);
                Food *randFood = [self.gameController.drinkList objectAtIndex:rand];
                self.gameController.pet.currentWish = randFood.name;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PetHungry" object:self];
            }else if ([notification.alertBody isEqualToString:WISH_TOO_LATE]){
                //remove live is notification is a "missed notification"
                self.gameController.pet.lives--;
                self.gameController.pet.currentWish = NULL;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PetHealth" object:self];
            }
          
            //remove current shown alert from notification requests
            NSMutableArray *deleteShit = [[NSMutableArray alloc] init];
            for (NotificationRequest *noti in self.gameController.notificationRequests) {
                if([noti.timestamp isEqualToDate:notification.fireDate]){
                    NSLog(@"remove notification: %@ at time %@", noti, noti.timestamp);
                    [deleteShit addObject:noti];
                }
            }
            for (NotificationRequest *noti in deleteShit) {
                [self.gameController.notificationRequests removeObject:noti];
            }
        }
        
        //TODO save noti
        [Saver saveChangeOn:PET withValue:self.gameController.pet atSaveSlot:self.gameController.saveSlot];
        [Saver saveNotificationSchedules:self.gameController.notificationRequests toSlot:self.gameController.saveSlot];
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

-(BOOL)isClearStart {
    return [Loader loadLastUsedSlotString] == nil;
}

@end
