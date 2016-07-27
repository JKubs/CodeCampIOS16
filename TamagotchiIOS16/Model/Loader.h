//
//  Loader.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameViewController.h"
#import "Saver.h"

@class GameViewController;

@interface Loader : NSObject

+(BOOL)loadSaveStateTo:(GameViewController *)controller;
+(NSString*)loadLastUsedSlot;
+(NSArray*)loadSavedNotifications;

@end
