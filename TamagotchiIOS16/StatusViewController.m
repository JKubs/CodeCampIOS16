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
    self.petLives.text = [NSString stringWithFormat:@"Lives: %d", self.pet.lives];
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

@end
