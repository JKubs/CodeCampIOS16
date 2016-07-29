//
//  MoneyFarmViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#include <stdlib.h>

#import "MoneyFarmViewController.h"
#import  "Saver.h"
#import "GameOverController.h"

@implementation MoneyFarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHealth) name:@"PetHealth" object:nil];
    self.gameOverButton = [[UIBarButtonItem alloc] initWithTitle:@"Button"
                                                           style:UIBarButtonItemStyleDone
                                                          target:self
                                                          action:@selector(gameOver:)];
    self.navigationItem.rightBarButtonItems = @[_gameOverButton];
    self.navigationItem.hidesBackButton = YES;
    self.moneyLabel.text = [NSString stringWithFormat:@"Money: %d$", self.owner.money];
    self.testCoin.hidden = YES;
    self.testCoin.enabled = NO;
    [UIView animateWithDuration:0.4 animations:^{self.buttonHeight.constant=66;}];
    [UIView animateWithDuration:0.4 animations:^{self.buttonWidth.constant=53;}];
    if (self.myTimer == nil) {
        [self startTimer];
    }
}

- (void)startTimer {
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self
                                                  selector: @selector(callAfterFiveSeconds:) userInfo: nil repeats: YES];
}

- (void)startSuccessfullTimer {
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self
                                                  selector: @selector(callAfterTwoSeconds:) userInfo: nil repeats: NO];
}

- (void)startUnSuccessfullTimer {
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self
                                                  selector: @selector(callAfterTwoSecondsUnSuccessfull:) userInfo: nil repeats: NO];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString:@"GameToOver"]) {
        GameOverController *gameOverController = [segue destinationViewController];
        gameOverController.pet = self.pet;
    }
}

- (void)gameOver:(id)sender {
    [self performSegueWithIdentifier:@"MoneyToOver" sender:sender];
}

- (void)updateHealth {
    if (self.pet.lives == 0) {
        [self gameOver:self];
    }
}

- (IBAction)clickCoin:(UIButton *)sender {
    if (self.myTimer != nil) {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
    self.testCoin.hidden = YES;
    self.testCoin.enabled = NO;
    self.owner.money += 1;
    [Saver saveChangeOn:OWNER withValue:self.owner atSaveSlot:self.saveSlot];
    self.moneyLabel.text = [NSString stringWithFormat:@"Money: %d$", self.owner.money];
    [self startSuccessfullTimer];
}

- (IBAction)closeMoneyFarm:(UIButton *)sender {
    if (self.myTimer != nil) {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PetAnimation" object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)callAfterFiveSeconds:(NSTimer *)timer {
    NSInteger randX = ((int) arc4random_uniform(241))-140;
    NSInteger randY = ((int) arc4random_uniform(241))-140;
    [UIView animateWithDuration:0.4 animations:^{self.centerX.constant=randX;}];
    [UIView animateWithDuration:0.4 animations:^{self.centerY.constant=randY;}];
    self.testCoin.hidden = NO;
    self.testCoin.enabled = YES;
}

- (void)callAfterTwoSeconds:(NSTimer *)timer {
    NSInteger randX = ((int) arc4random_uniform(241))-140;
    NSInteger randY = ((int) arc4random_uniform(241))-140;
    [UIView animateWithDuration:0.4 animations:^{self.centerX.constant=randX;}];
    [UIView animateWithDuration:0.4 animations:^{self.centerY.constant=randY;}];
    self.testCoin.hidden = NO;
    self.testCoin.enabled = YES;
    [self.myTimer invalidate];
    self.myTimer = nil;
    [self startUnSuccessfullTimer];
}

- (void)callAfterTwoSecondsUnSuccessfull:(NSTimer *)timer {
    self.testCoin.hidden = YES;
    self.testCoin.enabled = NO;
    [self.myTimer invalidate];
    self.myTimer = nil;
    [self startTimer];
}

@end
