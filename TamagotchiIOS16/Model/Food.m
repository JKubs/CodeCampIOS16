//
//  NSObject+Food.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "Food.h"

@implementation Food
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.cost forKey:@"cost"];
    [coder encodeInteger:self.expReward forKey:@"exp"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if(self) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.cost = [coder decodeIntegerForKey:@"cost"];
        self.expReward = [coder decodeIntegerForKey:@"exp"];
    }
    return self;
}
@end
