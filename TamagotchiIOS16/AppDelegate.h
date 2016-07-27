//
//  AppDelegate.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "Saver.h"
#import "Loader.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GameViewController *gameController;

- (void)findGameController;
- (void)generateRandomNeed:(NSDate*) date;
- (void)checkForMissedNotifications;

@end

