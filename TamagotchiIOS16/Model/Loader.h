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

@interface Loader : NSObject

+(BOOL)loadSaveStateTo:(GameViewController *)controller;

@end
