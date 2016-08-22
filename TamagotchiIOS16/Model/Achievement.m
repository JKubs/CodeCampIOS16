//
//  Achievement.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 16.08.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Achievement.h"

@interface Achievement ()

@end

@implementation Achievement

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.title forKey:@"title"];
    //[coder encodeObject:self.achievementDescription forKey:@"desription"];
    //[coder encodeObject:self.rewardMethod forKey:@"rewardMethod"];
    //[coder encodeObject:self.rewardDescription forKey:@"rewardDescription"];
    //[coder encodeBool:self.isAchieved forKey:@"isAchieved"];
    [coder encodeInteger:self.progress forKey:@"progress"];
    //[coder encodeInteger:self.goal forKey:@"goal"];
    //[coder encodeObject:self.scope forKey:@"scope"];
    //[coder encodeObject:self.affectionKey forKey:@"affectionKey"];
    //[coder encodeObject:self.achievementImage forKey:@"image"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if(self) {
        self.title = [coder decodeObjectForKey:@"title"];
        //self.achievementDescription = [coder decodeObjectForKey:@"description"];
        //self.rewardMethod = [coder decodeObjectForKey:@"rewardMethod"];
        //self.rewardDescription = [coder decodeObjectForKey:@"rewardDescription"];
        //self.isAchieved = [coder decodeBoolForKey:@"isAchieved"];
        self.progress = [coder decodeIntegerForKey:@"progress"];
        //self.goal = [coder decodeIntegerForKey:@"goal"];
        //self.scope = [coder decodeObjectForKey:@"scope"];
        //self.affectionKey = [coder decodeObjectForKey:@"affectionKey"];
        //self.achievementImage = [coder decodeObjectForKey:@"image"];
    }
    return self;
}

-(BOOL)isAffected:(NSString *)byKey {
    return [self.affectionKey isEqualToString:byKey];
}

-(BOOL)bookProgress:(NSInteger)newValue {
    if([self.affectionKey isEqualToString: ALCOHOL_FED]) {
        self.progress = newValue;
        if(self.progress >= self.goal) {
            self.progress = self.goal;
            self.isAchieved = YES;
            //[self rewardMethod];
        }
        return YES;
    }
    else if(newValue > self.progress) {
        self.progress = newValue;
        if(self.progress >= self.goal) {
            self.progress = self.goal;
            self.isAchieved = YES;
            //[self rewardMethod];
        }
        return YES;
    }
    return NO;
}

@end