//
//  AchievementViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 16.08.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "Owner.h"
#import "Pet.h"
#import "Loader.h"
#import "Saver.h"
#import "Achievement.h"

@interface AchievementViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
}
@property (strong, nonatomic) IBOutlet UITableView *achievementTable;
@property (strong, nonatomic) NSMutableArray *globalAchievements;
@property (strong, nonatomic) NSMutableArray *localAchievements;
@property (strong, nonatomic)NSMutableArray *recipes;
@property BOOL showLocal;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;

- (IBAction)deleteProgress:(UIButton *)sender;

@end