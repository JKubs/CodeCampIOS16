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

    if (self.globalAchievements == nil) self.globalAchievements = [self createGlobalAchievements];
    
    
    
    //[[UIAccelerometer sharedAccelerometer]setDelegate:self];
}

-(void)viewDidAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;
    
    [self updateAchievementProgress];
    if([Loader loadFlag:HORRIBLE_SHAME]) {
        self.leftPetImage.image = [UIImage imageNamed:@"Critter_dead.png"];
        self.rightPetImage.image = [UIImage imageNamed:@"Montie_dead.png"];
    }
    else {
        self.leftPetImage.image = [UIImage imageNamed:@"Critter_calm_1.png"];
        self.rightPetImage.image = [UIImage imageNamed:@"Montie_calm_1.png"];
        self.timer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector: @selector(nextFrame:) userInfo: nil repeats: YES];
    }
    [super viewDidAppear:animated];
}

-(void)updateAchievementProgress {
    NSMutableArray* loadedGlobal = [Loader loadGlobalAchievements];
    int i = 0;
    for (Achievement* emptyAchv in self.globalAchievements) {
        Achievement *fillingAchv = [loadedGlobal objectAtIndex:i];
        if([emptyAchv.title isEqualToString:fillingAchv.title]) {
            if([emptyAchv.affectionKey isEqualToString:PET_DEATHS]) {
                emptyAchv.progress = fillingAchv.progress;
                if(emptyAchv.progress >= emptyAchv.goal) {
                    emptyAchv.progress = emptyAchv.goal;
                    emptyAchv.isAchieved = YES;
                }
            }
            else [emptyAchv bookProgress:fillingAchv.progress];
        }
        i++;
    }
    
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
        if(self.timer != nil) {
            [self.timer invalidate];
            self.timer = nil;
        }
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
        gameViewController.slotChanged = NO;
        gameViewController.globalAchievements = self.globalAchievements;
        gameViewController.notificationRequests = [Loader loadSavedNotificationsFromSlot:lastUsedSlot];
        //self.localAchievements = [Loader loadLocalAchievements:lastUsedSlot];
        if (self.localAchievements == nil) self.localAchievements = [self createLocalAchievementsForSlot:lastUsedSlot];
        gameViewController.localAchievements = self.localAchievements;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PetAnimation" object:self];
    }
    else if ([segueName isEqualToString: @"newloadGame"]) {
        if(self.timer != nil) {
            [self.timer invalidate];
            self.timer = nil;
        }
        LoadGameViewController *controller = (LoadGameViewController *) [segue destinationViewController];
        controller.localAchievements = [self createLocalAchievementsForSlot:nil];
        controller.globalAchievements = self.globalAchievements;
    }
    else if ([segueName isEqualToString: @"achievements"]) {
        if(self.timer != nil) {
            [self.timer invalidate];
            self.timer = nil;
        }
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
    
    [achievements addObject:a1];
    [achievements addObject:a2];
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
    a1.rewardDescription = @"none";
    a1.isAchieved = NO;
    a1.goal = 3;
    a1.scope = GLOBAL_ACHIEVEMENTS;
    a1.affectionKey = PET_LEVEL_CRITTER;
    a1.achievementImage = @"Critter_calm_1.png";
    a1.rewardMethod = ^(Owner *owner, Pet *pet, NSMutableDictionary *storage) {
        
    };
    
    Achievement *a2 = [[Achievement alloc] init];
    a2.title = @"Montie beginner";
    a2.achievementDescription = @"Reach Level 3 with Critter";
    a2.progress = 1;
    a2.rewardDescription = @"none";
    a2.isAchieved = NO;
    a2.goal = 3;
    a2.scope = GLOBAL_ACHIEVEMENTS;
    a2.affectionKey = PET_LEVEL_MONTIE;
    a2.achievementImage = @"Montie_calm_1.png";
    a2.rewardMethod = ^(Owner *owner, Pet *pet, NSMutableDictionary *storage) {
        
    };
    
    
    Achievement *a3 = [[Achievement alloc] init];
    a3.title = @"Critter master";
    a3.achievementDescription = [NSString stringWithFormat:@"Reach Level %d with Critter", MAX_LEVEL];
    a3.progress = 1;
    a3.rewardDescription = @"none";
    a3.isAchieved = NO;
    a3.goal = MAX_LEVEL;
    a3.scope = GLOBAL_ACHIEVEMENTS;
    a3.affectionKey = PET_LEVEL_CRITTER;
    a3.achievementImage = @"Critter_calm_1.png";
    a3.rewardMethod = ^(Owner *owner, Pet *pet, NSMutableDictionary *storage) {
        
    };
    
    
    Achievement *a4 = [[Achievement alloc] init];
    a4.title = @"Montie master";
    a4.achievementDescription = [NSString stringWithFormat:@"Reach Level %d with Montie", MAX_LEVEL];
    a4.progress = 1;
    a4.rewardDescription = @"none";
    a4.isAchieved = NO;
    a4.goal = MAX_LEVEL;
    a4.scope = GLOBAL_ACHIEVEMENTS;
    a4.affectionKey = PET_LEVEL_MONTIE;
    a4.achievementImage = @"Montie_calm_1.png";
    a4.rewardMethod = ^(Owner *owner, Pet *pet, NSMutableDictionary *storage) {
        
    };
    
    
    Achievement *a5 = [[Achievement alloc] init];
    a5.title = @"Horrible parent";
    a5.achievementDescription = @"Let your pet die 3 times";
    a5.progress = 0;
    a5.rewardDescription = @"Horrible shame";
    a5.isAchieved = NO;
    a5.goal = 3;
    a5.scope = GLOBAL_ACHIEVEMENTS;
    a5.affectionKey = PET_DEATHS;
    a5.achievementImage = @"gravestone.png";
    a5.rewardMethod = ^(Owner *owner, Pet *pet, NSMutableDictionary *storage) {
        [Saver saveFlag:HORRIBLE_SHAME];
    };
    
    
    [achievements addObject:a1];
    [achievements addObject:a3];
    [achievements addObject:a2];
    [achievements addObject:a4];
    [achievements addObject:a5];
    
    
    if([Loader loadGlobalAchievements] == nil)
        [Saver saveChangeOn:GLOBAL_ACHIEVEMENTS withValue:achievements atSaveSlot:nil];
    
    return achievements;
}

@end
