//
//  StatusViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 27.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Owner.h"
#import "Pet.h"
#import "Constants.h"

@interface StatusViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *recipes;
    
}

@property (strong, nonatomic) UIBarButtonItem *gameOverButton;
@property (weak, nonatomic) Owner *owner;
@property (weak, nonatomic) NSMutableDictionary *storage;
@property (weak, nonatomic) Pet *pet;
@property (weak, nonatomic) NSMutableArray *foodList;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UITableView *storageList;
@property (weak, nonatomic) IBOutlet UILabel *petType;
@property (weak, nonatomic) IBOutlet UILabel *petLives;
@property (strong, nonatomic) IBOutlet UIImageView *firstHealthLabel;
@property (strong, nonatomic) IBOutlet UIImageView *secondHealthLabel;
@property (strong, nonatomic) IBOutlet UIImageView *thirdHealthLabel;
@property (strong, nonatomic) IBOutlet UILabel *petLvl;
@property (strong, nonatomic) IBOutlet UILabel *petExp;
@property (strong, nonatomic) IBOutlet UILabel *neededExp;


- (void)gameOver:(id)sender;

@end
