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
    if([self isClearStart]) {
        self.continueButton.hidden = YES;
    }
}

- (IBAction)continueGame:(UIButton *)sender {
}

- (IBAction)loadGame:(UIButton *)sender {
}

- (IBAction)newGame:(UIButton *)sender {
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString: @"startLoadedGame"]) {
        NSString *lastUsedSlot = [Loader loadLastUsedSlot];
        NSDictionary *slot = [Loader loadSlot:lastUsedSlot];
        Owner *owner = [slot objectForKey:OWNER];
        Pet *pet = [slot objectForKey:PET];
        NSMutableDictionary *storage = [slot objectForKey:STORAGE];
        
        GameViewController *gameViewController = (GameViewController *) [segue destinationViewController];
        gameViewController.owner = owner;
        gameViewController.pet = pet;
        gameViewController.storage = storage;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PetAnimation" object:self];
    }
    else if ([segueName isEqualToString: @"startLoadedGame"]) {
        
    }
}

-(BOOL)isClearStart {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:SAVE_SLOT_1] == nil &&
    [[NSUserDefaults standardUserDefaults] dictionaryForKey:SAVE_SLOT_2] == nil &&
    [[NSUserDefaults standardUserDefaults] dictionaryForKey:SAVE_SLOT_3] == nil &&
    [[NSUserDefaults standardUserDefaults] dictionaryForKey:SAVE_SLOT_4] == nil;
}
@end
