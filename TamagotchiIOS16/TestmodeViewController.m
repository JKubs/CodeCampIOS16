//
//  TestmodeViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "TestmodeViewController.h"

@implementation TestmodeViewController

- (void) refreshNoti{
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    nextNotiText.text = @"";
    for (UILocalNotification *localNotification in localNotifications) {
        nextNotiText.text = [nextNotiText.text stringByAppendingString:[[localNotification.fireDate description] stringByAppendingString:@"\n"]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    nextNotiText.text = @"";
    for (UILocalNotification *localNotification in localNotifications) {
        nextNotiText.text = [nextNotiText.text stringByAppendingString:[[localNotification.fireDate description] stringByAppendingString:@"\n"]];
    }

}

- (IBAction)sendNotification:(id)sender {
    // Get the current date
    NSDate *pickerDate = [self.datePicker date];
    
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = pickerDate;
    localNotification.alertBody = @"bla bla";
    localNotification.alertAction = @"Show me the item";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    nextNotiText.text = @"";
    for (UILocalNotification *localNotification in localNotifications) {
        nextNotiText.text = [nextNotiText.text stringByAppendingString:[[localNotification.fireDate description] stringByAppendingString:@"\n"]];
    }

}


- (IBAction)genRandNoti:(id)sender {
generateNotifications:5;
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    nextNotiText.text = @"";
    for (UILocalNotification *localNotification in localNotifications) {
        nextNotiText.text = [nextNotiText.text stringByAppendingString:[[localNotification.fireDate description] stringByAppendingString:@"\n"]];
    }

}

- (IBAction)resetNotis:(id)sender {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    nextNotiText.text = @"";
    for (UILocalNotification *localNotification in localNotifications) {
        nextNotiText.text = [nextNotiText.text stringByAppendingString:[[localNotification.fireDate description] stringByAppendingString:@"\n"]];
    }

}

- (void) generateNotifications:(int)numberOfNotifications{
    int maxHours = 24; // 24h - sleep time
    int maxRand = 36 * maxHours;
    NSInteger randMultiplier;
    NSArray *randomDates[numberOfNotifications];
    //for (int i = 0; i < numberOfNotifications; i++) {
    //    randomDates[i] = arc4random_uniform(maxRand) * 100;
    //}
    
    NSMutableArray *randDates = [NSMutableArray array];
    for (int i = 0; i < numberOfNotifications; i++)
        [randDates addObject: [NSNumber numberWithInt: arc4random_uniform(maxRand)*100]];

    
    for (NSNumber *i in randDates) {
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:[i doubleValue]];
        localNotification.alertBody = @"bla bla";
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
    
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    nextNotiText.text = @"";
    for (UILocalNotification *localNotification in localNotifications) {
        nextNotiText.text = [nextNotiText.text stringByAppendingString:[[localNotification.fireDate description] stringByAppendingString:@"\n"]];
    }

}
@end

