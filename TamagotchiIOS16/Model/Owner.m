//
//  NSObject+Owner.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 25.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import "Owner.h"

@implementation Owner
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeInteger:self.money forKey:@"money"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if(self) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.money = [coder decodeIntegerForKey:@"money"];
    }
    return self;
}
@end
