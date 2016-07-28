//
//  StatusViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 27.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "StatusViewController.h"
#import "Food.h"

@implementation StatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    recipes = self.foodList;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.usernameLabel.text = [NSString stringWithFormat:@"Name: %@", self.owner.name];
    self.moneyLabel.text = [NSString stringWithFormat:@"Money: %d$", self.owner.money];
    self.petType.text = [NSString stringWithFormat:@"Type: %@", self.pet.type];
    [self updateHealth];
    self.storageList.layer.borderWidth = 1.0f;
    self.storageList.layer.borderColor = [UIColor blueColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFeed) name:@"PetFeed" object:self.pet];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHealth) name:@"PetHealth" object:self.pet];
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
    cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:@" | quantity: %d", [[self.storage valueForKey:food.name] integerValue]];
    return cell;
}

- (void)handleFeed {
    [self.storageList reloadData];
}

- (void)updateHealth {
    NSInteger health = self.pet.lives;
    if (health >= 1) {
        self.firstHealthLabel.backgroundColor = [UIColor redColor];
    } else {
        self.firstHealthLabel.backgroundColor = [UIColor whiteColor];
    }
    if (health >= 2) {
        self.secondHealthLabel.backgroundColor = [UIColor redColor];
    } else {
        self.secondHealthLabel.backgroundColor = [UIColor whiteColor];
    }
    if (health >= 3) {
        self.thirdHealthLabel.backgroundColor = [UIColor redColor];
    } else {
        self.thirdHealthLabel.backgroundColor = [UIColor whiteColor];
    }
}

@end
