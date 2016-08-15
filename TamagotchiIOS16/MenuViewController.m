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
    self.leftPetImage.image = [UIImage imageNamed:@"Critter_calm_1.png"];
    self.rightPetImage.image = [UIImage imageNamed:@"Montie_calm_1.png"];
    [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector: @selector(nextFrame:) userInfo: nil repeats: YES];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PetAnimation" object:self];
    }
    else if ([segueName isEqualToString: @"newloadGame"]) {
        
    }
}

-(BOOL)isClearStart {
    return [Loader loadLastUsedSlotString] == nil;
}
@end
