//
//  NotificationRequest.h
//  TamagotchiIOS16
//
//  Created by Codecamp on 26.07.16.
//  Copyright © 2016 Codecamp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationRequest : NSObject <NSCoding>

@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSDate *timestamp;
@property (nonatomic) NSTimeInterval diff;

-(void)encodeWithCoder:(NSCoder *)aCoder;
-(instancetype)initWithCoder:(NSCoder *)aDecoder;

@end
