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
    NSLog(@"got gamecontroller %@", self.gameController);
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
    
    //resets notis TODO REMOVE LATER
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    return YES;
}

- (NSMutableArray*)deleteMissedNotifications:(NSMutableArray*) notificationRequests{
    
    NSMutableArray *missedNotis;
    NSMutableArray *deleteShit;
    
    for (NotificationRequest *notiRequ in notificationRequests) {
        NSLog(@"saved notirequ here");
        if (notiRequ.timestamp < [NSDate dateWithTimeIntervalSinceNow:0]) {
            [missedNotis addObject:notiRequ];
            [deleteShit addObject:notiRequ];
            NSLog(@"missed: %@", notiRequ.message);
        }
    }
    for (NotificationRequest *del in deleteShit) {
        [missedNotis removeObject:del];
    }
    
    return missedNotis;
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
//    [self checkForMissedNotifications];
//    [self calculateDatesForNeeds];
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
        
        
        
//        NSString *lastUsedSlot = [Loader loadLastUsedSlotString];
//        NSLog(@"%@",lastUsedSlot);
//        NSDictionary *slot = [Loader loadSlot:lastUsedSlot];
//        Pet *pet = [slot objectForKey:PET];
        
        
        //TODO implement when loading/saving is working and remove stuff from testmode
        if (self.gotStartedGameBool) {

        
            if ([notification.alertBody isEqualToString:WISH_HUNGRY]){
                int rand = (int)arc4random_uniform((uint32_t)[[self setupFoodList] count]);
                Food *randFood = [[self setupFoodList] objectAtIndex:rand];
                self.gameController.pet.currentWish = randFood.name;
            }else if ([notification.alertBody isEqualToString:WISH_THIRSTY]){
                int rand = (int)arc4random_uniform((uint32_t)[[self setupDrinkList] count]);
                Food *randFood = [[self setupDrinkList] objectAtIndex:rand];
                self.gameController.pet.currentWish = randFood.name;
            }else if ([notification.alertBody isEqualToString:WISH_TOO_LATE]){
                self.gameController.pet.lives--;
                self.gameController.pet.currentWish = NULL;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PetHealth" object:self];

            }
            
            NSMutableArray *notificationReqests = [Loader loadSavedNotificationsFromSlot:[Loader loadLastUsedSlotString]];
            //remove current shown alert from notification requests
            NSMutableArray *deleteShit = [[NSMutableArray alloc] init];
            for (NotificationRequest *noti in notificationReqests) {
                if([noti.timestamp isEqualToDate:notification.fireDate]){
                    NSLog(@"remove notification: %@ at time %@", noti, noti.timestamp);
                    [deleteShit addObject:noti];
                }
            }
            for (NotificationRequest *noti in deleteShit) {
                [notificationReqests delete:noti];
            }
        }
        
//        Saver saveNotificationSchedules:notificationReqests toSlot:
        
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

- (NSArray*) setupFoodList {
    Food *apple = [[Food alloc] init];
    apple.name = @"apple";
    apple.cost = 5;
    Food *bread = [[Food alloc] init];
    bread.name = @"bread";
    bread.cost = 3;
    Food *candy = [[Food alloc] init];
    candy.name = @"candy";
    candy.cost = 2;
    Food *burger = [[Food alloc] init];
    burger.name = @"burger";
    burger.cost = 6;
    return [[NSArray alloc] initWithObjects:apple, bread, candy, burger, nil];
}

- (NSArray*) setupDrinkList {
    Food *soda = [[Food alloc] init];
    soda.name = @"soda";
    soda.cost = 5;
    Food *water =[[Food alloc] init];
    water.name = @"water";
    water.cost = 2;
    Food *beer = [[Food alloc] init];
    beer.name = @"beer";
    beer.cost = 4;
    Food *wine = [[Food alloc] init];
    wine.name = @"wine";
    wine.cost = 7;
    return [[NSArray alloc] initWithObjects:soda, water, wine, nil];
}


-(BOOL)isClearStart {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:SAVE_SLOT_1] == nil &&
    [[NSUserDefaults standardUserDefaults] dictionaryForKey:SAVE_SLOT_2] == nil &&
    [[NSUserDefaults standardUserDefaults] dictionaryForKey:SAVE_SLOT_3] == nil &&
    [[NSUserDefaults standardUserDefaults] dictionaryForKey:SAVE_SLOT_4] == nil;
}

@end
