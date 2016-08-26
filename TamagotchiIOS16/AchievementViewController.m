//
//  AchievementViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 16.08.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "AchievementViewController.h"

@interface AchievementViewController()

@end

@implementation AchievementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.showLocal) {
        self.recipes = self.localAchievements;
        [self.recipes addObjectsFromArray:self.globalAchievements];
        self.deleteButton.hidden = YES;
    }
    else {
        self.recipes = self.globalAchievements;
    }

    self.achievementTable.layer.borderWidth = 1.0f;
    //self.achievementTable.layer.borderColor = [UIColor blueColor].CGColor;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recipes count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Achievement *achievement = [self.recipes objectAtIndex:indexPath.row];
    NSString *msg = [achievement.achievementDescription stringByAppendingFormat:@"\nProgress: %ld/%ld\nReward: %@",achievement.progress, achievement.goal, achievement.rewardDescription];
    UIAlertController* detailView = [UIAlertController alertControllerWithTitle:achievement.title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    
    [detailView addAction:action];
    [self presentViewController:detailView animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    Achievement *achievement = (Achievement *) [self.recipes objectAtIndex:indexPath.row];
    //cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", food.name]];
    //NSString *label = achievement.title;
    //label = [label stringByAppendingFormat:@"\n%@: %ld/%ld\nReward: %@",achievement.achievementDescription, achievement.progress,achievement.goal,achievement.rewardDescription];
    //cell.textLabel.text = label;
    cell.imageView.image = [UIImage imageNamed:achievement.achievementImage];
    cell.textLabel.text = achievement.title;
    cell.detailTextLabel.text = @"Select for details";
    cell.backgroundColor = (achievement.isAchieved ? [UIColor yellowColor] : [UIColor lightGrayColor]);
    
    return cell;
}

- (IBAction)deleteProgress:(UIButton *)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Deletion"
                                                                   message:@"Are you sure? All account achievements' progress will be deleted"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             for (Achievement* achievement in self.globalAchievements) {
                                                                 achievement.progress = 0;
                                                                 achievement.isAchieved = NO;
                                                             }
                                                             [ Saver saveChangeOn:GLOBAL_ACHIEVEMENTS withValue:self.globalAchievements atSaveSlot:nil];
                                                             [Saver removeFlag:HORRIBLE_SHAME];
                                                             [self.achievementTable reloadData];
                                                         }];
    
    [alert addAction:deleteAction];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


@end