//
//  MoneyFarmViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Owner.h"

@interface MoneyFarmViewController : UIViewController

@property (weak, nonatomic) Owner *owner;
@property (weak, nonatomic) NSTimer *myTimer;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *testCoin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidth;
@property (weak, nonatomic) NSString *saveSlot;

- (void)startTimer;

@end
