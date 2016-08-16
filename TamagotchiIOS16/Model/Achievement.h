//
//  Achievement.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 16.08.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Achievement : NSObject <NSCoding>

@property (weak, nonatomic) NSString *title;
@property (weak, nonatomic) NSString *achievementDescription;
@property NSInteger progress;
@property void (^rewardMethod)(void);
@property (weak, nonatomic) NSString *rewardDescription;
@property BOOL isAchieved;
@property NSInteger goal;
@property (weak, nonatomic) NSString *scope;

-(void)encodeWithCoder:(NSCoder *)aCoder;
-(instancetype)initWithCoder:(NSCoder *)aDecoder;
-(BOOL)isAffected:(NSString*)byKey;
-(void)bookProgress:(NSInteger)newValue;

@end