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
#import "Constants.h"
#import "MoneyFarmViewController.h"
#import "StatusViewController.h"
#import "AchievementViewController.h"
#import "TestmodeViewController.h"
#import "NotificationRequest.h"
#import "NotificationCreater.h"

@class Loader;
@class Saver;
@class TestmodeViewController;

@protocol GameViewControllerDelegate <NSObject>
@required
-(void)animationReturned;

@end

@interface GameViewController : UIViewController

@property (strong, nonatomic) UIBarButtonItem *gameOverButton;
@property (strong, nonatomic) id <GameViewControllerDelegate> delegate;
@property (strong, nonatomic) StoreViewController *storeViewController;
@property (strong, nonatomic) MoneyFarmViewController *moneyFarmViewController;
@property (strong, nonatomic) StatusViewController *statusViewController;
@property (strong, nonatomic) TestmodeViewController *testmodeViewController;
@property (strong, nonatomic) IBOutlet UIImageView *petImageView;
@property (strong, nonatomic) NSArray *calmAnimation;
@property (strong, nonatomic) NSArray *hungryAnimation;
@property (strong, nonatomic) NSArray *happyAnimation;
@property (strong, nonatomic) NSArray *currentFrames;
@property (strong, nonatomic) NSTimer *myTimer;
@property NSInteger currentFrame;
@property (strong, nonatomic) NSString *petState;
@property (strong, nonatomic) NSString *saveSlot;
@property BOOL slotChanged;
@property (strong, nonatomic) Owner *owner;
@property (strong, nonatomic) NSMutableDictionary *storage;
@property (strong, nonatomic) NSMutableArray *localAchievements;
@property (strong, nonatomic) NSMutableArray *globalAchievements;
@property (strong, nonatomic) Pet *pet;
@property (strong, nonatomic) NSArray *foodList;
@property (strong, nonatomic) NSArray *drinkList;
@property (strong, nonatomic) NSMutableArray *storeFood;
@property (strong, nonatomic) Food *currentWish;
@property (strong, nonatomic) NSMutableArray *notificationRequests;
@property (weak, nonatomic) IBOutlet UIView *speechView;
@property (weak, nonatomic) IBOutlet UIImageView *speechFood;
@property (weak, nonatomic) IBOutlet UIButton *moneyButton;
@property (weak, nonatomic) IBOutlet UIButton *statsButton;
@property (weak, nonatomic) IBOutlet UIButton *feedButton;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
@property (strong, nonatomic) IBOutlet UIProgressView *expBar;
@property (strong, nonatomic) IBOutlet UILabel *lvlLabel;

- (void)gameOver:(id)sender;
- (void)removeTooLateNotiFromPushNoti:(NSDate *) date;
- (IBAction)feedAction:(UIButton *)sender;
- (IBAction)enterShop:(UIButton *)sender;
- (void)feed:(NSString*)food;
- (void)addExp:(NSInteger)exp;
- (void)updateExp;
- (NSInteger)expFor:(NSString*)food;
- (void)updateAchievements:(NSString*)withKey forValue:(NSInteger)value;

@end

