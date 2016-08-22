//
//  MenuViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 27.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController

- (void) viewDidLoad {
    //self.globalAchievements = [Loader loadGlobalAchievements];
    if (self.globalAchievements == nil) self.globalAchievements = [self createGlobalAchievements];
    
    self.leftPetImage.image = [UIImage imageNamed:@"Critter_calm_1.png"];
    self.rightPetImage.image = [UIImage imageNamed:@"Montie_calm_1.png"];
    [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector: @selector(nextFrame:) userInfo: nil repeats: YES];
    //[[UIAccelerometer sharedAccelerometer]setDelegate:self];
}

- (void) nextFrame:(NSTimer*)timer{
    self.currentFrame = (1 - self.currentFrame);
    self.leftPetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Critter_calm_%i.png", self.currentFrame+1]];
    self.rightPetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"Montie_calm_%i.png", self.currentFrame+1]];
}

-(void)viewWillAppear:(BOOL)animated {
    if([self isClearStart]) {
        self.continueButton.enabled = NO;
    }
    else {
        self.continueButton.enabled = YES;
    }
    [super viewWillAppear:animated];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString: @"continueGame"]) {
        NSString *lastUsedSlot = [Loader loadLastUsedSlotString];
        NSDictionary *slot = [Loader loadSlot:lastUsedSlot];
        Owner *owner = [slot objectForKey:OWNER];
        Pet *pet = [slot objectForKey:PET];
        NSMutableDictionary *storage = [slot objectForKey:STORAGE];
        
        GameViewController *gameViewController = (GameViewController *) [segue destinationViewController];
        gameViewController.owner = owner;
        gameViewController.pet = pet;
        gameViewController.storage = storage;
        gameViewController.saveSlot = lastUsedSlot;
        gameViewController.globalAchievements = self.globalAchievements;
        //self.localAchievements = [Loader loadLocalAchievements:lastUsedSlot];
        if (self.localAchievements == nil) self.localAchievements = [self createLocalAchievementsForSlot:lastUsedSlot];
        gameViewController.localAchievements = self.localAchievements;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PetAnimation" object:self];
    }
    else if ([segueName isEqualToString: @"newloadGame"]) {
        LoadGameViewController *controller = (LoadGameViewController *) [segue destinationViewController];
        controller.localAchievements = [self createLocalAchievementsForSlot:nil];
        controller.globalAchievements = self.globalAchievements;
    }
    else if ([segueName isEqualToString: @"achievements"]) {
        //ensure only the global achievements are shown
        AchievementViewController *controller = (AchievementViewController*) [segue destinationViewController];
        controller.globalAchievements = self.globalAchievements;
        controller.showLocal = NO;
    }
}

-(BOOL)isClearStart {
    return [Loader loadLastUsedSlotString] == nil;
}

-(NSMutableArray *)createLocalAchievementsForSlot:(NSString *)slot {
    NSMutableArray *achievements = [[NSMutableArray alloc] init];
    Achievement *a1 = [[Achievement alloc] init];
    a1.title = @"Not so poor";
    a1.achievementDescription = @"Have 20 Money";
    a1.progress = 10;
    a1.rewardDescription = @"+2 XP";
    a1.isAchieved = NO;
    a1.goal = 20;
    a1.scope = LOCAL_ACHIEVEMENTS;
    a1.affectionKey = OWNER_MONEY;
    a1.achievementImage = @"coin.png";
    a1.rewardMethod = ^(Owner *owner, Pet *pet, NSMutableDictionary *storage) {
        if(pet.lvl < MAX_LEVEL)
            pet.exp += 2;
    };
    [achievements addObject:a1];
    
    Achievement *a2 = [[Achievement alloc] init];
    a2.title = @"Getting richer";
    a2.achievementDescription = @"Have 50 Money";
    a2.progress = 10;
    a2.rewardDescription = @"+5 XP";
    a2.isAchieved = NO;
    a2.goal = 50;
    a2.scope = LOCAL_ACHIEVEMENTS;
    a2.affectionKey = OWNER_MONEY;
    a2.achievementImage = @"coin.png";
    a2.rewardMethod = ^(Owner *owner, Pet *pet, NSMutableDictionary *storage) {
        if(pet.lvl < MAX_LEVEL)
            pet.exp += 5;
    };
    [achievements addObject:a2];
    
    Achievement *a3 = [[Achievement alloc] init];
    a3.title = @"You shouldn't drink so much";
    a3.achievementDescription = @"Fed the pet Alcohol 3 times in a row";
    a3.progress = 0;
    a3.rewardDescription = @"+2 Water";
    a3.isAchieved = NO;
    a3.goal = 3;
    a3.scope = LOCAL_ACHIEVEMENTS;
    a3.affectionKey = ALCOHOL_FED;
    a3.achievementImage = @"beer.png";
    a3.rewardMethod = ^(Owner *owner, Pet *pet, NSMutableDictionary *storage) {
        NSInteger quantity = [[storage objectForKey:FOOD_WATER] integerValue];
        quantity = quantity + 2;
        NSNumber *number = [NSNumber numberWithInteger:quantity];
        [storage setValue:number forKey:FOOD_WATER];
    };
    [achievements addObject:a3];
    
    if(slot != nil && [Loader loadLocalAchievements:slot] == nil)
        [Saver saveChangeOn:LOCAL_ACHIEVEMENTS withValue:achievements atSaveSlot:slot];
    
    return achievements;
}

-(NSMutableArray *)createGlobalAchievements {
    NSMutableArray *achievements = [[NSMutableArray alloc] init];
    Achievement *a1 = [[Achievement alloc] init];
    a1.title = @"Critter beginner";
    a1.achievementDescription = @"Reach Level 3 with Critter";
    a1.progress = 1;
    a1.rewardDescription = @"n/A";
    a1.isAchieved = NO;
    a1.goal = 3;
    a1.scope = GLOBAL_ACHIEVEMENTS;
    a1.affectionKey = PET_LEVEL_CRITTER;
    a1.achievementImage = @"Critter_calm_1.png";
    a1.rewardMethod = ^(Owner *owner, Pet *pet, NSMutableDictionary *storage) {
        
    };
    [achievements addObject:a1];
    
    Achievement *a2 = [[Achievement alloc] init];
    a2.title = @"Montie beginner";
    a2.achievementDescription = @"Reach Level 3 with Critter";
    a2.progress = 1;
    a2.rewardDescription = @"n/A";
    a2.isAchieved = NO;
    a2.goal = 3;
    a2.scope = GLOBAL_ACHIEVEMENTS;
    a2.affectionKey = PET_LEVEL_MONTIE;
    a2.achievementImage = @"Montie_calm_1.png";
    a2.rewardMethod = ^(Owner *owner, Pet *pet, NSMutableDictionary *storage) {
        
    };
    [achievements addObject:a2];
    
    if([Loader loadGlobalAchievements] == nil)
        [Saver saveChangeOn:GLOBAL_ACHIEVEMENTS withValue:achievements atSaveSlot:nil];
    
    return achievements;
}

@end
