//
//  GameViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"
#import "Owner.h"
#import "Pet.h"
#import "StoreViewController.h"
#import "Loader.h"
#import "Saver.h"
#import "MoneyFarmViewController.h"
#import "StatusViewController.h"
#import "TestmodeViewController.h"
#import "NotificationRequest.h"

@class Loader;
@class Saver;
@class TestmodeViewController;

@protocol GameViewControllerDelegate <NSObject>
@required
-(void)animationReturned;

@end

@interface GameViewController : UIViewController

@property (strong, nonatomic) id <GameViewControllerDelegate> delegate;
@property (strong, nonatomic) StoreViewController *storeViewController;
@property (strong, nonatomic) MoneyFarmViewController *moneyFarmViewController;
@property (strong, nonatomic) StatusViewController *statusViewController;
@property (strong, nonatomic) TestmodeViewController *testmodeViewController;
@property (strong, nonatomic) IBOutlet UIImageView *petImageView;
@property (strong, nonatomic) UIImage *image1;
@property (strong, nonatomic) UIImage *image2;
@property (nonatomic) int currentImage;
@property (strong, nonatomic) NSString *saveSlot;
@property (strong, nonatomic) Owner *owner;
@property (strong, nonatomic) NSMutableDictionary *storage;
@property (strong, nonatomic) Pet *pet;
@property (strong, nonatomic) NSArray *foodList;
@property (strong, nonatomic) NSArray *drinkList;
@property (strong, nonatomic) NSMutableArray *storeFood;
@property (strong, nonatomic) Food *currentWish;
@property (strong, nonatomic) NSMutableArray *notificationRequests;


- (void)removeTooLateNotiFromPushNoti:(NSDate *) date;
- (IBAction)feedAction:(UIButton *)sender;
- (IBAction)enterShop:(UIButton *)sender;
- (IBAction)killThatMonster:(UIButton *)sender;

- (void)feed:(NSString*)food;

-(void)animate;

@end

