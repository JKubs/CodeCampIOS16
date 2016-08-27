//
//  TestmodeViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "TestmodeViewController.h"
#import "Food.h"
#import "GameOverController.h"


@implementation TestmodeViewController

- (void) refreshNoti{
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    nextNotiText.text = @"";
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    df.timeZone = [NSTimeZone localTimeZone];
    df.dateFormat = @"dd.MM.yyyy 'at' HH:mm:ss";
    for (UILocalNotification *localNotification in localNotifications) {
        nextNotiText.text = [nextNotiText.text stringByAppendingString:[[df stringFromDate:localNotification.fireDate] stringByAppendingString:@"\n"]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameOverButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                           style:UIBarButtonItemStyleDone
                                                          target:self
                                                          action:@selector(gameOver:)];
    self.navigationItem.rightBarButtonItem = self.gameOverButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    // Do any additional setup after loading the view, typically from a nib.
    [self refreshNoti];
}

- (IBAction)sendNotification:(id)sender {
    // Get the current date
    NSDate *pickerDate = [self.datePicker date];
    
    NSArray *needs = [NSArray arrayWithObjects:WISH_HUNGRY,WISH_THIRSTY,nil];
    NSInteger needsRand = (int)arc4random_uniform((int32_t)[needs count]);

    
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = pickerDate;
    localNotification.alertBody = [needs objectAtIndex:needsRand];
    localNotification.alertAction = @"Show me the item";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    NotificationRequest *newRequest = [[NotificationRequest alloc] init];
    newRequest.message = localNotification.alertBody;
    newRequest.timestamp = localNotification.fireDate;
    newRequest.subject = localNotification.alertBody; //TODO: change to a subject
    [self.gameController.notificationRequests addObject:newRequest];
    //TODO save noti
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHealth) name:@"PetHealth" object:nil];
    // Request to reload table view data
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
    
    [self refreshNoti];
}

- (int)calcStuff:(int)n{
    int erg = 1;
    for (int i = 1; i < n; i++) {
        erg += i;
    }
    return erg;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString:@"TestToOver"]) {
        GameOverController *gameOverController = [segue destinationViewController];
        gameOverController.pet = self.pet;
    }
}

- (void)gameOver:(id)sender {
    [self performSegueWithIdentifier:@"TestToOver" sender:sender];
}

- (void)updateHealth {
    if (self.pet.lives == 0) {
        [self gameOver:self];
        [self.gameController updateAchievements:PET_DEATHS forValue:1];
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
    self.notificationRequests = [[NSMutableArray alloc] init];
}

- (IBAction)killPet:(UIButton *)sender {
    self.pet.lives = 0;
    [Saver saveChangeOn:PET withValue:self.pet atSaveSlot:self.gameController.saveSlot];
    [Saver deleteCurrentSlotReference];
    [self updateHealth];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PetAnimation" object:self];
    }
}

@end