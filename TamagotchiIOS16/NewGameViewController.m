//
//  NewGameViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 28.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewGameViewController.h"

@implementation NewGameViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    recipes = [[NSArray alloc] initWithObjects:@"Critter", nil];
    self.startButton.enabled = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [recipes count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    row = indexPath.row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"PetTable";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSString *petType = (NSString *) [recipes objectAtIndex:indexPath.row];
    cell.textLabel.text = petType;
    return cell;
}

- (IBAction)edited:(UITextField *)sender {
    if ([self.userName.text length] != 0) {
        self.startButton.enabled = YES;
    } else {
        self.startButton.enabled = NO;
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString: @"startNewGame"]) {
        [self setupOwner];
        [self setupPet];
        [self setupStorage];
        [self setupFoodList];
        [self setupDrinkList];
        [self setupStoreFood];
        self.gameViewController = (GameViewController *) [segue destinationViewController];
        GameViewController *gameViewController = self.gameViewController;
        gameViewController.owner = self.owner;
        gameViewController.pet = self.pet;
        gameViewController.storage = self.storage;
        gameViewController.foodList = self.foodList;
        gameViewController.drinkList = self.drinkList;
        gameViewController.storeFood = self.storeFood;
    }
}

- (void) setupOwner {
    self.owner = [[Owner alloc] init];
    self.owner.name = self.userName.text;
    self.owner.money = 100;
}

- (void) setupPet {
    self.pet = [[Pet alloc] init];
    self.pet.type = [recipes objectAtIndex:row];
    self.pet.lives = 3;
}

- (void) setupStorage {
    self.storage = [[NSMutableDictionary alloc] init];
    [self.storage setObject:[NSNumber numberWithInteger:0] forKey:@"apple"];
    [self.storage setObject:[NSNumber numberWithInteger:1] forKey:@"soda"];
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