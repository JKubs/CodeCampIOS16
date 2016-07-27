//
//  MoneyFarmViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "MoneyFarmViewController.h"

@implementation MoneyFarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.moneyLabel.text = [NSString stringWithFormat:@"Money: %d$", self.owner.money];
    //self.testCoin.enabled = NO;
    //self.testCoin.imageView.hidden = YES;
    //if (self.myTimer == nil) {
    //    [self startTimer];
    //}
}

- (void)startTimer {
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval: 60.0 target: self
                                                  selector: @selector(callAfterFiveSeconds:) userInfo: nil repeats: YES];
}

- (IBAction)clickCoin:(UIButton *)sender {
    //if (self.myTimer != nil) {
    //    [self.myTimer invalidate];
    //    self.myTimer = nil;
    //}
    //self.testCoin.imageView.hidden = YES;
    //self.testCoin.enabled = NO;
    //[self startTimer];
}

- (IBAction)closeMoneyFarm:(UIButton *)sender {
    //if (self.myTimer != nil) {
    //    [self.myTimer invalidate];
    //    self.myTimer = nil;
    //}
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)callAfterFiveSeconds:(NSTimer *)timer {
    //self.testCoin.imageView.hidden = NO;
    //self.testCoin.enabled = YES;
}

@end
