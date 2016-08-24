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
    for (UILocalNotification *localNotification in localNotifications) {
        nextNotiText.text = [nextNotiText.text stringByAppendingString:[[localNotification.fireDate description] stringByAppendingString:@"\n"]];
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
    }
}

- (IBAction)genRandNoti:(id)sender {
    int numberOfNotifications = 5;

    int dist = 1800;
    Boolean passedSleepingTime = false;
    NSInteger sleepHourStart = 23*3600;
    NSInteger sleepTime = 8*3600;
    NSInteger sleepHourEnd = (sleepHourStart + sleepTime) % (24*3600);
    NSInteger timeTillSleepOver = 0;
    NSInteger maxRand = 3600 * 24;

    maxRand = maxRand - dist*[self calcStuff:numberOfNotifications-1]; // - distance between time
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
    
    [self refreshNoti];
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

