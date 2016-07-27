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
    self.image1 = [UIImage imageNamed:@"critter1.jpg"];
    self.image2 = [UIImage imageNamed:@"critter2.jpg"];
    self.petImageView.image = self.image1;
    self.currentImage = 0;
    self.storage = [self createStorage];
    //self.storage = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:4],SODA, nil];
    self.owner = [[Owner alloc] init];
    self.owner.money = 100;
    self.owner.name = @"Bob";
    self.pet = [[Pet alloc] init];
    NSArray *foodList = [self createFoodList];
    NSArray *drinkList = [self createDrinkList];
    NSMutableArray *storeFood = [NSMutableArray arrayWithArray:foodList];
    [storeFood addObjectsFromArray:drinkList];
    self.foodList = foodList;
    self.drinkList = drinkList;
    self.storeFood = storeFood;
    
}

- (NSMutableDictionary *) createStorage {
    NSMutableDictionary *storage = [[NSMutableDictionary alloc] init];
    [storage setObject:[NSNumber numberWithInteger:0] forKey:@"apple"];
    [storage setObject:[NSNumber numberWithInteger:1] forKey:@"soda"];
    return storage;
}

- (NSArray *) createFoodList {
    Apple *apple = [[Apple alloc] init];
    apple.name = @"apple";
    apple.cost = 5;
    NSArray *foodList = [[NSArray alloc] initWithObjects:apple, nil];
    return foodList;
}

- (NSArray *) createDrinkList {
    Soda *soda = [[Soda alloc] init];
    soda.name = @"soda";
    soda.cost = 5;
    NSArray *drinkList = [[NSArray alloc] initWithObjects:soda, nil];
    return drinkList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)feedAction:(UIButton *)sender {
    [self feed:self.currentWish];
}

- (void)feed:(Food *)food {
    if([[self.storage objectForKey:food.name] intValue] > 0) {
        
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString: @"showStore"]) {
        self.storeViewController = (StoreViewController *) [segue destinationViewController];
        StoreViewController *storeViewController = self.storeViewController;
        storeViewController.storage = self.storage;
        storeViewController.owner = self.owner;
        storeViewController.foodList = self.storeFood;
    } else if ([segueName isEqualToString:@"showMoneyFarm"]) {
        self.moneyFarmViewController = (MoneyFarmViewController *) [segue destinationViewController];
        MoneyFarmViewController *moneyFarmViewController = self.moneyFarmViewController;
        moneyFarmViewController.owner = self.owner;
        //if (moneyFarmViewController.myTimer == nil) {
        //   [moneyFarmViewController startTimer];
        //}
    }
}

- (IBAction)enterMoneyFarm:(UIButton *)sender {
    
}

- (IBAction)enterShop:(UIButton *)sender {
    
}

//TODO just a joke. can be erased in final version
- (IBAction)killThatMonster:(UIButton *)sender {
    self.petImageView.image = [UIImage imageNamed:@"verrecke_dummes_vieh.jpg"];
}

- (void)animate {
    if(self.currentImage == 0) {
        self.petImageView.image = self.image2;
    }
    else self.petImageView.image = self.image1;
    self.currentImage = 1 - self.currentImage;
}

@end