//
//  NewGameViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 28.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "Owner.h"
#import "Pet.h"
#import "Loader.h"
#import "Saver.h"

@interface NewGameViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSArray *recipes;
    NSInteger row;
}

@property (strong, nonatomic) GameViewController *gameViewController;
@property (strong, nonatomic) Owner *owner;
@property (strong, nonatomic) Pet *pet;
@property (strong, nonatomic) NSString *saveSlot;
@property (strong, nonatomic) NSMutableDictionary *storage;
@property (strong, nonatomic) NSMutableArray *globalAchievements;
@property (strong, nonatomic) NSMutableArray *localAchievements;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;

- (IBAction)edited:(UITextField *)sender;

@end

