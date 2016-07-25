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

#define FOOD_VARIETY 2
#define SODA 0
#define CANDY 1

@protocol GameViewControllerDelegate <NSObject>
@required
-(void)animationReturned;

@end

@interface GameViewController : UIViewController

@property (strong, nonatomic) id <GameViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *petImageView;
@property (strong, nonatomic) UIImage *image1;
@property (strong, nonatomic) UIImage *image2;
@property (nonatomic) int currentImage;
@property (strong, nonatomic) Owner *owner;
@property (strong, nonatomic) NSMutableArray *storage;
@property (strong, nonatomic) Pet *pet;
@property (strong, nonatomic) Store *store;


- (IBAction)feedAction:(UIButton *)sender;
- (IBAction)hydrateAction:(UIButton *)sender;
- (IBAction)enterShop:(UIButton *)sender;
- (IBAction)killThatMonster:(UIButton *)sender;

-(void)animate;

@end

