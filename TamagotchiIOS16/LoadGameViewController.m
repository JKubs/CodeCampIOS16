//
//  LoadGameViewController.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 28.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadGameViewController.h"
#import "NewGameViewController.h"

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
        if(pet.lives == 0) {
            self.slot1isDead = YES;
            self.slot1PetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_dead.png", pet.type]];
        }
        else {
            self.slot1isDead = NO;
            self.slot1PetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_calm_1.png", pet.type]];
            self.slot1Lives.text = [[NSNumber numberWithInteger:pet.lives] stringValue];
        }
        self.slot1XP.text = [[NSNumber numberWithInteger:pet.exp] stringValue];
        self.slot1lvl.text = [[NSNumber numberWithInteger:pet.lvl] stringValue];
        self.slot1UserName.text = owner.name;
        self.slot1money.text = [[NSNumber numberWithInteger:owner.money] stringValue];
    }
    else {
        self.slot1UserName.text = @"empty";
        self.slot1Content.hidden = YES;
    }
    
    if(slot2 != nil) {
        owner = [slot2 objectForKey:OWNER];
        pet = [slot2 objectForKey:PET];

        if(pet.lives == 0) {
            self.slot2isDead = YES;
            self.slot2PetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_dead.png", pet.type]];
        }
        else {
            self.slot2isDead = NO;
            self.slot2PetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_calm_1.png", pet.type]];
            self.slot2Lives.text = [[NSNumber numberWithInteger:pet.lives] stringValue];
        }
        self.slot2XP.text = [[NSNumber numberWithInteger:pet.exp] stringValue];
        self.slot2lvl.text = [[NSNumber numberWithInteger:pet.lvl] stringValue];
        self.slot2UserName.text = owner.name;
        self.slot2money.text = [[NSNumber numberWithInteger:owner.money] stringValue];
    }
    else {
        self.slot2UserName.text = @"empty";
        self.slot2Content.hidden = YES;
    }
    
    if(slot3 != nil) {
        owner = [slot3 objectForKey:OWNER];
        pet = [slot3 objectForKey:PET];
        if(pet.lives == 0) {
            self.slot3isDead = YES;
            self.slot3PetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_dead.png", pet.type]];
        }
        else {
            self.slot3isDead = NO;
            self.slot3PetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_calm_1.png", pet.type]];
            self.slot3Lives.text = [[NSNumber numberWithInteger:pet.lives] stringValue];
        }
        self.slot3XP.text = [[NSNumber numberWithInteger:pet.exp] stringValue];
        self.slot3lvl.text = [[NSNumber numberWithInteger:pet.lvl] stringValue];
        self.slot3UserName.text = owner.name;
        self.slot3money.text = [[NSNumber numberWithInteger:owner.money] stringValue];
    }
    else {
        self.slot3UserName.text = @"empty";
        self.slot3Content.hidden = YES;
    }
    
    if(slot4 != nil) {
        owner = [slot4 objectForKey:OWNER];
        pet = [slot4 objectForKey:PET];
        if(pet.lives == 0) {
            self.slot4isDead = YES;
            self.slot4PetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_dead.png", pet.type]];
        }
        else {
            self.slot4isDead = NO;
            self.slot4PetImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_calm_1.png", pet.type]];
            self.slot4Lives.text = [[NSNumber numberWithInteger:pet.lives] stringValue];
        }
        self.slot4XP.text = [[NSNumber numberWithInteger:pet.exp] stringValue];
        self.slot4lvl.text = [[NSNumber numberWithInteger:pet.lvl] stringValue];
        self.slot4UserName.text = owner.name;
        self.slot4money.text = [[NSNumber numberWithInteger:owner.money] stringValue];
        
    }
    else {
        self.slot4UserName.text = @"empty";
        self.slot4Content.hidden = YES;
    }
    self.loadButton.enabled = NO;
    self.deleteButton.enabled = NO;
    self.createButton.enabled = NO;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *segueName = segue.identifier;
    if ([segueName isEqualToString: @"startLoadedGame"]) {
        
        NSDictionary *slot = [Loader loadSlot:self.selectedSlot];
        Owner *owner = [slot objectForKey:OWNER];
        Pet *pet = [slot objectForKey:PET];
        NSMutableDictionary *storage = [slot objectForKey:STORAGE];
        NSMutableArray *notificationRequests = [Loader loadSavedNotificationsFromSlot:self.selectedSlot];
        
        GameViewController *gameViewController = (GameViewController *) [segue destinationViewController];
        gameViewController.owner = owner;
        gameViewController.pet = pet;
        gameViewController.storage = storage;
        gameViewController.notificationRequests = notificationRequests;
        gameViewController.saveSlot = self.selectedSlot;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PetAnimation" object:self];
    }
    else if ([segueName isEqualToString: @"createGame"]) {
     
        NewGameViewController *controller = (NewGameViewController *) [segue destinationViewController];
        controller.saveSlot = self.selectedSlot;
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PetAnimation" object:self];
    }

}


- (IBAction)deleteSlot:(UIButton *)sender {
    [Saver deleteSlot:self.selectedSlot];
    self.selectedUserName.text = @"empty";
    self.selectedPetImage.image = nil;
    
    self.selectedView.hidden = YES;
    self.loadButton.enabled = NO;
    self.deleteButton.enabled = NO;
    self.createButton.enabled = YES;
}

- (IBAction)slot1pressed:(UIView *)sender {
    self.slot1View.alpha = 1.0f;
    self.slot2View.alpha = 0.5f;
    self.slot3View.alpha = 0.5f;
    self.slot4View.alpha = 0.5f;
    self.selectedSlot = SAVE_SLOT_1;
    self.selectedView = self.slot1Content;
    if(self.slot1PetImage.image == nil) {
        self.createButton.enabled = YES;
        self.loadButton.enabled = NO;
        self.deleteButton.enabled = NO;
    }
    else if(self.slot1isDead) {
        self.createButton.enabled = NO;
        self.loadButton.enabled = NO;
        self.deleteButton.enabled = YES;
    }
    else {
        self.loadButton.enabled = YES;
        self.deleteButton.enabled = YES;
        self.createButton.enabled = NO;
    }

    self.selectedUserName = self.slot1UserName;
    self.selectedPetImage = self.slot1PetImage;
}

- (IBAction)slot2pressed:(UIButton *)sender {
    self.slot1View.alpha = 0.5f;
    self.slot2View.alpha = 1.0f;
    self.slot3View.alpha = 0.5f;
    self.slot4View.alpha = 0.5f;
    self.selectedSlot = SAVE_SLOT_2;
    self.selectedView = self.slot2Content;
    if(self.slot2PetImage.image == nil) {
        self.createButton.enabled = YES;
        self.loadButton.enabled = NO;
        self.deleteButton.enabled = NO;
    }
    else if(self.slot2isDead) {
        self.createButton.enabled = NO;
        self.loadButton.enabled = NO;
        self.deleteButton.enabled = YES;
    }
    else {
        self.loadButton.enabled = YES;
        self.deleteButton.enabled = YES;
        self.createButton.enabled = NO;
    }

    self.selectedUserName = self.slot2UserName;
    self.selectedPetImage = self.slot2PetImage;

}

- (IBAction)slot3pressed:(UIButton *)sender {
    self.slot1View.alpha = 0.5f;
    self.slot2View.alpha = 0.5f;
    self.slot3View.alpha = 1.0f;
    self.slot4View.alpha = 0.5f;
    self.selectedSlot = SAVE_SLOT_3;
    self.selectedView = self.slot3Content;
    if(self.slot3PetImage.image == nil) {
        self.createButton.enabled = YES;
        self.loadButton.enabled = NO;
        self.deleteButton.enabled = NO;
    }
    else if(self.slot3isDead) {
        self.createButton.enabled = NO;
        self.loadButton.enabled = NO;
        self.deleteButton.enabled = YES;
    }
    else {
        self.loadButton.enabled = YES;
        self.deleteButton.enabled = YES;
        self.createButton.enabled = NO;
    }

    self.selectedUserName = self.slot3UserName;
    self.selectedPetImage = self.slot3PetImage;

}

- (IBAction)slot4pressed:(UIButton *)sender {
    self.slot1View.alpha = 0.5f;
    self.slot2View.alpha = 0.5f;
    self.slot3View.alpha = 0.5f;
    self.slot4View.alpha = 1.0f;
    self.selectedSlot = SAVE_SLOT_4;
    self.selectedView = self.slot4Content;
    if(self.slot4PetImage.image == nil) {
        self.createButton.enabled = YES;
        self.loadButton.enabled = NO;
        self.deleteButton.enabled = NO;
    }
    else if(self.slot4isDead) {
        self.createButton.enabled = NO;
        self.loadButton.enabled = NO;
        self.deleteButton.enabled = YES;
    }
    else {
        self.loadButton.enabled = YES;
        self.deleteButton.enabled = YES;
        self.createButton.enabled = NO;
    }

    self.selectedUserName = self.slot4UserName;
    self.selectedPetImage = self.slot4PetImage;
}

- (IBAction)empty1pressed:(UIButton *)sender {
    [self slot1pressed:sender];
}

- (IBAction)empty2pressed:(UIButton *)sender {
    [self slot2pressed:sender];
}

- (IBAction)empty3pressed:(UIButton *)sender {
    [self slot3pressed:sender];
}

- (IBAction)empty4pressed:(UIButton *)sender {
    [self slot4pressed:sender];
}



@end