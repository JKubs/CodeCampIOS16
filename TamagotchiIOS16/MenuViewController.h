//
//  MenuViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 27.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "Owner.h"
#import "Pet.h"

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSArray *recipes;
    NSInteger row;

}

@property (strong, nonatomic) GameViewController *gameViewController;
@property (strong, nonatomic) Owner *owner;
@property (strong, nonatomic) Pet *pet;
@property (strong, nonatomic) NSMutableDictionary *storage;
@property (strong, nonatomic) NSArray *foodList;
@property (strong, nonatomic) NSArray *drinkList;
@property (strong, nonatomic) NSMutableArray *storeFood;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)infoEdited;

@end