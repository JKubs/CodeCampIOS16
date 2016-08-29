//
//  GameViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameViewController.h"
#import "GameOverController.h"

@interface GameViewController ()
@end

@implementation GameViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.gameOverButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(gameOver:)];
    self.navigationItem.rightBarButtonItem = self.gameOverButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.hidesBackButton = YES;
    UIImage *calm1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_calm_1.png", self.pet.type]];
    UIImage *calm2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_calm_2.png", self.pet.type]];
    self.calmAnimation = [[NSArray alloc] initWithObjects:calm1, calm2, nil];
    UIImage *hungry1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_hungry_1.png", self.pet.type]];
    UIImage *hungry2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_hungry_2.png", self.pet.type]];
    self.hungryAnimation = [[NSArray alloc] initWithObjects:hungry1, hungry2, nil];
    UIImage *happy1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_happy_1.png", self.pet.type]];
    UIImage *happy2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_happy_2.png", self.pet.type]];
    self.happyAnimation = [[NSArray alloc] initWithObjects:happy1, happy2, nil];
    if (self.pet.currentWish == nil) {
        self.petState = @"calm";
        self.speechView.hidden = YES;
    } else {
        self.petState = @"hungry";
        self.speechFood.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.pet.currentWish]];
        self.speechView.hidden = NO;
    }
    [self setupFoodList];
    [self setupDrinkList];
    [self setupStoreFood];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAnimation) name:@"PetAnimation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHunger) name:@"PetHungry" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHealth) name:@"PetHealth" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GameStarted" object:self];

    if(self.notificationRequests == nil){
        self.notificationRequests = [[NSMutableArray alloc]init];
    }
    
    //notification stuff
    
    NSMutableArray *missedNotis = [NotificationCreater deleteMissedNotifications:self.notificationRequests];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [NotificationCreater generateFromNotiRequests:self.notificationRequests];
    
    
    if(self.slotChanged) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        [NotificationCreater generateFromNotiRequests:self.notificationRequests];
        NSLog(@"other slot than b4 or new 1");
    }
    
    NotificationRequest *lastMissed = [missedNotis lastObject];
    
    //remove 1 live for each missed "too late" notification
    for (NotificationRequest *notiR in missedNotis) {
        if([notiR.message isEqualToString:WISH_TOO_LATE] && self.pet.lives >= 0){
            self.pet.lives--;
            self.pet.currentWish = nil;
            self.speechFood.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PetHealth" object:self];
        }
    }
    
    if(self.pet.lives <= 0){
        NSLog(@"your pet died -.- ");
        [self updateAchievements:PET_DEATHS forValue:1];
    }else if ([lastMissed.message isEqualToString:WISH_HUNGRY]){
        int rand = (int)arc4random_uniform((uint32_t)[self.foodList count]);
        Food *randFood = [self.foodList objectAtIndex:rand];
        self.pet.currentWish = randFood.name;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"petHungry" object:self.pet];
    }else if ([lastMissed.message isEqualToString:WISH_THIRSTY]){
        int rand = (int)arc4random_uniform((uint32_t)[self.drinkList count]);
        Food *randFood = [self.drinkList objectAtIndex:rand];
        self.pet.currentWish = randFood.name;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"petHungry" object:self.pet];
    }
    
    //create new notis
    self.notificationRequests = [NotificationCreater createNotifications:self.notificationRequests];
    
    [Saver saveChangeOn:PET withValue:self.pet atSaveSlot:self.saveSlot];
    [Saver saveNotificationSchedules:self.notificationRequests toSlot:self.saveSlot];
    
    
    //Achivement stuff
    NSMutableArray* loadedGlobal = [Loader loadGlobalAchievements];
    NSMutableArray* loadedLocal = [Loader loadLocalAchievements:self.saveSlot];
    int i = 0;
    
    for (Achievement* emptyAchv in self.globalAchievements) {
        Achievement *fillingAchv = [loadedGlobal objectAtIndex:i];
        if([emptyAchv.title isEqualToString:fillingAchv.title]) {
            if([emptyAchv.affectionKey isEqualToString:PET_DEATHS]) {
                emptyAchv.progress = fillingAchv.progress;
                if(emptyAchv.progress >= emptyAchv.goal) {
                    emptyAchv.progress = emptyAchv.goal;
                    emptyAchv.isAchieved = YES;
                }
            }
            else [emptyAchv bookProgress:fillingAchv.progress];
        }
        i++;
    }
    i = 0;
    for (Achievement* emptyAchv in self.localAchievements) {
        Achievement *fillingAchv = [loadedLocal objectAtIndex:i];
        if([emptyAchv.title isEqualToString:fillingAchv.title]) {
            [emptyAchv bookProgress:fillingAchv.progress];
        }
        i++;
    }
    
    [Saver completeSave:self];
    
    if (self.myTimer == nil) {
        [self startTimer];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    //self.navigationItem.title = @"Return to menu";
    //self.navigationItem.backBarButtonItem.action = @selector(returnToMenu:);
    [self.localAchievements removeObjectsInArray:self.globalAchievements];
    
    self.lvlLabel.text = [[NSNumber numberWithInteger:self.pet.lvl] stringValue];
    
    if(self.pet.exp >= EXP_CAP_FOR_LVL*self.pet.lvl) {
        self.pet.exp -= EXP_CAP_FOR_LVL*self.pet.lvl;
        self.pet.lvl++;
        self.lvlLabel.text = [[NSNumber numberWithInteger:self.pet.lvl] stringValue];
    }
    float progress;
    if(self.pet.lvl < MAX_LEVEL) progress = (float) self.pet.exp/(float)(EXP_CAP_FOR_LVL*self.pet.lvl);
    else progress = 1.0f;
    self.expBar.progress = progress;
    
    [self updateAchievements:OWNER_MONEY forValue:self.owner.money];
    
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedAction:(UIButton *)sender {
    [self feed:self.pet.currentWish];
}

- (void)feed:(NSString*)food {
    
    if(food == nil){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"I am not Hungry"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];

    }else if([[self.storage objectForKey:food] intValue] > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PetFeed" object:self.pet];
        [self.myTimer invalidate];
        self.myTimer = nil;
        self.petState = @"happy";
        [self startTimer];
        
        if (self.pet.lives < 3) {
            self.pet.lives++;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PetHealth" object:self.pet];
        }
        
        NotificationRequest *noti = [self.notificationRequests firstObject];
        if([noti.message isEqualToString:WISH_TOO_LATE]){
            [self removeTooLateNotiFromPushNoti:noti.timestamp];
            [self.notificationRequests removeObject:noti];
        }
        
        //Remove 1 food item
        NSInteger quantity = [[self.storage objectForKey:food] integerValue];
        quantity = quantity - 1;
        NSNumber *number = [NSNumber numberWithInteger:quantity];
        [self.storage setValue:number forKey:food];
        self.pet.currentWish = NULL;
        if(self.pet.lvl < MAX_LEVEL) {
            [self addExp:[self expFor:food]];
        }
        
        [Saver saveChangeOn:PET withValue:self.pet atSaveSlot:self.saveSlot];
        [Saver saveChangeOn:STORAGE withValue:self.storage atSaveSlot:self.saveSlot];
    }
    else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Insufficient supplies"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)addExp:(NSInteger)exp {
    self.pet.exp += exp;
    if(self.pet.lvl < MAX_LEVEL) {
        [self updateExp];
    }
}

-(void)updateAchievements:(NSString *)withKey forValue:(NSInteger)value {
    BOOL localChanged = NO, globalChanged = NO;
    for (Achievement* achievement in self.globalAchievements) {
        if(![achievement isAchieved] && [achievement isAffected:withKey]) {
            globalChanged = [achievement bookProgress:value];
            if(achievement.isAchieved) {
                NSString *msg = achievement.achievementDescription;
                [msg stringByAppendingFormat:@"\nReward: %@", achievement.rewardDescription];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Achievement unlocked"
                                                                               message:msg
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          achievement.rewardMethod(self.owner, self.pet,
                                                                                                   self.storage);
                                                                          [self updateExp];}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        }
    }
    for (Achievement* achievement in self.localAchievements) {
        if(![achievement isAchieved] && [achievement isAffected:withKey]) {
            localChanged = [achievement bookProgress:value];
            if(achievement.isAchieved) {
                NSString *msg = achievement.achievementDescription;
                [msg stringByAppendingFormat:@"\nReward: %@", achievement.rewardDescription];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Achievement unlocked"
                                                                               message:msg
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {
                                                                          achievement.rewardMethod(self.owner, self.pet,
                                                                                                   self.storage);
                                                                          [self updateExp];}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    if(localChanged)
        [Saver saveChangeOn:LOCAL_ACHIEVEMENTS withValue:self.localAchievements atSaveSlot:self.saveSlot];
    if(globalChanged)
        [Saver saveChangeOn:GLOBAL_ACHIEVEMENTS withValue:self.globalAchievements atSaveSlot:self.saveSlot];
    
}

- (void) removeTooLateNotiFromPushNoti:(NSDate *)date{
    UIApplication *app = [UIApplication sharedApplication];
    for (UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([noti.fireDate isEqual:date]){
            NSLog(@"removed Local PushNotification");
            [app cancelLocalNotification:noti];
        }
    }
    
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

- (void)gameOver:(id)sender {
    [self performSegueWithIdentifier:@"GameToOver" sender:sender];
}

- (void)returnToMenu:(id)sender {
    [self performSegueWithIdentifier:@"showMenu" sender:sender];
}

- (void)updateExp {
    if(self.pet.exp >= EXP_CAP_FOR_LVL*self.pet.lvl) {
        self.pet.exp -= EXP_CAP_FOR_LVL*self.pet.lvl;
        self.pet.lvl++;
        self.lvlLabel.text = [[NSNumber numberWithInteger:self.pet.lvl] stringValue];
        [self setupFoodList];
        [self setupDrinkList];
        [self setupStoreFood];
        [self updateAchievements:[PET_LEVEL stringByAppendingString:self.pet.type] forValue:self.pet.lvl];
    }
    [Saver saveChangeOn:PET withValue:self.pet atSaveSlot:self.saveSlot];
    
    float progress;
    if(self.pet.lvl < MAX_LEVEL)
        progress = (float) self.pet.exp/(float)(EXP_CAP_FOR_LVL*self.pet.lvl);
    else
        progress = 1.0f;
    [self.expBar setProgress:progress animated:YES];
}

- (void)updateHealth {
    if (self.pet.lives <= 0) {
        self.pet.lives = 0;
        [self gameOver:self];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString: @"showStore"]) {
        [self.myTimer invalidate];
        self.myTimer = nil;
        self.storeViewController = (StoreViewController *) [segue destinationViewController];
        StoreViewController *storeViewController = self.storeViewController;
        storeViewController.storage = self.storage;
        storeViewController.owner = self.owner;
        storeViewController.pet = self.pet;
        storeViewController.foodList = self.storeFood;
        storeViewController.saveSlot = self.saveSlot;
    } else if ([segueName isEqualToString:@"showMoneyFarm"]) {
        [self.myTimer invalidate];
        self.myTimer = nil;
        self.moneyFarmViewController = (MoneyFarmViewController *) [segue destinationViewController];
        MoneyFarmViewController *moneyFarmViewController = self.moneyFarmViewController;
        moneyFarmViewController.saveSlot = self.saveSlot;
        moneyFarmViewController.pet = self.pet;
        moneyFarmViewController.owner = self.owner;
        if (moneyFarmViewController.myTimer == nil) {
           [moneyFarmViewController startTimer];
        }
    } else if ([segueName isEqualToString:@"showStatus"]) {
        [self.myTimer invalidate];
        self.myTimer = nil;
        self.statusViewController = [segue destinationViewController];
        StatusViewController *statusViewController= self.statusViewController;
        statusViewController.owner = self.owner;
        statusViewController.pet = self.pet;
        statusViewController.storage = self.storage;
        statusViewController.foodList = self.storeFood;
    } else if([segueName isEqualToString:@"showTestmode"]){
        [self.myTimer invalidate];
        self.myTimer = nil;
        self.testmodeViewController =[segue destinationViewController];
        TestmodeViewController *testmodeViewController = self.testmodeViewController;
        testmodeViewController.foodList = self.foodList;
        testmodeViewController.drinkList = self.drinkList;
        testmodeViewController.pet = self.pet;
        testmodeViewController.notificationRequests = self.notificationRequests;
        testmodeViewController.gameController = self;
    } else if ([segueName isEqualToString:@"GameToOver"]) {
        GameOverController *gameOverController = [segue destinationViewController];
        gameOverController.pet = self.pet;
    }
    else if ([segueName isEqualToString:@"showAchievements"]){
        AchievementViewController *controller = (AchievementViewController*) [segue destinationViewController];
        controller.showLocal = YES;
        controller.localAchievements = self.localAchievements;
        controller.globalAchievements = self.globalAchievements;
    }  else if ([segueName isEqualToString:@"showMoneyFarm"]) {
        [self.myTimer invalidate];
        self.myTimer = nil;
        [Saver completeSave:self];
    }
    else if ([segueName isEqualToString:@"showMenu"]) {
        [self.myTimer invalidate];
        self.myTimer = nil;
        [Saver completeSave:self];
    }
}

- (IBAction)enterMoneyFarm:(UIButton *)sender {
    
}

- (IBAction)enterShop:(UIButton *)sender {
    
}

- (void)startTimer {
    self.currentFrame = 0;
    if ([self.petState isEqualToString:@"calm"]) {
        self.currentFrames = self.calmAnimation;
        self.speechView.hidden = YES;
    } else if ([self.petState isEqualToString:@"hungry"]) {
        self.currentFrames = self.hungryAnimation;
        self.speechView.hidden = NO;
        self.speechFood.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.pet.currentWish]];
    } else if ([self.petState isEqualToString:@"happy"]) {
        self.currentFrames = self.happyAnimation;
        self.speechView.hidden = YES;
    }
    self.petImageView.image = [self.currentFrames objectAtIndex:self.currentFrame];
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector: @selector(callAfterFrame:) userInfo: nil repeats: YES];
}

- (void)callAfterFrame:(NSTimer *)timer {
    if (self.currentFrame == 0) {
        self.currentFrame = 1;
    } else {
        self.currentFrame = 0;
    }
    self.petImageView.image = [self.currentFrames objectAtIndex:self.currentFrame];
    if ([self.petState isEqualToString:@"happy"]) {
        if (self.currentFrame == 0) {
            self.petState = @"calm";
            [self.myTimer invalidate];
            self.myTimer = nil;
            [self startTimer];
        }
    }
}

- (void)handleAnimation {
    [self startTimer];
}

- (void)handleHunger {
    if (self.pet.currentWish != NULL) {
        self.petState = @"hungry";
        if (self.myTimer != nil) {
            [self.myTimer invalidate];
            self.myTimer = nil;
        }
        [self startTimer];
    }
}

- (void) setupFoodList {
    Food *apple = [[Food alloc] init];
    apple.name = FOOD_APPLE;
    apple.cost = 5;
    apple.expReward = 1;
    Food *bread = [[Food alloc] init];
    bread.name = FOOD_BREAD;
    bread.cost = 3;
    bread.expReward = 1;
    Food *candy = [[Food alloc] init];
    candy.name = FOOD_CANDY;
    candy.cost = 2;
    candy.expReward = 1;
    Food *burger = [[Food alloc] init];
    burger.name = FOOD_BURGER;
    burger.cost = 6;
    burger.expReward = 3;
    if(self.pet.lvl >= 3) {
         self.foodList = [[NSArray alloc] initWithObjects:apple, bread, candy, burger, nil];
    }
    else if(self.pet.lvl >= 2) {
        self.foodList = [[NSArray alloc] initWithObjects:apple, bread, candy, nil];
    }
    else {
        self.foodList = [[NSArray alloc] initWithObjects:apple, bread, nil];
    }
}

- (void) setupDrinkList {
    Food *soda = [[Food alloc] init];
    soda.name = FOOD_SODA;
    soda.cost = 5;
    soda.expReward = 1;
    Food *water =[[Food alloc] init];
    water.name = FOOD_WATER;
    water.cost = 2;
    water.expReward = 1;
    Food *beer = [[Food alloc] init];
    beer.name = FOOD_BEER;
    beer.cost = 4;
    beer.expReward = 2;
    Food *wine = [[Food alloc] init];
    wine.name = FOOD_WINE;
    wine.cost = 7;
    wine.expReward = 3;
    Food *milk = [[Food alloc] init];
    milk.name = FOOD_MILK;
    milk.cost = 3;
    milk.expReward = 2;
    if(self.pet.lvl >= 3) {
        self.drinkList = [[NSArray alloc] initWithObjects:soda, water, wine, beer, milk, nil];
    }
    else if(self.pet.lvl >= 2) {
        self.drinkList = [[NSArray alloc] initWithObjects:soda, water, milk, nil];
    }
    else {
        self.drinkList = [[NSArray alloc] initWithObjects:water, milk, nil];
    }
}

- (void) setupStoreFood {
    self.storeFood = [NSMutableArray arrayWithArray:self.foodList];
    [self.storeFood addObjectsFromArray:self.drinkList];
}

-(NSInteger)expFor:(NSString *)food {
    if([food isEqualToString:FOOD_SODA]) {
        return 1;
    }
    else if([food isEqualToString:FOOD_WATER]) {
        return 1;
    }
    else if([food isEqualToString:FOOD_BEER]) {
        return 2;
    }
    else if([food isEqualToString:FOOD_WINE]) {
        return 3;
    }
    else if([food isEqualToString:FOOD_APPLE]) {
        return 1;
    }
    else if([food isEqualToString:FOOD_BREAD]) {
        return 1;
    }
    else if([food isEqualToString:FOOD_BURGER]) {
        return 3;
    }
    else if([food isEqualToString:FOOD_CANDY]) {
        return 1;
    }
    else return 0;
}

@end