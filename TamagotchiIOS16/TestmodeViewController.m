//
//  TestmodeViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "TestmodeViewController.h"

@implementation TestmodeViewController

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
    
}

- (IBAction)refreshNoti:(id)sender {
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    nextNotiText.text = @"";
    for (UILocalNotification *localNotification in localNotifications) {
        nextNotiText.text = [nextNotiText.text stringByAppendingString:[[localNotification.fireDate description] stringByAppendingString:@"\n"]];
    }
}


@end

