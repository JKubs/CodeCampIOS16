//
//  StatusViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 27.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "StatusViewController.h"
#import "Food.h"
#import "GameOverController.h"

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameOverButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                           style:UIBarButtonItemStyleDone
                                                          target:self
                                                          action:@selector(gameOver:)];
    self.navigationItem.rightBarButtonItem = self.gameOverButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    recipes = self.foodList;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.usernameLabel.text = [NSString stringWithFormat:@"Name: %@", self.owner.name];
    self.moneyLabel.text = [NSString stringWithFormat:@"Money: %ld$", (long)self.owner.money];
    self.petType.text = [NSString stringWithFormat:@"Type: %@", self.pet.type];
    self.petExp.text = [[NSNumber numberWithInteger:self.pet.exp] stringValue];
    self.petLvl.text = [[NSNumber numberWithInteger:self.pet.lvl] stringValue];
    if(self.pet.lvl == MAX_LEVEL) self.neededExp.text = @"-";
    else self.neededExp.text = [[NSNumber numberWithInteger:self.pet.lvl*EXP_CAP_FOR_LVL-self.pet.exp] stringValue];
    [self updateHealth];
    self.storageList.layer.borderWidth = 1.0f;
    self.storageList.layer.borderColor = [UIColor blueColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFeed) name:@"PetFeed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHealth) name:@"PetHealth" object:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [recipes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"StorageTable";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Food *food = (Food *) [recipes objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", food.name]];
    cell.textLabel.text = food.name;
    cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:@" | quantity: %ld", [[self.storage valueForKey:food.name] integerValue]];
    return cell;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PetAnimation" object:self];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString:@"GameToOver"]) {
        GameOverController *gameOverController = [segue destinationViewController];
        gameOverController.pet = self.pet;
    }
}

- (void)gameOver:(id)sender {
    [self performSegueWithIdentifier:@"StatusToOver" sender:sender];
}

- (void)handleFeed {
    [self.storageList reloadData];
}

- (void)updateHealth {
    NSInteger health = self.pet.lives;
    if (health < 3) {
        self.thirdHealthLabel.hidden = YES;
    }
    if (health < 2) {
        self.secondHealthLabel.hidden = YES;
    }
    if (health < 1) {
        self.firstHealthLabel.hidden = YES;
    }
    if (health == 0) {
        [self gameOver:self];
    }
}

@end
