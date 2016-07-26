//
//  UIViewController_StoreViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Owner.h"

@interface StoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSMutableArray *recipes;
    NSInteger row;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;
@property (weak, nonatomic) NSMutableDictionary *storage;
@property (weak, nonatomic) NSMutableArray *foodList;
@property (weak, nonatomic) Owner *owner;

@end