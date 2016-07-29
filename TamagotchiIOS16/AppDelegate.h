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
#import "NotificationCreater.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GameViewController *gameController;
@property (strong, nonatomic) NSMutableArray *firstStartNotiRequ;
@property (assign) BOOL firstStart;
@property (assign) BOOL gotStartedGameBool;
@property (strong, nonatomic) NSDictionary *gameControllerDic;

- (void)gotStartedGame;
- (void)findGameController;
- (NSMutableArray*)deleteMissedNotifications:(NSMutableArray*) notificationRequests;
- (BOOL)isClearStart;

@end

