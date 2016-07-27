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
    cell.textLabel.text = food.name;
    cell.textLabel.text = [cell.textLabel.text stringByAppendingFormat:@" | quantity: %d", [[self.storage valueForKey:food.name] integerValue]];
    return cell;
}

@end
