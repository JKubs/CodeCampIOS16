//
//  UIViewController_StoreViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Owner.h"
#import "Pet.h"

@interface StoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *recipes;
    NSInteger row;
}

@property (strong, nonatomic) UIBarButtonItem *gameOverButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) NSMutableDictionary *storage;
@property (weak, nonatomic) NSMutableArray *foodList;
@property (weak, nonatomic) Owner *owner;
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) Pet *pet;
@property (weak, nonatomic) NSString *saveSlot;

- (void)gameOver:(id)sender;

@end