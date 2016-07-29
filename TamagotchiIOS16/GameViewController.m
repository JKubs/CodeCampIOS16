//
//  GameViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameViewController.h"

@interface GameViewController ()
@end

@implementation GameViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GameStarted" object:self];

    if(self.notificationRequests == nil){
        self.notificationRequests = [[NSMutableArray alloc]init];
    }
    
    //notification stuff

    self.notificationRequests = [NotificationCreater createNotifications:self.notificationRequests];
    
    NSMutableArray *missedNotis = [NotificationCreater deleteMissedNotifications:self.notificationRequests];
    
    NotificationRequest *lastMissed = [missedNotis lastObject];
    
    for (NotificationRequest *notiR in missedNotis) {
        if([notiR.message isEqualToString:WISH_TOO_LATE]){
            self.pet.lives--;
        }
    }
    
    if(self.pet.lives <= 0){
        NSLog(@"your pet died -.- ");
    }else if ([lastMissed.message isEqualToString:WISH_HUNGRY]){
        int rand = (int)arc4random_uniform((uint32_t)[self.foodList count]);
        Food *randFood = [self.foodList objectAtIndex:rand];
        self.pet.currentWish = randFood.name;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"petFeed" object:self.pet];
    }else if ([lastMissed.message isEqualToString:WISH_THIRSTY]){
        int rand = (int)arc4random_uniform((uint32_t)[self.drinkList count]);
        Food *randFood = [self.drinkList objectAtIndex:rand];
        self.pet.currentWish = randFood.name;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"petFeed" object:self.pet];
    }
    [Saver saveChangeOn:PET withValue:self.pet atSaveSlot:self.saveSlot];

    
    if (self.myTimer == nil) {
        [self startTimer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedAction:(UIButton *)sender {
    [self feed:self.pet.currentWish];
}

- (void)feed:(NSString*)food {    
    NSLog(@"%@", food);
    if(food == NULL){
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

- (void) removeTooLateNotiFromPushNoti:(NSDate *)date{
    UIApplication *app = [UIApplication sharedApplication];
    for (UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([noti.fireDate isEqual:date]){
            NSLog(@"removed Local PushNotification");
            [app cancelLocalNotification:noti];
        }
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
    }
}

- (void) setupFoodList {
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
    self.foodList = [[NSArray alloc] initWithObjects:apple, bread, candy, burger, nil];
}

- (void) setupDrinkList {
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
    self.drinkList = [[NSArray alloc] initWithObjects:soda, water, wine, nil];
}

- (void) setupStoreFood {
    self.storeFood = [NSMutableArray arrayWithArray:self.foodList];
    [self.storeFood addObjectsFromArray:self.drinkList];
}

@end