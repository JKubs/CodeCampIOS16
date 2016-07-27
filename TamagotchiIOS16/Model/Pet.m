//
//  NSObject+Pet.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "Pet.h"

@interface Pet ()

@end

@implementation Pet

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeInteger:self.lives forKey:@"lives"];
    [coder encodeObject:self.currentWish forKey:@"currentWish"];

}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if(self) {
        self.type = [coder decodeObjectForKey:@"type"];
        self.lives = [coder decodeIntegerForKey:@"lives"];
        self.currentWish = [coder decodeObjectForKey:@"currentWish"];
    }
    return self;
}

@end
