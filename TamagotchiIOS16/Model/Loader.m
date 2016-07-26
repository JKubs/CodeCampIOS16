//
//  Loader.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "Loader.h"

@implementation Loader

+(BOOL)loadSaveStateTo:(GameViewController *)controller {
    
    NSDictionary *slot = [[NSUserDefaults standardUserDefaults] dictionaryForKey:controller.saveSlot];
    
    Owner *owner =  [slot objectForKey:OWNER];
    Pet *pet =  [slot objectForKey:PET];
    
    
    controller.owner = owner;
    controller.pet = pet;
    
    return YES;
}

@end
