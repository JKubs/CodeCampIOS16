//
//  Achievement.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 16.08.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "Saver.h"

#define ALCOHOL_FED @"alcoholfed"

@interface Achievement : NSObject <NSCoding>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *achievementDescription;
@property NSInteger progress;
@property void (^rewardMethod)(Owner *owner, Pet *pet, NSMutableDictionary *storage);
@property (strong, nonatomic) NSString *rewardDescription;
@property BOOL isAchieved;
@property (strong, nonatomic) NSString *affectionKey;
@property NSInteger goal;
@property (strong, nonatomic) NSString *scope;
@property (strong, nonatomic) NSString *achievementImage;

-(void)encodeWithCoder:(NSCoder *)aCoder;
-(instancetype)initWithCoder:(NSCoder *)aDecoder;
-(BOOL)isAffected:(NSString*)byKey;
-(BOOL)bookProgress:(NSInteger)newValue;

@end