//
//  MenuViewController.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 27.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "LoadGameViewController.h"
#import "AchievementViewController.h"
#import "Owner.h"
#import "Pet.h"
#import "Loader.h"
#import "Saver.h"

@interface MenuViewController : UIViewController {
    
}
@property (nonatomic) int currentFrame;
@property (strong, nonatomic) NSMutableArray *globalAchievements;
@property (strong, nonatomic) NSMutableArray *localAchievements;
@property (strong, nonatomic) IBOutlet UIButton *continueButton;
@property (strong, nonatomic) IBOutlet UIImageView *leftPetImage;
@property (strong, nonatomic) IBOutlet UIImageView *rightPetImage;
@property (strong, nonatomic) NSTimer *timer;

- (BOOL)isClearStart;
- (void)nextFrame:(NSTimer*)timer;
-(NSMutableArray*)createLocalAchievementsForSlot:(NSString*)slot;
-(NSMutableArray*)createGlobalAchievements;
-(void)updateAchievementProgress;
@end