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
#import "Storage.h"
#import "Store.h"
#import "StoreViewController.h"
#import "MoneyFarmViewController.h"

@protocol GameViewControllerDelegate <NSObject>
@required
-(void)animationReturned;

@end

@interface GameViewController : UIViewController

@property (strong, nonatomic) id <GameViewControllerDelegate> delegate;
@property (strong, nonatomic) StoreViewController *storeViewController;
@property (strong, nonatomic) MoneyFarmViewController *moneyFarmViewController;
@property (strong, nonatomic) IBOutlet UIImageView *petImageView;
@property (strong, nonatomic) UIImage *image1;
@property (strong, nonatomic) UIImage *image2;
@property (nonatomic) int currentImage;
@property (nonatomic) int saveSlot;
@property (strong, nonatomic) Owner *owner;
@property (strong, nonatomic) NSMutableDictionary *storage;
@property (strong, nonatomic) Pet *pet;
@property (strong, nonatomic) Store *store;
@property (strong, nonatomic) NSArray *foodList;
@property (strong, nonatomic) NSArray *drinkList;
@property (strong, nonatomic) NSMutableArray *storeFood;
@property (strong, nonatomic) Food *currentWish;


- (IBAction)feedAction:(UIButton *)sender;
- (IBAction)enterShop:(UIButton *)sender;
- (IBAction)killThatMonster:(UIButton *)sender;

- (void)feed:(Food*)food;

-(void)animate;

@end

