//
//  NotificationRequest.m
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationRequest.h"

@implementation NotificationRequest

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.subject forKey:@"subject"];
    [coder encodeObject:self.message forKey:@"message"];
    [coder encodeObject:self.timestamp forKey:@"timestamp"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if(self) {
        self.subject = [coder decodeObjectForKey:@"subject"];
        self.message = [coder decodeObjectForKey:@"message"];
        self.timestamp = [coder decodeObjectForKey:@"timestamp"];
    }
    return self;
}

@end
