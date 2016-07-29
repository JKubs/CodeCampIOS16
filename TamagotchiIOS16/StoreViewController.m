//
//  StoreViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "StoreViewController.h"
#import "Food.h"
#import "Saver.h"
#import "GameOverController.h"

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gameOverButton = [[UIBarButtonItem alloc] initWithTitle:@"Button"
                                                           style:UIBarButtonItemStyleDone
                                                          target:self
                                                          action:@selector(gameOver:)];
    self.navigationItem.rightBarButtonItems = @[_gameOverButton];
    self.navigationItem.hidesBackButton = YES;
    row = -1;
    recipes = self.foodList;
    self.greetingLabel.text = [NSString stringWithFormat:@"Hello, %@", self.owner.name];
    self.testLabel.text = [NSString stringWithFormat:@"Your Balance: %d$", self.owner.money];
    self.tableView.layer.borderWidth = 1.0f;
    self.tableView.layer.borderColor = [UIColor blueColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFeed) name:@"PetFeed" object:self.pet];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [recipes count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    row = indexPath.row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTable";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Food *food = (Food *) [recipes objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", food.name]];
    cell.textLabel.text = food.name;
    cell.
    textLabel.text = [cell.textLabel.text stringByAppendingFormat:@":%d$ | quantity: %d", food.cost, [[self.storage valueForKey:food.name] integerValue]];
    return cell;
}

- (void)handleFeed {
    [self.tableView reloadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString:@"StoreToOver"]) {
        GameOverController *gameOverController = [segue destinationViewController];
        gameOverController.pet = self.pet;
    }
}

- (void)gameOver:(id)sender {
    [self performSegueWithIdentifier:@"StoreToOver" sender:sender];
}

- (void)updateHealth {
    if (self.pet.lives == 0) {
        [self gameOver:self];
    }
}

- (IBAction)closeStore:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PetAnimation" object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)handleBuy:(UIButton *)sender {
    if (row != -1) {
        Food *food = [recipes objectAtIndex:row];
        NSInteger currentMoney = self.owner.money;
        if (food.cost <= currentMoney) {
            self.owner.money = currentMoney - food.cost;
            NSInteger quantity = [[self.storage objectForKey:food.name] integerValue];
            quantity = quantity + 1;
            NSNumber *number = [NSNumber numberWithInteger:quantity];
            [self.storage setValue:number forKey:food.name];
            [Saver saveChangeOn:STORAGE withValue:self.storage atSaveSlot:self.saveSlot];
            [Saver saveChangeOn:OWNER withValue:self.owner atSaveSlot:self.saveSlot];
            self.testLabel.text = [NSString stringWithFormat:@"Your Balance: %d$", self.owner.money];
            [self.tableView reloadData];
        }
    }
}

@end
