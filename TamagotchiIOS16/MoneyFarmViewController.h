//
//  MoneyFarmViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Owner.h"
#import "Pet.h"

@interface MoneyFarmViewController : UIViewController

@property (strong, nonatomic) UIBarButtonItem *gameOverButton;
@property (weak, nonatomic) Owner *owner;
@property (weak, nonatomic) Pet *pet;
@property (weak, nonatomic) NSTimer *myTimer;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *testCoin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) NSString *saveSlot;

- (void)startTimer;
- (void)gameOver:(id)sender;

@end
