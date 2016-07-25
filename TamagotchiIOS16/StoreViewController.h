//
//  UIViewController_StoreViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSArray *recipes;
    NSInteger row;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end