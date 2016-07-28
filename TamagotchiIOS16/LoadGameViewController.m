//
//  LoadGameViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 28.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadGameViewController.h"

@implementation LoadGameViewController {

}
-(void)viewDidLoad {
    NSDictionary *slot1 = [Loader loadSlot:SAVE_SLOT_1];
    NSDictionary *slot2 = [Loader loadSlot:SAVE_SLOT_2];
    NSDictionary *slot3 = [Loader loadSlot:SAVE_SLOT_3];
    NSDictionary *slot4 = [Loader loadSlot:SAVE_SLOT_4];
    Owner *owner;
    Pet *pet;
    //fill in slot data
    if(slot1 != nil) {
        owner = [slot1 objectForKey:OWNER];
        pet = [slot1 objectForKey:PET];
        self.slot1UserName.text = owner.name;
        self.slot1money.text = [[NSNumber numberWithInteger:owner.money] stringValue];
        self.slot1Lives.text = [[NSNumber numberWithInteger:pet.lives] stringValue];
        self.slot1PetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_calm_1.png", pet.type]];
    }
    
    if(slot2 != nil) {
        owner = [slot2 objectForKey:OWNER];
        pet = [slot2 objectForKey:PET];
        self.slot2UserName.text = owner.name;
        self.slot2money.text = [[NSNumber numberWithInteger:owner.money] stringValue];
        self.slot2Lives.text = [[NSNumber numberWithInteger:pet.lives] stringValue];
        self.slot2PetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_calm_1.png", pet.type]];
    }
    
    if(slot3 != nil) {
        owner = [slot3 objectForKey:OWNER];
        pet = [slot3 objectForKey:PET];
        self.slot3UserName.text = owner.name;
        self.slot3money.text = [[NSNumber numberWithInteger:owner.money] stringValue];
        self.slot3Lives.text = [[NSNumber numberWithInteger:pet.lives] stringValue];
        self.slot3PetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_calm_1.png", pet.type]];
    }
    
    if(slot4 != nil) {
        owner = [slot4 objectForKey:OWNER];
        pet = [slot4 objectForKey:PET];
        self.slot4UserName.text = owner.name;
        self.slot4money.text = [[NSNumber numberWithInteger:owner.money] stringValue];
        self.slot4Lives.text = [[NSNumber numberWithInteger:pet.lives] stringValue];
        self.slot4PetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_calm_1.png", pet.type]];
    }
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString: @"startLoadedGame"]) {

        GameViewController *gameViewController = (GameViewController *) [segue destinationViewController];
        //gameViewController.owner = self.owner;
        //gameViewController.pet = self.pet;
        //gameViewController.storage = self.storage;
        //gameViewController.foodList = self.foodList;
        //gameViewController.drinkList = self.drinkList;
        //gameViewController.storeFood = self.storeFood;
    }
}

- (IBAction)loadSlotToGame:(UIButton *)sender {
    //init data to gamescreencontroller
    //with selected slot name
}

- (IBAction)deleteSlot:(UIButton *)sender {
    //remove slot from userdefaults and update gui
}
@end