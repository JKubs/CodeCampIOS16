//
//  StoreViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "StoreViewController.h"
#import "Food.h"

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    row = -1;
    recipes = self.foodList;
    self.testLabel.text = self.owner.name;
    //recipes = [NSArray arrayWithObjects:@"1", @"2", nil];
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
    
    cell.textLabel.text = [recipes objectAtIndex:indexPath.row];
    return cell;
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
            self.testLabel.text = food.name;
        } else {
            self.testLabel.text = @"Not enough money.";
        }
        
    }
}

@end
